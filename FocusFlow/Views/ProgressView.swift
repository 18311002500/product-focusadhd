import SwiftUI

struct ProgressView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Stats Cards
                    StatsGridView(gameViewModel: gameViewModel)
                    
                    // Weekly Progress
                    WeeklyProgressView()
                    
                    // Plant Growth Journey
                    PlantJourneyView(gameViewModel: gameViewModel)
                }
                .padding()
            }
            .navigationTitle("我的进度")
        }
    }
}

// MARK: - Stats Grid View
struct StatsGridView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "总能量",
                value: "\(gameViewModel.userStats?.totalPoints ?? 0)",
                icon: "⚡️",
                color: "#FFE66D"
            )
            
            StatCard(
                title: "完成任务",
                value: "\(gameViewModel.userStats?.totalTasksCompleted ?? 0)",
                icon: "✅",
                color: "#27AE60"
            )
            
            StatCard(
                title: "当前连击",
                value: "\(gameViewModel.userStats?.currentStreak ?? 0)天",
                icon: "🔥",
                color: "#FF6B35"
            )
            
            StatCard(
                title: "专注时间",
                value: "\(gameViewModel.userStats?.totalFocusMinutes ?? 0)分",
                icon: "⏰",
                color: "#4ECDC4"
            )
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(icon)
                    .font(.title2)
                Spacer()
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#2C3E50"))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: color).opacity(0.3), lineWidth: 2)
        )
    }
}

// MARK: - Weekly Progress View
struct WeeklyProgressView: View {
    let days = ["一", "二", "三", "四", "五", "六", "日"]
    let completedDays = [true, true, false, true, true, false, true]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("本周完成度")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(0..<days.count, id: \.self) { index in
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(completedDays[index] ? Color(hex: "#27AE60") : Color.gray.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            if completedDays[index] {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                        }
                        
                        Text(days[index])
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Progress Bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("本周完成率")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("71%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#27AE60"))
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#27AE60"))
                            .frame(width: geometry.size.width * 0.71, height: 8)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Plant Journey View
struct PlantJourneyView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("成长之路")
                .font(.headline)
            
            VStack(spacing: 0) {
                ForEach(PlantGrowthStage.allCases, id: \.self) { stage in
                    PlantStageRow(
                        stage: stage,
                        isCurrent: stage == gameViewModel.currentPlantStage,
                        isUnlocked: stage.rawValue <= gameViewModel.currentPlantStage.rawValue,
                        isLast: stage == PlantGrowthStage.allCases.last
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Plant Stage Row
struct PlantStageRow: View {
    let stage: PlantGrowthStage
    let isCurrent: Bool
    let isUnlocked: Bool
    let isLast: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Stage Icon
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color(hex: stage.color).opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Text(stage.icon)
                    .font(.title3)
                    .opacity(isUnlocked ? 1.0 : 0.5)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stage.name)
                    .font(.headline)
                    .foregroundColor(isUnlocked ? Color(hex: "#2C3E50") : .gray)
                
                Text("\(stage.requiredPoints) 能量点")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isCurrent {
                Text("当前")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#FF6B35"))
                    .cornerRadius(12)
            } else if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(hex: "#27AE60"))
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        
        if !isLast {
            Divider()
                .padding(.leading, 66)
        }
    }
}
