# BabyAgeTracker

一个Swift Package，为iOS应用提供婴儿年龄追踪和计算功能。追踪婴儿出生以来的天数，并提供丰富的SwiftUI组件和小组件支持。

## 功能特点

- 精确计算婴儿出生日期到当前日期的天数
- 支持实时更新（每日自动刷新）
- 处理时区和夏令时变化
- 数据持久化存储（UserDefaults）
- SwiftUI视图组件
- iOS小组件支持
- 支持iOS 15.5+

## 安装方法

### Swift Package Manager

通过Swift Package Manager将BabyAgeTracker添加到您的项目中：

1. 在Xcode中，选择File > Add Package Dependencies
2. 输入仓库URL: `https://github.com/yourusername/BabyAgeTracker.git`
3. 选择您想要使用的版本

## 使用方法

### 基本设置

```swift
import BabyAgeTracker
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BabyAgeTracker.createViewModel()
    @State private var showingDatePicker = false
    
    var body: some View {
        VStack {
            BabyAgeTracker.ageView(viewModel: viewModel)
            
            Button("设置出生日期") {
                showingDatePicker = true
            }
            .sheet(isPresented: $showingDatePicker) {
                BabyAgeTracker.datePickerView(viewModel: viewModel)
            }
        }
        .padding()
    }
}
```

### 创建小组件

1. 在您的应用中添加一个新的Widget Extension目标
2. 在您的widget中导入BabyAgeTracker
3. 使用提供的widget组件：

```swift
import WidgetKit
import SwiftUI
import BabyAgeTracker

struct BabyAgeWidget: Widget {
    let kind: String = "BabyAgeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: BabyAgeWidgetProvider()
        ) { entry in
            BabyAgeWidgetEntryView(entry: entry, size: .systemSmall)
        }
        .configurationDisplayName("婴儿年龄")
        .description("显示婴儿的年龄（天数）。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
```

## 核心组件

包含以下核心组件：

1. **BabyModel**: 婴儿数据模型
2. **AgeCalculator**: 年龄计算工具类
3. **BabyAgeView**: 主显示视图
4. **DatePickerView**: 日期选择视图
5. **BabyAgeWidget**: Widget扩展支持

## 示例项目

要查看完整的示例项目，请克隆仓库并打开`Examples/BabyAgeTrackerDemo`目录。

## 贡献

欢迎提交问题和拉取请求。对于重大更改，请先开issue讨论您想要更改的内容。

## 许可证

此软件包基于MIT许可证提供。
