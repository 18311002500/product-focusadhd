import XCTest
import CoreData
@testable import FocusFlow

final class FocusFlowTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }
    
    override func tearDownWithError() throws {
        persistenceController = nil
        context = nil
    }
    
    // MARK: - Task Tests
    
    func testCreateTask() throws {
        let task = Task(context: context)
        task.id = UUID()
        task.title = "Test Task"
        task.notes = "Test Notes"
        task.difficulty = 0
        task.isCompleted = false
        task.createdAt = Date()
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let results = try context.fetch(fetchRequest)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Test Task")
    }
    
    func testCompleteTask() throws {
        let task = Task(context: context)
        task.id = UUID()
        task.title = "Complete Test"
        task.isCompleted = false
        task.createdAt = Date()
        
        task.isCompleted = true
        task.completedAt = Date()
        
        try context.save()
        
        XCTAssertTrue(task.isCompleted)
        XCTAssertNotNil(task.completedAt)
    }
    
    func testDeleteTask() throws {
        let task = Task(context: context)
        task.id = UUID()
        task.title = "Delete Test"
        task.createdAt = Date()
        
        try context.save()
        
        context.delete(task)
        try context.save()
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let results = try context.fetch(fetchRequest)
        
        XCTAssertEqual(results.count, 0)
    }
    
    // MARK: - Difficulty Tests
    
    func testTaskDifficulty() {
        XCTAssertEqual(TaskDifficulty.easy.points, 10)
        XCTAssertEqual(TaskDifficulty.medium.points, 20)
        XCTAssertEqual(TaskDifficulty.hard.points, 50)
        
        XCTAssertEqual(TaskDifficulty.easy.title, "简单")
        XCTAssertEqual(TaskDifficulty.medium.title, "中等")
        XCTAssertEqual(TaskDifficulty.hard.title, "困难")
    }
    
    // MARK: - Badge Tests
    
    func testCreateBadge() throws {
        let badge = Badge(context: context)
        badge.id = "test_badge"
        badge.name = "Test Badge"
        badge.desc = "Test Description"
        badge.icon = "🏆"
        badge.isUnlocked = false
        badge.progress = 0.0
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<Badge> = Badge.fetchRequest()
        let results = try context.fetch(fetchRequest)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Test Badge")
    }
    
    func testUnlockBadge() throws {
        let badge = Badge(context: context)
        badge.id = "unlock_test"
        badge.name = "Unlock Test"
        badge.isUnlocked = false
        
        badge.isUnlocked = true
        badge.unlockedAt = Date()
        
        try context.save()
        
        XCTAssertTrue(badge.isUnlocked)
        XCTAssertNotNil(badge.unlockedAt)
    }
    
    // MARK: - User Stats Tests
    
    func testUserStats() throws {
        let stats = UserStats(context: context)
        stats.totalPoints = 100
        stats.currentStreak = 5
        stats.longestStreak = 10
        stats.totalTasksCompleted = 20
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<UserStats> = UserStats.fetchRequest()
        let results = try context.fetch(fetchRequest)
        
        XCTAssertEqual(results.first?.totalPoints, 100)
        XCTAssertEqual(results.first?.currentStreak, 5)
    }
    
    // MARK: - Plant Growth Tests
    
    func testPlantGrowthStage() {
        XCTAssertEqual(PlantGrowthStage.seed.requiredPoints, 0)
        XCTAssertEqual(PlantGrowthStage.sprout.requiredPoints, 50)
        XCTAssertEqual(PlantGrowthStage.mature.requiredPoints, 800)
        
        XCTAssertEqual(PlantGrowthStage.seed.icon, "🌰")
        XCTAssertEqual(PlantGrowthStage.mature.icon, "🌳")
    }
    
    func testPlantStageProgression() {
        let points = 200
        var currentStage: PlantGrowthStage = .seed
        
        for stage in PlantGrowthStage.allCases.reversed() {
            if points >= stage.requiredPoints {
                currentStage = stage
                break
            }
        }
        
        XCTAssertEqual(currentStage, .growing)
    }
    
    // MARK: - Focus Session Tests
    
    func testFocusSession() throws {
        let session = FocusSession(context: context)
        session.id = UUID()
        session.startTime = Date()
        session.duration = 25
        session.actualDuration = 25
        session.wasCompleted = true
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<FocusSession> = FocusSession.fetchRequest()
        let results = try context.fetch(fetchRequest)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertTrue(results.first?.wasCompleted ?? false)
    }
}
