import Foundation
import CoreData

// MARK: - Task Entity
@objc(Task)
public class Task: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var notes: String
    @NSManaged public var difficulty: Int16
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var completedAt: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var subtasks: Subtask?
    @NSManaged public var tagsData: Data?
}

extension Task {
    var tags: [String] {
        get {
            guard let data = tagsData else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            tagsData = try? JSONEncoder().encode(newValue)
        }
    }
    
    var difficultyEnum: TaskDifficulty {
        get { TaskDifficulty(rawValue: Int(difficulty)) ?? .easy }
        set { difficulty = Int16(newValue.rawValue) }
    }
}

enum TaskDifficulty: Int, CaseIterable {
    case easy = 0
    case medium = 1
    case hard = 2
    
    var title: String {
        switch self {
        case .easy: return "简单"
        case .medium: return "中等"
        case .hard: return "困难"
        }
    }
    
    var points: Int {
        switch self {
        case .easy: return 10
        case .medium: return 20
        case .hard: return 50
        }
    }
    
    var color: String {
        switch self {
        case .easy: return "#27AE60"
        case .medium: return "#FF6B35"
        case .hard: return "#E91E63"
        }
    }
}

// MARK: - Subtask Entity
@objc(Subtask)
public class Subtask: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subtask> {
        return NSFetchRequest<Subtask>(entityName: "Subtask")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var task: Task?
}

// MARK: - FocusSession Entity
@objc(FocusSession)
public class FocusSession: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FocusSession> {
        return NSFetchRequest<FocusSession>(entityName: "FocusSession")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var startTime: Date
    @NSManaged public var endTime: Date?
    @NSManaged public var duration: Int16
    @NSManaged public var actualDuration: Int16
    @NSManaged public var taskId: UUID?
    @NSManaged public var wasCompleted: Bool
}

// MARK: - Badge Entity
@objc(Badge)
public class Badge: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Badge> {
        return NSFetchRequest<Badge>(entityName: "Badge")
    }
    
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var desc: String
    @NSManaged public var icon: String
    @NSManaged public var isUnlocked: Bool
    @NSManaged public var unlockedAt: Date?
    @NSManaged public var progress: Double
}

// MARK: - UserStats Entity
@objc(UserStats)
public class UserStats: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserStats> {
        return NSFetchRequest<UserStats>(entityName: "UserStats")
    }
    
    @NSManaged public var totalPoints: Int32
    @NSManaged public var currentStreak: Int16
    @NSManaged public var longestStreak: Int16
    @NSManaged public var totalTasksCompleted: Int32
    @NSManaged public var totalFocusMinutes: Int32
    @NSManaged public var plantGrowthLevel: Int16
    @NSManaged public var lastActiveDate: Date?
}

// MARK: - Preview Helpers
extension Task {
    static func preview(context: NSManagedObjectContext) -> Task {
        let task = Task(context: context)
        task.id = UUID()
        task.title = "示例任务"
        task.notes = "这是任务备注"
        task.difficulty = 0
        task.isCompleted = false
        task.createdAt = Date()
        task.dueDate = Date().addingTimeInterval(86400)
        return task
    }
}
