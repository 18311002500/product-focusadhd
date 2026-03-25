import SwiftUI

struct FocusTimerView: View {
    @StateObject private var viewModel = FocusTimerViewModel()
    @State private var showDurationPicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(hex: "#F7F7F7")
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Timer Display
                    ZStack {
                        // Background Circle
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                            .frame(width: 280, height: 280)
                        
                        // Progress Circle
                        Circle()
                            .trim(from: 0, to: viewModel.progress)
                            .stroke(
                                Color(hex: "#FF6B35"),
                                style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .frame(width: 280, height: 280)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: viewModel.progress)
                        
                        // Time Text
                        VStack(spacing: 8) {
                            Text(viewModel.formattedTime)
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#2C3E50"))
                            
                            if viewModel.isRunning {
                                Text(viewModel.isPaused ? "已暂停" : "专注中...")
                                    .font(.headline)
                                    .foregroundColor(viewModel.isPaused ? .orange : Color(hex: "#27AE60"))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Duration Selector (when not running)
                    if !viewModel.isRunning {
                        VStack(spacing: 16) {
                            Text("选择专注时长")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.availableDurations, id: \.self) { duration in
                                        DurationButton(
                                            duration: duration,
                                            isSelected: viewModel.selectedDuration == duration
                                        ) {
                                            viewModel.selectedDuration = duration
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Control Buttons
                    HStack(spacing: 30) {
                        if viewModel.isRunning {
                            // Pause/Resume Button
                            Button(action: {
                                if viewModel.isPaused {
                                    viewModel.resumeTimer()
                                } else {
                                    viewModel.pauseTimer()
                                }
                            }) {
                                ControlButtonView(
                                    icon: viewModel.isPaused ? "play.fill" : "pause.fill",
                                    color: viewModel.isPaused ? Color(hex: "#27AE60") : Color(hex: "#FF6B35")
                                )
                            }
                            
                            // Stop Button
                            Button(action: {
                                viewModel.stopTimer()
                            }) {
                                ControlButtonView(
                                    icon: "stop.fill",
                                    color: Color(hex: "#E91E63")
                                )
                            }
                            
                            // Complete Button
                            Button(action: {
                                viewModel.completeTimer()
                            }) {
                                ControlButtonView(
                                    icon: "checkmark",
                                    color: Color(hex: "#27AE60")
                                )
                            }
                        } else {
                            // Start Button
                            Button(action: {
                                viewModel.startTimer()
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "play.fill")
                                        .font(.title2)
                                    Text("开始专注")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(width: 200, height: 60)
                                .background(Color(hex: "#FF6B35"))
                                .cornerRadius(30)
                            }
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("专注计时")
            .navigationBarTitleDisplayMode(.large)
            .overlay(
                Group {
                    if viewModel.showCompletionAnimation {
                        TimerCompletionOverlay(onComplete: {
                            viewModel.showCompletionAnimation = false
                        })
                    }
                }
            )
        }
    }
}

// MARK: - Duration Button
struct DurationButton: View {
    let duration: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(duration)")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("分钟")
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : Color(hex: "#2C3E50"))
            .frame(width: 70, height: 70)
            .background(isSelected ? Color(hex: "#FF6B35") : Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Control Button View
struct ControlButtonView: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Image(systemName: icon)
            .font(.title)
            .foregroundColor(color)
            .frame(width: 70, height: 70)
            .background(color.opacity(0.15))
            .cornerRadius(35)
    }
}

// MARK: - Timer Completion Overlay
struct TimerCompletionOverlay: View {
    let onComplete: () -> Void
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("🎉")
                    .font(.system(size: 80))
                
                Text("专注完成！")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("你刚刚完成了一次专注训练")
                    .foregroundColor(.white.opacity(0.8))
                
                Button(action: onComplete) {
                    Text("太棒了！")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#FF6B35"))
                        .frame(width: 150, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#2C3E50"))
            )
            .padding(40)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3)) {
                showConfetti = true
            }
        }
    }
}
