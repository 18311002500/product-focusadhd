import Foundation
import UserNotifications
import UIKit

/// 通知类型
enum NotificationType: String, CaseIterable {
    case focusReminder = "focusReminder"           // 专注提醒
    case taskReminder = "taskReminder"             // 任务提醒
    case dailySummary = "dailySummary"             // 每日总结
    case streakReminder = "streakReminder"         // 连续记录提醒
    case activityReminder = "activityReminder"     // 活动提醒
    case badgeUnlock = "badgeUnlock"               // 徽章解锁
    case premiumOffer = "premiumOffer"             // 付费优惠
    
    var title: String {
        switch self {
        case .focusReminder:
            return "开始专注时间"
        case .taskReminder:
            return "任务提醒"
        case .dailySummary:
            return "今日总结"
        case .streakReminder:
            return "连续记录提醒"
        case .activityReminder:
            return "活动提醒"
        case .badgeUnlock:
            return "解锁新徽章！"
        case .premiumOffer:
            return "限时优惠"
        }
    }
    
    var categoryIdentifier: String {
        return "category_\(self.rawValue)"
    }
}

/// 通知管理器
@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    // MARK: - Published Properties
    @Published var isAuthorized = false
    @Published var pendingNotifications: [UNNotificationRequest] = []
    
    // MARK: - Private Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Settings Keys
    private let notificationsEnabledKey = "notificationsEnabled"
    private let focusReminderTimeKey = "focusReminderTime"
    private let dailySummaryTimeKey = "dailySummaryTime"
    private let activityRemindersEnabledKey = "activityRemindersEnabled"
    
    // MARK: - Initialization
    private init() {
        checkAuthorizationStatus()
        registerNotificationCategories()
    }
    
    // MARK: - Authorization
    
    /// 请求通知权限
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            Task { @MainActor in
                self?.isAuthorized = granted
                if let error = error {
                    print("Notification authorization error: \(error)")
                }
            }
        }
    }
    
    /// 检查授权状态
    func checkAuthorizationStatus() {
        notificationCenter.getNotificationSettings { [weak self] settings in
            Task { @MainActor in
                self?.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Notification Categories
    
    /// 注册通知类别（用于操作按钮）
    private func registerNotificationCategories() {
        // 专注提醒类别 - 带"开始专注"按钮
        let focusAction = UNNotificationAction(
            identifier: "startFocus",
            title: "开始专注",
            options: .foreground
        )
        
        let focusCategory = UNNotificationCategory(
            identifier: NotificationType.focusReminder.categoryIdentifier,
            actions: [focusAction],
            intentIdentifiers: [],
            options: []
        )
        
        // 任务提醒类别 - 带"完成"按钮
        let completeAction = UNNotificationAction(
            identifier: "completeTask",
            title: "完成任务",
            options: .foreground
        )
        
        let taskCategory = UNNotificationCategory(
            identifier: NotificationType.taskReminder.categoryIdentifier,
            actions: [completeAction],
            intentIdentifiers: [],
            options: []
        )
        
        notificationCenter.setNotificationCategories([focusCategory, taskCategory])
    }
    
    // MARK: - Schedule Notifications
    
    /// 预约每日专注提醒
    func scheduleFocusReminder(at hour: Int = 9, minute: Int = 0) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "🌅 早安！开始今天的第一项专注吧"
        content.body = "新的一天，新的进步。准备好开始专注了吗？"
        content.sound = .default
        content.categoryIdentifier = NotificationType.focusReminder.categoryIdentifier
        content.userInfo = ["type": NotificationType.focusReminder.rawValue]
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: NotificationType.focusReminder.rawValue,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling focus reminder: \(error)")
            }
        }
        
        // 保存设置
        userDefaults.set([hour, minute], forKey: focusReminderTimeKey)
    }
    
    /// 预约任务提醒
    func scheduleTaskReminder(for taskTitle: String, taskId: UUID, at date: Date) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "⏰ 任务提醒"
        content.body = "别忘了完成：\(taskTitle)"
        content.sound = .default
        content.categoryIdentifier = NotificationType.taskReminder.categoryIdentifier
        content.userInfo = [
            "type": NotificationType.taskReminder.rawValue,
            "taskId": taskId.uuidString
        ]
        
        let triggerDate = date.addingTimeInterval(-600) // 10分钟前提醒
        let triggerComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: triggerDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "task_\(taskId.uuidString)",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request)
    }
    
    /// 预约每日总结
    func scheduleDailySummary(at hour: Int = 20, minute: Int = 0) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "📊 今日总结"
        content.body = "来看看你今天完成了多少任务吧！"
        content.sound = .default
        content.userInfo = ["type": NotificationType.dailySummary.rawValue]
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: NotificationType.dailySummary.rawValue,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request)
        
        // 保存设置
        userDefaults.set([hour, minute], forKey: dailySummaryTimeKey)
    }
    
    /// 预约连续记录提醒（晚上提醒完成今日任务）
    func scheduleStreakReminder(at hour: Int = 21, minute: Int = 0) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "🔥 连续记录即将中断！"
        content.body = "今天还有未完成的任务，快来完成保持你的连续记录吧！"
        content.sound = .default
        content.userInfo = ["type": NotificationType.streakReminder.rawValue]
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: NotificationType.streakReminder.rawValue,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request)
    }
    
    /// 预约活动提醒
    func scheduleActivityReminder() {
        guard isAuthorized else { return }
        guard userDefaults.bool(forKey: activityRemindersEnabledKey) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "🏃 该活动一下了"
        content.body = "久坐对专注力不好，起来走动一下吧！"
        content.sound = .default
        content.userInfo = ["type": NotificationType.activityReminder.rawValue]
        
        var dateComponents = DateComponents()
        dateComponents.hour = 14
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: NotificationType.activityReminder.rawValue,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request)
    }
    
    /// 发送徽章解锁通知
    func sendBadgeUnlockNotification(badgeName: String, badgeIcon: String) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "\(badgeIcon) 解锁新徽章！"
        content.body = "恭喜你解锁了「\(badgeName)」徽章！"
        content.sound = .default
        content.userInfo = ["type": NotificationType.badgeUnlock.rawValue]
        
        let request = UNNotificationRequest(
            identifier: "\(NotificationType.badgeUnlock.rawValue)_\(UUID().uuidString)",
            content: content,
            trigger: nil // 立即发送
        )
        
        notificationCenter.add(request)
    }
    
    /// 发送专注完成通知
    func sendFocusCompleteNotification(duration: Int) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "🎉 专注完成！"
        content.body = "太棒了！你刚刚完成了 \(duration) 分钟的专注训练"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "focusComplete_\(UUID().uuidString)",
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request)
    }
    
    // MARK: - Cancel Notifications
    
    /// 取消所有通知
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }
    
    /// 取消特定类型的通知
    func cancelNotifications(ofType type: NotificationType) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [type.rawValue])
    }
    
    /// 取消任务通知
    func cancelTaskReminder(taskId: UUID) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["task_\(taskId.uuidString)"])
    }
    
    // MARK: - Get Pending Notifications
    
    /// 获取待发送的通知
    func fetchPendingNotifications() async {
        pendingNotifications = await notificationCenter.pendingNotificationRequests()
    }
    
    // MARK: - Settings
    
    /// 获取专注提醒时间
    var focusReminderTime: (hour: Int, minute: Int) {
        let time = userDefaults.array(forKey: focusReminderTimeTimeKey) as? [Int] ?? [9, 0]
        return (time[0], time[1])
    }
    
    /// 设置是否启用通知
    func setNotificationsEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: notificationsEnabledKey)
        if !enabled {
            cancelAllNotifications()
        }
    }
    
    /// 设置是否启用活动提醒
    func setActivityRemindersEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: activityRemindersEnabledKey)
        if enabled {
            scheduleActivityReminder()
        } else {
            cancelNotifications(ofType: .activityReminder)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    /// 应用在前台时收到通知
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 在前台也显示通知
        completionHandler([.banner, .sound, .badge])
    }
    
    /// 用户点击通知
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        // 处理操作按钮点击
        switch response.actionIdentifier {
        case "startFocus":
            // 打开专注计时器
            NotificationCenter.default.post(name: .openFocusTimer, object: nil)
            
        case "completeTask":
            // 完成任务
            if let taskIdString = userInfo["taskId"] as? String,
               let taskId = UUID(uuidString: taskIdString) {
                NotificationCenter.default.post(name: .completeTask, object: taskId)
            }
            
        default:
            break
        }
        
        completionHandler()
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let openFocusTimer = Notification.Name("openFocusTimer")
    static let completeTask = Notification.Name("completeTask")
}
