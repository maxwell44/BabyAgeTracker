import SwiftUI
import BabyAgeTracker
import Foundation

// 定义一个日期选择器组件，兼容iOS 15.5
struct DatePickerSheet: View {
    // 视图模型
    var viewModel: BabyAgeViewModel
    var onDismiss: () -> Void
    
    // 状态变量 - 默认值提高兼容性
    @State private var babyName = ""
    @State private var birthDate = Date()
    @State private var showAlert = false
    
    // 初始化器
    init(viewModel: BabyAgeViewModel, onDismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("婴儿信息")) {
                    // 姓名输入框
                    TextField("婴儿姓名", text: $babyName)
                        .padding(.vertical, 4)
                    
                    // 日期选择器
                    DatePicker("出生日期", selection: $birthDate, displayedComponents: .date)
                        .padding(.vertical, 4)
                    
                    // 照片提示
                    Text("照片可以在主界面中选择")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                
                // 保存按钮
                Section {
                    Button(action: saveChanges) {
                        Text(viewModel.baby == nil ? "保存" : "更新")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("婴儿信息")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        onDismiss()
                    }
                }
            }
            .onAppear {
                // 在视图出现时初始化值
                if let baby = viewModel.baby {
                    babyName = baby.name
                    birthDate = baby.birthDate
                }
            }
        }
        .alert("错误", isPresented: $showAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text("请输入婴儿的姓名")
        }
    }
    
    // 保存更改 - 简化处理逻辑以避免各种兼容性问题
    private func saveChanges() {
        // 验证姓名不为空
        guard !babyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert = true
            return
        }
        
        // 创建新的BabyModel
        if viewModel.baby != nil {
            // 如果已经有婴儿信息，直接创建一个新对象，保留ID
            let newBaby = BabyModel(
                id: viewModel.baby!.id,  // 保留原来的ID
                name: babyName,
                birthDate: birthDate
            )
            viewModel.saveBaby(newBaby)
        } else {
            // 创建全新的婴儿信息
            let newBaby = BabyModel(
                id: UUID(),  // 创建新ID
                name: babyName,
                birthDate: birthDate
            )
            viewModel.saveBaby(newBaby)
        }
        
        // 关闭视图
        onDismiss()
    }
}

// 预览提供程序
struct DatePickerSheet_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerSheet(viewModel: BabyAgeViewModel(storage: BabyDataStorage.shared), onDismiss: {})
    }
}
