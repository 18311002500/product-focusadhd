import Foundation
import HealthKit
import Combine

/// HealthKit权限类型
enum HealthKitPermission {
    case stepCount
    case activeEnergy
    case workout
    
    var type: HKQuantityType? {
        switch self {
        case .stepCount:
            return HKQuantityType.quantityType(forIdentifier: .stepCount)
        case .activeEnergy:
            return HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
        case .workout:
            return nil // HKWorkoutType is handled separately
        }
    }
}

/// 每日活动数据
struct DailyActivity {
    let date: Date
    let stepCount: Int
    let activeEnergy: Double
    let hasWorkout: Bool
    
    var isActive: Bool {
        stepCount >= 5000 || activeEnergy >= 200 || hasWorkout
    }
}

/// HealthKit管理器
@MainActor
class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    // MARK: - Published Properties
    @Published var isAuthorized = false
    @Published var todaySteps: Int = 0
    @Published var todayActiveEnergy: Double = 0.0
    @Published var isLoading = false
    @Published var authorizationStatus: HKAuthorizationStatus = .notDetermined
    @Published var weeklyActivity: [DailyActivity] = []
    
    // MARK: - Private Properties
    private let healthStore = HKHealthStore()
    private var cancellables = Set<AnyCancellable>()
    private var queryAnchors: [HKObjectType: HKQueryAnchor] = [:]
    
    // MARK: - Types
    private let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    private let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    private let workoutType = HKWorkoutType.workoutType()
    
    // MARK: - Constants
    private let stepsGoal = 5000
    private let energyGoal = 300.0
    
    // MARK: - Initialization
    private init() {
        checkAuthorizationStatus()
    }
    
    // MARK: - Authorization
    
    /// 检查授权状态
    func checkAuthorizationStatus() {
        let status = healthStore.authorizationStatus(for: stepType)
        authorizationStatus = status
        isAuthorized = (status == .sharingAuthorized)
    }
    
    /// 请求HealthKit权限
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthKitError.notAvailable
        }
        
        let typesToRead: Set = [
            stepType,
            energyType,
            workoutType
        ]
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
            checkAuthorizationStatus()
            
            if isAuthorized {
                await fetchTodayData()
                await fetchWeeklyActivity()
            }
        } catch {
            throw HealthKitError.authorizationFailed(error)
        }
    }
    
    // MARK: - Data Fetching
    
    /// 获取今日步数
    func fetchTodaySteps() async -> Int {
        return await fetchQuantityData(for: stepType, unit: HKUnit.count())
    }
    
    /// 获取今日活跃能量
    func fetchTodayActiveEnergy() async -> Double {
        return await fetchQuantityData(for: energyType, unit: HKUnit.kilocalorie())
    }
    
    /// 获取今日所有数据
    func fetchTodayData() async {
        isLoading = true
        defer { isLoading = false }
        
        async let steps = fetchTodaySteps()
        async let energy = fetchTodayActiveEnergy()
        
        todaySteps = await steps
        todayActiveEnergy = await energy
    }
    
    /// 获取本周活动数据
    func fetchWeeklyActivity() async {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -6, to: endDate)!
        
        var activities: [DailyActivity] = []
        
        for dayOffset in 0...<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: endDate) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
            
            async let steps = fetchQuantityData(for: stepType, unit: HKUnit.count(), predicate: predicate)
            async let energy = fetchQuantityData(for: energyType, unit: HKUnit.kilocalorie(), predicate: predicate)
            
            let dailyActivity = DailyActivity(
                date: date,
                stepCount: await steps,
                activeEnergy: await energy,
                hasWorkout: false
            )
            activities.append(dailyActivity)
        }
        
        weeklyActivity = activities.reversed()
    }
    
    /// 通用获取数量数据方法
    private func fetchQuantityData(
        for type: HKQuantityType,
        unit: HKUnit,
        predicate: NSPredicate? = nil
    ) async -> Double {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = Date()
        
        let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let finalPredicate: NSPredicate
        
        if let customPredicate = predicate {
            finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, customPredicate])
        } else {
            finalPredicate = datePredicate
        }
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: finalPredicate,
                options: .cumulativeSum
            ) { _, statistics, error in
                guard let statistics = statistics, let sum = statistics.sumQuantity() else {
                    continuation.resume(returning: 0.0)
                    return
                }
                continuation.resume(returning: sum.doubleValue(for: unit))
            }
            
            healthStore.execute(query)
        }
    }
    
    // MARK: - Activity Reminders
    
    /// 检查是否需要活动提醒
    func shouldShowActivityReminder() -> Bool {
        guard isAuthorized else { return false }
        
        let hour = Calendar.current.component(.hour, from: Date())
        
        // 下午2点后检查
        if hour >= 14 {
            // 如果步数少于目标的一半，建议活动
            return todaySteps < stepsGoal / 2
        }
        
        return false
    }
    
    /// 获取活动建议
    func getActivitySuggestion() -> String {
        let remaining = max(stepsGoal - todaySteps, 0)
        
        if remaining > 3000 {
            return "还差 \(remaining) 步达成今日目标，出去走走吧！🚶"
        } else if remaining > 0 {
            return "还差 \(remaining) 步，再努力一下！💪"
        } else {
            return "太棒了！今日步数目标已达成！🎉"
        }
    }
    
    // MARK: - Progress
    
    /// 步数进度百分比
    var stepsProgress: Double {
        min(Double(todaySteps) / Double(stepsGoal), 1.0)
    }
    
    /// 能量进度百分比
    var energyProgress: Double {
        min(todayActiveEnergy / energyGoal, 1.0)
    }
    
    /// 步数目标
    var dailyStepsGoal: Int {
        stepsGoal
    }
    
    /// 能量目标
    var dailyEnergyGoal: Double {
        energyGoal
    }
}

// MARK: - Errors

enum HealthKitError: LocalizedError {
    case notAvailable
    case authorizationFailed(Error)
    case dataFetchFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "HealthKit 在此设备上不可用"
        case .authorizationFailed(let error):
            return "授权失败: \(error.localizedDescription)"
        case .dataFetchFailed(let error):
            return "获取数据失败: \(error.localizedDescription)"
        }
    }
}

// MARK: - Observer Queries

extension HealthKitManager {
    
    /// 开始监听步数变化
    func startObservingSteps() {
        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { [weak self] _, completionHandler, error in
            if let error = error {
                print("Observer query error: \(error)")
                completionHandler()
                return
            }
            
            Task { @MainActor in
                await self?.fetchTodayData()
            }
            
            completionHandler()
        }
        
        healthStore.execute(query)
    }
    
    /// 停止所有监听
    func stopObserving() {
        // HealthKit会自动管理observer queries的生命周期
    }
}
