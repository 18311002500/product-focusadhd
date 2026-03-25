import SwiftUI

struct AddTaskView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var isPresented: Bool
    
    @State private var title = ""
    @State private var notes = ""
    @State private var selectedDifficulty: TaskDifficulty = .easy
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("任务信息")) {
                    TextField("任务名称", text: $title)
                    
                    if !title.isEmpty {
                        Text("获得 \(selectedDifficulty.points) 能量点")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#27AE60"))
                    }
                }
                
                Section(header: Text("难度等级")) {
                    Picker("难度", selection: $selectedDifficulty) {
                        ForEach(TaskDifficulty.allCases, id: \.self) { difficulty in
                            HStack {
                                Circle()
                                    .fill(Color(hex: difficulty.color))
                                    .frame(width: 10, height: 10)
                                Text(difficulty.title)
                                Text("(\(difficulty.points)点)")
                                    .foregroundColor(.secondary)
                            }
                            .tag(difficulty)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("截止日期")) {
                    Toggle("设置截止日期", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("截止日期", selection: $dueDate, displayedComponents: [.date])
                    }
                }
                
                Section(header: Text("备注")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("新建任务")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        let finalDueDate = hasDueDate ? dueDate : nil
        taskViewModel.createTask(
            title: title,
            notes: notes,
            difficulty: selectedDifficulty,
            dueDate: finalDueDate
        )
        isPresented = false
    }
}
