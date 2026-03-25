import Foundation
import CoreData
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var todayTasks: [Task] = []
    @Published var completedTasks: [Task] = []
    
    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        fetchTasks()
    }
    
    func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.createdAt, ascending: false)]
        
        do {
            tasks = try context.fetch(request)
            filterTasks()
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    private func filterTasks() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        todayTasks = tasks.filter { task in
            guard !task.isCompleted else { return false }
            if let dueDate = task.dueDate {
                return calendar.startOfDay(for: dueDate) <= today
            }
            return true
        }
        
        completedTasks = tasks.filter { $0.isCompleted }
    }
    
    func createTask(title: String, notes: String = "", difficulty: TaskDifficulty = .easy, dueDate: Date? = nil, tags: [String] = []) -> Task {
        let task = Task(context: context)
        task.id = UUID()
        task.title = title
        task.notes = notes
        task.difficulty = Int16(difficulty.rawValue)
        task.isCompleted = false
        task.createdAt = Date()
        task.dueDate = dueDate
        task.tags = tags
        
        saveContext()
        fetchTasks()
        return task
    }
    
    func completeTask(_ task: Task) {
        task.isCompleted = true
        task.completedAt = Date()
        saveContext()
        fetchTasks()
    }
    
    func uncompleteTask(_ task: Task) {
        task.isCompleted = false
        task.completedAt = nil
        saveContext()
        fetchTasks()
    }
    
    func deleteTask(_ task: Task) {
        context.delete(task)
        saveContext()
        fetchTasks()
    }
    
    func updateTask(_ task: Task, title: String? = nil, notes: String? = nil, difficulty: TaskDifficulty? = nil, dueDate: Date? = nil) {
        if let title = title {
            task.title = title
        }
        if let notes = notes {
            task.notes = notes
        }
        if let difficulty = difficulty {
            task.difficulty = Int16(difficulty.rawValue)
        }
        if let dueDate = dueDate {
            task.dueDate = dueDate
        }
        saveContext()
        fetchTasks()
    }
    
    func getTasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { task in
            guard !task.isCompleted else { return false }
            if let dueDate = task.dueDate {
                return calendar.isDate(dueDate, inSameDayAs: date)
            }
            return false
        }
    }
    
    func getCompletedTasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { task in
            guard task.isCompleted else { return false }
            if let completedAt = task.completedAt {
                return calendar.isDate(completedAt, inSameDayAs: date)
            }
            return false
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
