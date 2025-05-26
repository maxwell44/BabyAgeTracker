import SwiftUI
import WidgetKit
import BabyAgeTracker

struct BabyAgeWidgetView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            // 使用婴儿照片或背景图片
            if let photoData = entry.baby?.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            
            // 内容
            switch family {
            case .systemSmall:
                smallWidget(entry: entry)
            case .systemMedium:
                mediumWidget(entry: entry)
            case .systemLarge:
                largeWidget(entry: entry)
            default:
                smallWidget(entry: entry)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    // 小尺寸小组件 - 类似示例图片的设计
    private func smallWidget(entry: Provider.Entry) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if let baby = entry.baby {
                // 婴儿名称
                Text("\(baby.name)'s Birthday")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    .padding(.top, 10)
                
                Spacer()
                
                // 天数显示
                HStack(alignment: .bottom, spacing: 4) {
                    Text("\(entry.days)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                    
                    Text("day")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                        .offset(y: -8) // 进行微调以匹配样例
                }
                .padding(.bottom, 10)
            } else {
                Spacer()
                Text("请添加婴儿信息")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    // 中尺寸小组件
    private func mediumWidget(entry: Provider.Entry) -> some View {
        HStack {
            if let baby = entry.baby {
                VStack(alignment: .leading, spacing: 4) {
                    Text(baby.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("出生于 \(formatDate(baby.birthDate))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    Text("\(entry.days)")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("天")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("未设置婴儿信息")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    // 大尺寸小组件
    private func largeWidget(entry: Provider.Entry) -> some View {
        VStack(spacing: 12) {
            if let baby = entry.baby {
                Text(baby.name)
                    .font(.title2)
                    .foregroundColor(.primary)
                
                VStack(spacing: 0) {
                    Text("\(entry.days)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("天")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                Text(entry.detailedAge)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                
                Text("出生于 \(formatDate(baby.birthDate))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("未设置婴儿信息")
                        .font(.headline)
                    
                    Text("请在主应用中设置婴儿的出生日期")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

struct Provider: TimelineProvider {
    // 使用标准共享存储
    let storage = BabyDataStorage.shared
    
    // 占位符数据，用于小组件库预览
    func placeholder(in context: Context) -> BabyAgeWidgetEntry {
        let sampleDate = Calendar.current.date(byAdding: .day, value: -100, to: Date()) ?? Date()
        let sampleBaby = BabyModel(name: "宝宝", birthDate: sampleDate)
        return BabyAgeWidgetEntry(date: Date(), baby: sampleBaby)
    }

    // 小组件库中的预览快照
    func getSnapshot(in context: Context, completion: @escaping (BabyAgeWidgetEntry) -> Void) {
        let baby = storage.loadBaby()
        let entry = BabyAgeWidgetEntry(date: Date(), baby: baby)
        completion(entry)
    }
    
    // 更新时间线（决定何时刷新小组件）
    func getTimeline(in context: Context, completion: @escaping (Timeline<BabyAgeWidgetEntry>) -> Void) {
        let baby = storage.loadBaby()
        
        // 创建更新时间线，在午夜刷新
        let currentDate = Date()
        let calendar = Calendar.current
        var entries: [BabyAgeWidgetEntry] = []
        
        // 添加当前条目
        entries.append(BabyAgeWidgetEntry(date: currentDate, baby: baby))
        
        // 安排下一次更新在午夜
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        components.day! += 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        guard let nextMidnight = calendar.date(from: components) else {
            // 如果无法确定午夜，则每24小时更新一次
            let nextUpdateDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
            completion(timeline)
            return
        }
        
        // 添加午夜条目
        entries.append(BabyAgeWidgetEntry(date: nextMidnight, baby: baby))
        
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct BabyAgeWidgetEntry: TimelineEntry {
    let date: Date
    let baby: BabyModel?
    let days: Int
    let detailedAge: String
    
    init(date: Date, baby: BabyModel?) {
        self.date = date
        self.baby = baby
        
        if let birthDate = baby?.birthDate {
            self.days = AgeCalculator.calculateDaysFromBirth(birthDate)
            self.detailedAge = AgeCalculator.formatDetailedAge(from: birthDate)
        } else {
            self.days = 0
            self.detailedAge = ""
        }
    }
}

@main
struct BabyAgeWidget: Widget {
    private let kind: String = "BabyAgeWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BabyAgeWidgetView(entry: entry)
        }
        .configurationDisplayName("婴儿年龄")
        .description("显示婴儿的年龄（天数）")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct BabyAgeWidget_Previews: PreviewProvider {
    static var previews: some View {
        let entry = BabyAgeWidgetEntry(
            date: Date(),
            baby: BabyModel(name: "宝宝", birthDate: Calendar.current.date(byAdding: .day, value: -100, to: Date())!)
        )
        
        Group {
            BabyAgeWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            BabyAgeWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            BabyAgeWidgetView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
