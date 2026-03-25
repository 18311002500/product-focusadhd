import Foundation
import StoreKit
import Combine

/// IAP产品类型
enum IAPProductType: String, CaseIterable {
    case lifetimeUnlock = "com.focusflow.lifetime"  // $9.99 终身解锁
    case monthlySubscription = "com.focusflow.monthly" // $2.99/月 订阅
    
    static let allProductIDs = [lifetimeUnlock.rawValue, monthlySubscription.rawValue]
}

/// 付费功能类型
enum PremiumFeature {
    case unlimitedTasks
    case advancedBadges
    case detailedStats
    case cloudBackup
    case customThemes
    
    var title: String {
        switch self {
        case .unlimitedTasks: return "无限任务"
        case .advancedBadges: return "高级徽章"
        case .detailedStats: return "详细统计"
        case .cloudBackup: return "云备份"
        case .customThemes: return "自定义主题"
        }
    }
    
    var description: String {
        switch self {
        case .unlimitedTasks: return "创建无限数量的任务，不受限制"
        case .advancedBadges: return "解锁专属高级徽章"
        case .detailedStats: return "查看详细的数据分析和历史记录"
        case .cloudBackup: return "通过iCloud备份和恢复数据"
        case .customThemes: return "使用自定义颜色和主题"
        }
    }
    
    var icon: String {
        switch self {
        case .unlimitedTasks: return "checklist"
        case .advancedBadges: return "medal.star"
        case .detailedStats: return "chart.bar.fill"
        case .cloudBackup: return "icloud.and.arrow.up"
        case .customThemes: return "paintpalette"
        }
    }
}

/// 购买状态
enum PurchaseStatus {
    case notStarted
    case inProgress
    case completed
    case failed(Error)
    case restored
}

/// 订阅状态
enum SubscriptionStatus: Equatable {
    case notPurchased
    case lifetime
    case activeMonthly(expirationDate: Date)
    case expired
    
    var isPremium: Bool {
        switch self {
        case .lifetime, .activeMonthly:
            return true
        default:
            return false
        }
    }
    
    var displayText: String {
        switch self {
        case .notPurchased:
            return "免费版"
        case .lifetime:
            return "终身会员"
        case .activeMonthly:
            return "月度会员"
        case .expired:
            return "已过期"
        }
    }
}

/// IAP管理器 - 使用StoreKit 2
@MainActor
class IAPManager: ObservableObject {
    static let shared = IAPManager()
    
    // MARK: - Published Properties
    @Published var products: [Product] = []
    @Published var purchaseStatus: PurchaseStatus = .notStarted
    @Published var subscriptionStatus: SubscriptionStatus = .notPurchased
    @Published var isLoading = false
    
    // MARK: - Private Properties
    private var productIDs: Set<String> = Set(IAPProductType.allProductIDs)
    private var updateListenerTask: Task<Void, Error>?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constants
    private let userDefaults = UserDefaults.standard
    private let subscriptionStatusKey = "subscriptionStatus"
    private let lifetimePurchasedKey = "lifetimePurchased"
    private let expirationDateKey = "subscriptionExpirationDate"
    
    // MARK: - Initialization
    private init() {
        // 启动事务监听
        updateListenerTask = listenForTransactions()
        
        // 加载已保存的购买状态
        loadSavedPurchaseStatus()
        
        // 加载产品
        Task {
            await loadProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Product Loading
    
    /// 从App Store加载产品
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let storeProducts = try await Product.products(for: productIDs)
            products = storeProducts.sorted { $0.price < $1.price }
            print("Loaded \(products.count) products")
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    /// 刷新购买状态
    func refreshPurchaseStatus() async {
        await checkCurrentEntitlements()
    }
    
    // MARK: - Purchase Methods
    
    /// 购买产品
    func purchase(_ product: Product) async -> Bool {
        purchaseStatus = .inProgress
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await handleVerifiedTransaction(transaction)
                    purchaseStatus = .completed
                    return true
                case .unverified(_, let error):
                    purchaseStatus = .failed(error)
                    return false
                }
                
            case .pending:
                purchaseStatus = .inProgress
                return false
                
            case .userCancelled:
                purchaseStatus = .notStarted
                return false
                
            @unknown default:
                purchaseStatus = .notStarted
                return false
            }
        } catch {
            purchaseStatus = .failed(error)
            return false
        }
    }
    
    /// 恢复购买
    func restorePurchases() async -> Bool {
        purchaseStatus = .inProgress
        
        do {
            try await AppStore.sync()
            await checkCurrentEntitlements()
            purchaseStatus = .restored
            return true
        } catch {
            purchaseStatus = .failed(error)
            return false
        }
    }
    
    // MARK: - Transaction Handling
    
    /// 监听未完成的事务
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await verification in Transaction.updates {
                await self.handleTransactionUpdate(verification)
            }
        }
    }
    
    /// 处理事务更新
    private func handleTransactionUpdate(_ verification: VerificationResult<Transaction>) async {
        switch verification {
        case .verified(let transaction):
            await handleVerifiedTransaction(transaction)
        case .unverified(let transaction, let error):
            print("Unverified transaction: \(transaction.id), error: \(error)")
        }
    }
    
    /// 处理已验证的事务
    private func handleVerifiedTransaction(_ transaction: Transaction) async {
        // 更新订阅状态
        await updateSubscriptionStatus(for: transaction)
        
        // 完成事务
        await transaction.finish()
        
        // 通知UI更新
        await MainActor.run {
            objectWillChange.send()
        }
    }
    
    /// 更新订阅状态
    private func updateSubscriptionStatus(for transaction: Transaction) async {
        let productID = transaction.productID
        
        if productID == IAPProductType.lifetimeUnlock.rawValue {
            subscriptionStatus = .lifetime
            savePurchaseStatus()
        } else if productID == IAPProductType.monthlySubscription.rawValue {
            if let expirationDate = transaction.expirationDate {
                if expirationDate > Date() {
                    subscriptionStatus = .activeMonthly(expirationDate: expirationDate)
                } else {
                    subscriptionStatus = .expired
                }
                savePurchaseStatus()
            }
        }
    }
    
    /// 检查当前授权
    private func checkCurrentEntitlements() async {
        for await verification in Transaction.currentEntitlements {
            switch verification {
            case .verified(let transaction):
                await updateSubscriptionStatus(for: transaction)
            case .unverified:
                break
            }
        }
    }
    
    // MARK: - Persistence
    
    /// 保存购买状态
    private func savePurchaseStatus() {
        switch subscriptionStatus {
        case .lifetime:
            userDefaults.set(true, forKey: lifetimePurchasedKey)
        case .activeMonthly(let expirationDate):
            userDefaults.set(expirationDate, forKey: expirationDateKey)
        default:
            userDefaults.removeObject(forKey: lifetimePurchasedKey)
            userDefaults.removeObject(forKey: expirationDateKey)
        }
    }
    
    /// 加载已保存的购买状态
    private func loadSavedPurchaseStatus() {
        // 检查是否购买了终身版
        if userDefaults.bool(forKey: lifetimePurchasedKey) {
            subscriptionStatus = .lifetime
            return
        }
        
        // 检查订阅状态
        if let expirationDate = userDefaults.object(forKey: expirationDateKey) as? Date {
            if expirationDate > Date() {
                subscriptionStatus = .activeMonthly(expirationDate: expirationDate)
            } else {
                subscriptionStatus = .expired
            }
        }
    }
    
    // MARK: - Premium Feature Access
    
    /// 检查是否可以使用付费功能
    func canUsePremiumFeature(_ feature: PremiumFeature) -> Bool {
        return subscriptionStatus.isPremium
    }
    
    /// 检查是否达到免费限制
    func isFreeLimitReached(taskCount: Int) -> Bool {
        // 免费版限制：最多10个任务
        if !subscriptionStatus.isPremium && taskCount >= 10 {
            return true
        }
        return false
    }
    
    /// 检查是否可以访问高级徽章
    func canAccessAdvancedBadges() -> Bool {
        return subscriptionStatus.isPremium
    }
    
    /// 检查是否可以访问详细统计
    func canAccessDetailedStats() -> Bool {
        return subscriptionStatus.isPremium
    }
    
    /// 检查是否可以使用云备份
    func canUseCloudBackup() -> Bool {
        return subscriptionStatus.isPremium
    }
    
    /// 获取价格显示文本
    func priceDisplay(for product: Product) -> String {
        return product.displayPrice
    }
    
    /// 获取产品价格
    func product(for type: IAPProductType) -> Product? {
        return products.first { $0.id == type.rawValue }
    }
}

// MARK: - Convenience Extensions

extension IAPManager {
    /// 终身版产品
    var lifetimeProduct: Product? {
        products.first { $0.id == IAPProductType.lifetimeUnlock.rawValue }
    }
    
    /// 月订阅产品
    var monthlyProduct: Product? {
        products.first { $0.id == IAPProductType.monthlySubscription.rawValue }
    }
    
    /// 是否有活跃订阅
    var isPremium: Bool {
        subscriptionStatus.isPremium
    }
    
    /// 会员状态文本
    var subscriptionStatusText: String {
        subscriptionStatus.displayText
    }
}
