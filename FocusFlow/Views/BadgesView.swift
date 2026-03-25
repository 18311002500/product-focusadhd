import SwiftUI

struct BadgesView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Unlocked Badges Summary
                    BadgeSummaryCard(gameViewModel: gameViewModel)
                    
                    // All Badges Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(gameViewModel.badges, id: \.id) { badge in
                            BadgeCell(badge: badge)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("徽章墙")
        }
        .overlay(
            Group {
                if gameViewModel.showUnlockAnimation, let badge = gameViewModel.lastUnlockedBadge {
                    BadgeUnlockOverlay(badge: badge) {
                        gameViewModel.showUnlockAnimation = false
                    }
                }
            }
        )
    }
}

// MARK: - Badge Summary Card
struct BadgeSummaryCard: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var unlockedCount: Int {
        gameViewModel.badges.filter { $0.isUnlocked }.count
    }
    
    var totalCount: Int {
        gameViewModel.badges.count
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("已获得徽章")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("\(unlockedCount) / \(totalCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2C3E50"))
                }
                
                Spacer()
                
                // Progress Ring
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(unlockedCount) / CGFloat(totalCount))
                        .stroke(
                            Color(hex: "#FFE66D"),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                    
                    Text("🏆")
                        .font(.title2)
                }
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(hex: "#FFE66D"))
                        .frame(width: geometry.size.width * CGFloat(unlockedCount) / CGFloat(totalCount), height: 12)
                }
            }
            .frame(height: 12)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

// MARK: - Badge Cell
struct BadgeCell: View {
    let badge: Badge
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(badge.isUnlocked ? Color(hex: "#F7F7F7") : Color.gray.opacity(0.1))
                    .frame(height: 80)
                
                Text(badge.icon)
                    .font(.system(size: 40))
                    .opacity(badge.isUnlocked ? 1.0 : 0.4)
                
                if !badge.isUnlocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
            
            VStack(spacing: 2) {
                Text(badge.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(badge.isUnlocked ? Color(hex: "#2C3E50") : .gray)
                    .lineLimit(1)
                
                Text(badge.desc)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Badge Unlock Overlay
struct BadgeUnlockOverlay: View {
    let badge: Badge
    let onComplete: () -> Void
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            VStack(spacing: 24) {
                Text("🎉 解锁新徽章！")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                ZStack {
                    Circle()
                        .fill(Color(hex: "#FFE66D").opacity(0.3))
                        .frame(width: 150, height: 150)
                    
                    Circle()
                        .fill(Color(hex: "#FFE66D").opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Text(badge.icon)
                        .font(.system(size: 60))
                }
                
                VStack(spacing: 8) {
                    Text(badge.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(badge.desc)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Button(action: dismiss) {
                    Text("太棒了！")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#2C3E50"))
                        .frame(width: 150, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                }
            }
            .padding(40)
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
    
    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            scale = 0.8
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            onComplete()
        }
    }
}
