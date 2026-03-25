import Foundation
import AVFoundation
import AudioToolbox

/// 音效类型
enum SoundEffect {
    case taskComplete
    case focusComplete
    case badgeUnlock
    case levelUp
    case buttonTap
    case success
    case achievement
    
    /// 系统声音ID
    var systemSoundID: SystemSoundID {
        switch self {
        case .taskComplete:
            return 1407 // 成功音效
        case .focusComplete:
            return 1025 // 提示音
        case .badgeUnlock:
            return 1334 // 积极音效
        case .levelUp:
            return 1329 // 升级音效
        case .buttonTap:
            return 1104 // 轻触音效
        case .success:
            return 1407 // 成功
        case .achievement:
            return 1331 // 成就
        }
    }
    
    /// 声音文件名称（自定义音效）
    var customSoundFile: String? {
        switch self {
        case .taskComplete:
            return "task_complete"
        case .focusComplete:
            return "focus_complete"
        case .badgeUnlock:
            return "badge_unlock"
        case .levelUp:
            return "level_up"
        default:
            return nil
        }
    }
}

/// 音效管理器
class SoundManager {
    static let shared = SoundManager()
    
    // MARK: - Properties
    private var audioPlayer: AVAudioPlayer?
    private var isEnabled = true
    private var useCustomSounds = false
    
    // MARK: - UserDefaults Keys
    private let soundEnabledKey = "soundEffectsEnabled"
    private let useCustomSoundsKey = "useCustomSounds"
    
    // MARK: - Initialization
    private init() {
        loadSettings()
        configureAudioSession()
    }
    
    // MARK: - Settings
    
    /// 加载设置
    private func loadSettings() {
        isEnabled = UserDefaults.standard.bool(forKey: soundEnabledKey)
        if !UserDefaults.standard.objectIsForced(forKey: soundEnabledKey) {
            isEnabled = true // 默认开启
        }
        useCustomSounds = UserDefaults.standard.bool(forKey: useCustomSoundsKey)
    }
    
    /// 保存设置
    func saveSettings() {
        UserDefaults.standard.set(isEnabled, forKey: soundEnabledKey)
        UserDefaults.standard.set(useCustomSounds, forKey: useCustomSoundsKey)
    }
    
    /// 音效是否开启
    var soundEnabled: Bool {
        get { isEnabled }
        set {
            isEnabled = newValue
            saveSettings()
        }
    }
    
    // MARK: - Audio Session
    
    /// 配置音频会话
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient, mode: .default, options: [.duckOthers])
            try session.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    // MARK: - Sound Playing
    
    /// 播放音效
    func play(_ effect: SoundEffect) {
        guard isEnabled else { return }
        
        if useCustomSounds, let customFile = effect.customSoundFile {
            playCustomSound(named: customFile)
        } else {
            playSystemSound(effect.systemSoundID)
        }
    }
    
    /// 播放系统音效
    private func playSystemSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }
    
    /// 播放自定义音效
    private func playCustomSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") ??
              Bundle.main.url(forResource: name, withExtension: "wav") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.5
            audioPlayer?.play()
        } catch {
            print("Failed to play custom sound: \(error)")
        }
    }
    
    // MARK: - Convenience Methods
    
    /// 播放任务完成音效
    func playTaskComplete() {
        play(.taskComplete)
    }
    
    /// 播放专注完成音效
    func playFocusComplete() {
        play(.focusComplete)
    }
    
    /// 播放徽章解锁音效
    func playBadgeUnlock() {
        play(.badgeUnlock)
    }
    
    /// 播放升级音效
    func playLevelUp() {
        play(.levelUp)
    }
    
    /// 播放按钮点击音效
    func playButtonTap() {
        play(.buttonTap)
    }
    
    /// 播放成功音效
    func playSuccess() {
        play(.success)
    }
    
    /// 播放成就音效
    func playAchievement() {
        play(.achievement)
    }
    
    /// 震动反馈
    func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    /// 成功震动反馈
    func successHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// 错误震动反馈
    func errorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    /// 警告震动反馈
    func warningHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}

// MARK: - View Extension

import SwiftUI

extension View {
    /// 添加按钮点击音效
    func withButtonSound() -> some View {
        self.onTapGesture {
            SoundManager.shared.playButtonTap()
        }
    }
    
    /// 添加成功反馈
    func withSuccessFeedback() -> some View {
        self.onTapGesture {
            SoundManager.shared.successHaptic()
            SoundManager.shared.playSuccess()
        }
    }
}
