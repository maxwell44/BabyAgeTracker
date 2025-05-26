//
//  ContentView.swift
//  BirthdayDemo
//
//  Created by Maxwell Yu on 2025/5/26.
//

import SwiftUI
import BabyAgeTracker

struct ContentView: View {
    // 创建ViewModel实例来管理婴儿数据和年龄计算
    @StateObject private var viewModel = BabyAgeTracker.createViewModel()
    
    // 控制日期选择器显示的状态
    @State private var showingDatePicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景颜色渐变
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // 标题
                    Text("婴儿年龄追踪")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                    
                    // 使用BabyAgeTracker包中的BabyAgeView显示婴儿年龄
                    BabyAgeTracker.ageView(viewModel: viewModel, fontSize: 48, showDetailedAge: true)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal)
                    
                    // 按钮区域
                    VStack(spacing: 15) {
                        Button(action: {
                            // 显示日期选择器
                            showingDatePicker = true
                        }) {
                            HStack {
                                Image(systemName: viewModel.baby == nil ? "plus.circle.fill" : "pencil.circle.fill")
                                Text(viewModel.baby == nil ? "添加婴儿信息" : "更新婴儿信息")
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
                        
                        if viewModel.baby != nil {
                            Button(action: {
                                // 重置婴儿数据，清除UserDefaults中保存的信息
                                BabyDataStorage.shared.deleteBaby()
                                viewModel.loadBabyData()
                            }) {
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
                    
                    Spacer()
                    
                    // 提示区域
                    if viewModel.baby == nil {
                        VStack {
                            Text("👶 点击'添加婴儿信息'按钮")
                            Text("设置婴儿的姓名和出生日期")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        // 显示日期选择器的sheet
        .sheet(isPresented: $showingDatePicker) {
            BabyAgeTracker.datePickerView(viewModel: viewModel)
        }
        // 当应用进入前台时更新年龄计算
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.updateAgeCalculations()
        }
    }
}

#Preview {
    ContentView()
}
