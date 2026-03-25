import Foundation

enum BadgeType: String, CaseIterable {
    case beginner = "beginner"
    case streak3 = "streak3"
    case streak7 = "streak7"
    case streak30 = "streak30"
    case focusMaster = "focusMaster"
    case taskKiller50 = "taskKiller50"
    case taskKiller100 = "taskKiller100"
    case earlyBird = "earlyBird"
    case nightOwl = "nightOwl"
    case activeLifestyle = "activeLifestyle"
    case perfectWeek = "perfectWeek"
    
    var info: (name: String, description: String, icon: String) {
        switch self {
        case .beginner:
            return ("初学者", "完成第一个任务", "🌱")
        case .streak3:
            return ("连续战士", "连续3天完成任务", "🔥")
        case .streak7:
            return ("一周达人", "连续7天完成任务", "⭐")
        case .streak30:
            return ("月度冠军", "连续30天完成任务", "👑")
        case .focusMaster:
            return ("专注大师", "累计专注10小时", "⏰")
        case .taskKiller50:
            return ("任务终结者", "完成50个任务", "⚔️")
        case .taskKiller100:
            return ("百任务达成", "完成100个任务", "🎯")
        case .earlyBird:
            return ("早起鸟", "上午9点前完成任务", "🐦")
        case .nightOwl:
            return ("夜猫子", "晚上10点后完成任务", "🦉")
        case .activeLifestyle:
            return ("运动达人", "完成运动相关任务", "🏃")
        case .perfectWeek:
            return ("完美一周", "一周每天完成任务", "🏆")
        }
    }
}

enum PlantGrowthStage: Int, CaseIterable {
    case seed = 0
    case sprout = 1
    case seedling = 2
    case growing = 3
    case flowering = 4
    case mature = 5
    
    var name: String {
        switch self {
        case .seed: return "种子"
        case .sprout: return "发芽"
        case .seedling: return "幼苗"
        case .growing: return "成长"
        case .flowering: return "开花"
        case .mature: return "成熟"
        }
    }
    
    var icon: String {
        switch self {
        case .seed: return "🌰"
        case .sprout: return "🌱"
        case .seedling: return "🌿"
        case .growing: return "🪴"
        case .flowering: return "🌸"
        case .mature: return "🌳"
        }
    }
    
    var requiredPoints: Int {
        switch self {
        case .seed: return 0
        case .sprout: return 50
        case .seedling: return 150
        case .growing: return 300
        case .flowering: return 500
        case .mature: return 800
        }
    }
    
    var color: String {
        switch self {
        case .seed: return "#8B4513"
        case .sprout: return "#90EE90"
        case .seedling: return "#32CD32"
        case .growing: return "#228B22"
        case .flowering: return "#FF69B4"
        case .mature: return "#006400"
        }
    }
}
