import Foundation
import Combine
import HealthKit

class FocusTimerViewModel: ObservableObject {
    @Published var timeRemaining: Int = 0
    @Published var totalTime: Int = 0
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var selectedDuration: Int = 15
    @Published var showCompletionAnimation: Bool = false
    
    private var timer: AnyCancellable?
    private var startTime: Date?
    private var pausedTimeRemaining: Int = 0
    
    let availableDurations = [5, 10, 15, 20, 25, 30, 45, 60]
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return Double(totalTime - timeRemaining) / Double(totalTime)
    }
    
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startTimer(duration: Int? = nil) {
        if let duration = duration {
            selectedDuration = duration
        }
        
        totalTime = selectedDuration * 60
        timeRemaining = totalTime
        isRunning = true
        isPaused = false
        startTime = Date()
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func pauseTimer() {
        isPaused = true
        pausedTimeRemaining = timeRemaining
        timer?.cancel()
    }
    
    func resumeTimer() {
        isPaused = false
        timeRemaining = pausedTimeRemaining
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func stopTimer() {
        timer?.cancel()
        isRunning = false
        isPaused = false
        timeRemaining = 0
    }
    
    func completeTimer() {
        timer?.cancel()
        isRunning = false
        isPaused = false
        showCompletionAnimation = true
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            completeTimer()
        }
    }
    
    func getActualDuration() -> Int {
        guard let startTime = startTime else { return 0 }
        let elapsed = Int(Date().timeIntervalSince(startTime))
        return min(elapsed, totalTime)
    }
}
