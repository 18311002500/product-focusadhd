import SwiftUI

struct ContentView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @StateObject private var gameViewModel = GameViewModel()
    @State private var selectedTab = 0
    @State private var showAddTask = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(taskViewModel: taskViewModel, gameViewModel: gameViewModel)
                .tabItem {
                    Label("今日", systemImage: "checklist")
                }
                .tag(0)
            
            FocusTimerView()
                .tabItem {
                    Label("专注", systemImage: "timer")
                }
                .tag(1)
            
            ProgressView(gameViewModel: gameViewModel)
                .tabItem {
                    Label("进度", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)
            
            BadgesView(gameViewModel: gameViewModel)
                .tabItem {
                    Label("徽章", systemImage: "medal")
                }
                .tag(3)
        }
        .accentColor(Color(hex: "#FF6B35"))
    }
}

// MARK: - Home View
struct HomeView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @ObservedObject var gameViewModel: GameViewModel
    @State private var showAddTask = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Plant Growth Card
                    PlantGrowthCard(gameViewModel: gameViewModel)
                    
                    // Today's Tasks
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("今日任务")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: { showAddTask = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color(hex: "#FF6B35"))
                            }
                        }
                        
                        if taskViewModel.todayTasks.isEmpty {
                            EmptyTaskView()
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(taskViewModel.todayTasks, id: \.id) { task in
                                    TaskCard(task: task, taskViewModel: taskViewModel, gameViewModel: gameViewModel)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("FocusFlow")
            .sheet(isPresented: $showAddTask) {
                AddTaskView(taskViewModel: taskViewModel, isPresented: $showAddTask)
            }
        }
    }
}

// MARK: - Plant Growth Card
struct PlantGrowthCard: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("我的植物")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(gameViewModel.currentPlantStage.name)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Text(gameViewModel.currentPlantStage.icon)
                    .font(.system(size: 60))
            }
            
            // Progress Bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(gameViewModel.userStats?.totalPoints ?? 0) 能量点")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if gameViewModel.pointsToNextStage > 0 {
                        Text("还需 \(gameViewModel.pointsToNextStage) 点升级")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: gameViewModel.currentPlantStage.color))
                            .frame(width: geometry.size.width * gameViewModel.progressToNextStage, height: 12)
                    }
                }
                .frame(height: 12)
            }
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

// MARK: - Task Card
struct TaskCard: View {
    let task: Task
    @ObservedObject var taskViewModel: TaskViewModel
    @ObservedObject var gameViewModel: GameViewModel
    @State private var showCompleteAnimation = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Difficulty Indicator
            Circle()
                .fill(Color(hex: task.difficultyEnum.color))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(task.difficultyEnum.title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Complete Button
            Button(action: {
                withAnimation(.spring()) {
                    taskViewModel.completeTask(task)
                    gameViewModel.recordTaskCompletion(difficulty: task.difficultyEnum)
                    showCompleteAnimation = true
                }
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(hex: "#27AE60"))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .overlay(
            Group {
                if showCompleteAnimation {
                    CelebrationOverlay()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                showCompleteAnimation = false
                            }
                        }
                }
            }
        )
    }
}

// MARK: - Empty Task View
struct EmptyTaskView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "#4ECDC4"))
            
            Text("今天还没有任务")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("添加一个任务开始专注吧！")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Celebration Overlay
struct CelebrationOverlay: View {
    @State private var showParticles = false
    
    var body: some View {
        ZStack {
            ForEach(0..<6) { i in
                Circle()
                    .fill([Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple][i])
                    .frame(width: 10, height: 10)
                    .offset(
                        x: showParticles ? CGFloat.random(in: -100...100) : 0,
                        y: showParticles ? CGFloat.random(in: -100...100) : 0
                    )
                    .opacity(showParticles ? 0 : 1)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showParticles = true
            }
        }
    }
}
