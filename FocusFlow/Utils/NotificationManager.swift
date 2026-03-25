import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error)")
            }
        }
    }
    
    func scheduleFocusReminder() {
        let content = UNMutableNotificationContent()
        content.title = "开始专注时间"
        content.body = "准备好开始一次专注训练了吗？"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "focusReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleTaskReminder(for taskTitle: String, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "任务提醒"
        content.body = "别忘了完成：\(taskTitle)"
        content.sound = .default
        
        let triggerDate = date.addingTimeInterval(-300) // 5 minutes before
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
