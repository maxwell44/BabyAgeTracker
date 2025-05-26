import SwiftUI

// 简单的婴儿数据模型（如有需要可替换为你自己的模型）
public struct BabyModel {
    public let name: String
    public let birthDate: Date
    // 可根据需要添加更多属性
    public init(name: String, birthDate: Date) {
        self.name = name
        self.birthDate = birthDate
    }
}

/// 只显示渐变背景和文字的婴儿生日卡片，无照片依赖
public struct BabyBirthdayCard: View {
    public let baby: BabyModel?
    public let totalDays: Int
    
    public init(baby: BabyModel?, totalDays: Int) {
        self.baby = baby
        self.totalDays = totalDays
    }
    
    public var body: some View {
        ZStack {
            // 渐变背景
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // 内容叠加
            VStack(alignment: .leading, spacing: 10) {
                if let baby = baby {
                    Text("\(baby.name)\u0027s Birthday")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom, spacing: 8) {
                        Text("\(totalDays)")
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        
                        Text("day")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                            .offset(y: -12)
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
        .frame(height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#if DEBUG
struct BabyBirthdayCard_Previews: PreviewProvider {
    static var previews: some View {
        BabyBirthdayCard(
            baby: BabyModel(name: "小明", birthDate: Date(timeIntervalSinceNow: -86400 * 123)),
            totalDays: 123
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
