//
//  ContentView.swift
//  BirthdayDemo
//
//  Created by Maxwell Yu on 2025/5/26.
//

import SwiftUI
import BabyAgeTracker
import WidgetKit

// 简化的照片管理类
// 这个类将照片数据保存在UserDefaults中，避免与BabyModel直接交互
class PhotoManager {
    static let shared = PhotoManager()
    private let photoKeyPrefix = "baby_photo_"
    
    func savePhoto(_ data: Data?, forBabyId id: UUID) {
        let key = photoKeyPrefix + id.uuidString
        if let data = data {
            UserDefaults.standard.set(data, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    func getPhoto(forBabyId id: UUID) -> Data? {
        let key = photoKeyPrefix + id.uuidString
        return UserDefaults.standard.data(forKey: key)
    }
}

// MARK: - 卡片背景组件
struct BabyCardBackground: View {
    let baby: BabyModel?
    
    var body: some View {
        if let baby = baby,
           let photoData = PhotoManager.shared.getPhoto(forBabyId: baby.id),
           let uiImage = UIImage(data: photoData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 400)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.2), Color.black.opacity(0.5)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        } else {
            // 默认背景渐变
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - 卡片内容组件
struct BabyCardContent: View {
    let baby: BabyModel?
    let totalDays: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let baby = baby {
                // 婴儿名称
                Text("\(baby.name)'s Birthday")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    .padding(.top, 20)
                
                Spacer()
                
                // 天数显示
                HStack(alignment: .bottom, spacing: 8) {
                    Text("\(totalDays)")
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                    
                    Text("day")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                        .offset(y: -12) // 进行微调以匹配样例
                }
                .padding(.bottom, 20)
            } else {
                Spacer()
                Text("添加婴儿信息")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.horizontal, 25)
        .padding(.vertical, 20)
    }
}

// MARK: - 主卡片组件
struct BabyCard: View {
    let baby: BabyModel?
    let totalDays: Int
    
    var body: some View {
        ZStack {
            // 背景照片或渐变背景
            BabyCardBackground(baby: baby)
            
            // 内容叠加
            BabyCardContent(baby: baby, totalDays: totalDays)
        }
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

// MARK: - 按钮组件
struct ActionButtonsView: View {
    let baby: BabyModel?
    let onAddBabyTapped: () -> Void
    let onResetTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            // 设置/更新婴儿信息按钮
            Button(action: onAddBabyTapped) {
                HStack {
                    Image(systemName: baby == nil ? "plus.circle.fill" : "pencil.circle.fill")
                    Text(baby != nil ? "更新婴儿信息" : "添加婴儿信息")
                }
                .frame(minWidth: 200)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
                .foregroundColor(.white)
                .font(.headline)
            }
            
            // 重置按钮 (如果已有婴儿信息)
            if baby != nil {
                Button(action: onResetTapped) {
                    HStack {
                        Image(systemName: "trash.circle.fill")
                        Text("重置")
                    }
                    .frame(minWidth: 200)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.red.opacity(0.8))
                    )
                    .foregroundColor(.white)
                    .font(.headline)
                }
            }
        }
        .padding(.top, 10)
    }
}

// MARK: - 主视图
struct ContentView: View {
    // 创建共享存储和ViewModel实例来管理婴儿数据和年龄计算
    private static let sharedStorage = BabyDataStorage.shared
    @StateObject private var viewModel = BabyAgeViewModel(storage: sharedStorage)
    
    // 状态变量
    @State private var showingDatePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // 主要卡片视图
                    BabyCard(baby: viewModel.baby, totalDays: viewModel.totalDays)
                    
                    // 按钮区域
                    ActionButtonsView(
                        baby: viewModel.baby,
                        onAddBabyTapped: { showingDatePicker = true },
                        onResetTapped: resetBabyData
                    )
                    
                    // 提示信息 (如果未设置婴儿信息)
                    if viewModel.baby == nil {
                        VStack {
                            Text("👶 点击'添加婴儿信息'按钮")
                            Text("设置婴儿的姓名和出生日期")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("婴儿年龄追踪")
        }
        // 显示自定义的日期选择器sheet
        .sheet(isPresented: $showingDatePicker) {
            // 使用定制的日期选择器实现
            DatePickerSheet(viewModel: viewModel, onDismiss: {
                showingDatePicker = false
            })
        }
        .onChange(of: viewModel.baby) { _ in
            // 当婴儿信息变化时刷新Widget
            WidgetCenter.shared.reloadAllTimelines()
        }

        // 当应用进入前台时更新年龄计算
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.updateAgeCalculations()
        }
    }
    
    // 重置婴儿数据
    private func resetBabyData() {
        ContentView.sharedStorage.deleteBaby()
        viewModel.loadBabyData()
        WidgetCenter.shared.reloadAllTimelines()
    }
    

}

#Preview {
    ContentView()
}
