import Foundation
import CoreData
import Combine

class GameViewModel: ObservableObject {
    @Published var userStats: UserStats?
    @Published var badges: [Badge] = []
    @Published var unlockedBadges: [Badge] = []
    @Published var currentPlantStage: PlantGrowthStage = .seed
    @Published var showUnlockAnimation: Bool = false
    @Published var lastUnlockedBadge: Badge?
    
    private let context: NSManagedObjectContext
    private let badgeTypes = BadgeType.allCases
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        setupUserStats()
        fetchBadges()
        fetchUserStats()
    }
    
    private func setupUserStats() {
        let request: NSFetchRequest<UserStats> = UserStats.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if let stats = results.first {
                userStats = stats
            } else {
                let newStats = UserStats(context: context)
                newStats.totalPoints = 0
                newStats.currentStreak = 0
                newStats.longestStreak = 0
                newStats.totalTasksCompleted = 0
                newStats.totalFocusMinutes = 0
                newStats.plantGrowthLevel = 0
                newStats.lastActiveDate = Date()
                userStats = newStats
                saveContext()
            }
        } catch {
            print("Error fetching user stats: \(error)")
        }
    }
    
    private func fetchBadges() {
        let request: NSFetchRequest<Badge> = Badge.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Badge.id, ascending: true)]
        
        do {
            badges = try context.fetch(request)
            if badges.isEmpty {
                createDefaultBadges()
            }
            unlockedBadges = badges.filter { $0.isUnlocked }
        } catch {
            print("Error fetching badges: \(error)")
        }
    }
    
    private func createDefaultBadges() {
        for badgeType in badgeTypes {
            let badge = Badge(context: context)
            let info = badgeType.info
            badge.id = badgeType.rawValue
            badge.name = info.name
            badge.desc = info.description
            badge.icon = info.icon
            badge.isUnlocked = false
            badge.progress = 0
        }
        saveContext()
        fetchBadges()
    }
    
    private func fetchUserStats() {
        guard let stats = userStats else { return }
        updatePlantStage()
    }
    
    func addPoints(_ points: Int) {
        guard let stats = userStats else { return }
        stats.totalPoints += Int32(points)
        updatePlantStage()
        saveContext()
        objectWillChange.send()
    }
    
    func recordTaskCompletion(difficulty: TaskDifficulty) {
        guard let stats = userStats else { return }
        stats.totalTasksCompleted += 1
        addPoints(difficulty.points)
        
        updateStreak()
        checkTaskBadges()
        checkTimeBasedBadges()
        
        saveContext()
        objectWillChange.send()
    }
    
    func recordFocusSession(minutes: Int16) {
        guard let stats = userStats else { return }
        stats.totalFocusMinutes += Int32(minutes)
        checkFocusBadges()
        saveContext()
        objectWillChange.send()
    }
    
    private func updateStreak() {
        guard let stats = userStats else { return }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastActive = stats.lastActiveDate {
            let lastActiveDay = calendar.startOfDay(for: lastActive)
            let daysDifference = calendar.dateComponents([.day], from: lastActiveDay, to: today).day ?? 0
            
            if daysDifference == 0 {
                return
            } else if daysDifference == 1 {
                stats.currentStreak += 1
            } else {
                stats.currentStreak = 1
            }
        } else {
            stats.currentStreak = 1
        }
        
        if stats.currentStreak > stats.longestStreak {
            stats.longestStreak = stats.currentStreak
        }
        
        stats.lastActiveDate = Date()
    }
    
    private func updatePlantStage() {
        guard let stats = userStats else { return }
        let points = Int(stats.totalPoints)
        
        for stage in PlantGrowthStage.allCases.reversed() {
            if points >= stage.requiredPoints {
                currentPlantStage = stage
                stats.plantGrowthLevel = Int16(stage.rawValue)
                break
            }
        }
    }
    
    // MARK: - Badge Checking
    
    private func checkTaskBadges() {
        guard let stats = userStats else { return }
        let completedCount = Int(stats.totalTasksCompleted)
        
        if completedCount >= 1 {
            unlockBadge(.beginner)
        }
        if completedCount >= 50 {
            unlockBadge(.taskKiller50)
        }
        if completedCount >= 100 {
            unlockBadge(.taskKiller100)
        }
        
        let streak = Int(stats.currentStreak)
        if streak >= 3 {
            unlockBadge(.streak3)
        }
        if streak >= 7 {
            unlockBadge(.streak7)
            unlockBadge(.perfectWeek)
        }
        if streak >= 30 {
            unlockBadge(.streak30)
        }
    }
    
    private func checkFocusBadges() {
        guard let stats = userStats else { return }
        let focusHours = Int(stats.totalFocusMinutes) / 60
        
        if focusHours >= 10 {
            unlockBadge(.focusMaster)
        }
    }
    
    private func checkTimeBasedBadges() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour < 9 {
            unlockBadge(.earlyBird)
        }
        if hour >= 22 {
            unlockBadge(.nightOwl)
        }
    }
    
    private func unlockBadge(_ type: BadgeType) {
        if let badge = badges.first(where: { $0.id == type.rawValue }), !badge.isUnlocked {
            badge.isUnlocked = true
            badge.unlockedAt = Date()
            saveContext()
            
            lastUnlockedBadge = badge
            showUnlockAnimation = true
            
            fetchBadges()
        }
    }
    
    var progressToNextStage: Double {
        guard let stats = userStats else { return 0 }
        let currentPoints = Int(stats.totalPoints)
        
        if let nextStage = PlantGrowthStage(rawValue: currentPlantStage.rawValue + 1) {
            let required = nextStage.requiredPoints - currentPlantStage.requiredPoints
            let progress = currentPoints - currentPlantStage.requiredPoints
            return min(Double(progress) / Double(required), 1.0)
        }
        return 1.0
    }
    
    var pointsToNextStage: Int {
        guard let stats = userStats else { return 0 }
        let currentPoints = Int(stats.totalPoints)
        
        if let nextStage = PlantGrowthStage(rawValue: currentPlantStage.rawValue + 1) {
            return max(nextStage.requiredPoints - currentPoints, 0)
        }
        return 0
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
