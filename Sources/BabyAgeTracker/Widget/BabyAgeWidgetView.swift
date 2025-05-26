import SwiftUI
import WidgetKit

public struct BabyAgeWidgetEntryView: View {
    var entry: BabyAgeEntry
    var size: WidgetFamily
    
    public init(entry: BabyAgeEntry, size: WidgetFamily) {
        self.entry = entry
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            Color("WidgetBackground", bundle: .module)
            
            VStack(spacing: 8) {
                if let baby = entry.baby {
                    // For small widget, just show days
                    if size == .systemSmall {
                        Text("\(entry.days)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                        Text("days")
                            .font(.caption)
                    } 
                    // For medium widget, show days and birth date
                    else if size == .systemMedium {
                        Text(baby.name)
                            .font(.headline)
                        
                        Text("\(entry.days)")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                        
                        Text("days old")
                            .font(.caption)
                        
                        Text("Born: \(formatDate(baby.birthDate))")
                            .font(.caption2)
                    } 
                    // For large widget, show detailed information
                    else {
                        Text(baby.name)
                            .font(.title2)
                        
                        Text("\(entry.days)")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                        
                        Text("days old")
                            .font(.headline)
                        
                        Text(entry.detailedAge)
                            .font(.body)
                            .padding(.vertical, 8)
                        
                        Text("Born on \(formatDate(baby.birthDate))")
                            .font(.caption)
                    }
                } else {
                    Text("No baby info")
                        .font(.caption)
                }
            }
            .padding()
            .foregroundColor(.primary)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

public struct BabyAgeEntry: TimelineEntry {
    public let date: Date
    public let baby: BabyModel?
    public let days: Int
    public let detailedAge: String
    
    public init(date: Date, baby: BabyModel?) {
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

public struct BabyAgeWidgetProvider: TimelineProvider {
    public typealias Entry = BabyAgeEntry
    
    public init() {}
    
    public func placeholder(in context: Context) -> BabyAgeEntry {
        // Sample data for preview
        let sampleDate = Calendar.current.date(byAdding: .day, value: -100, to: Date()) ?? Date()
        let sampleBaby = BabyModel(name: "Baby", birthDate: sampleDate)
        return BabyAgeEntry(date: Date(), baby: sampleBaby)
    }
    
    public func getSnapshot(in context: Context, completion: @escaping (BabyAgeEntry) -> Void) {
        let baby = BabyDataStorage.shared.loadBaby()
        let entry = BabyAgeEntry(date: Date(), baby: baby)
        completion(entry)
    }
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<BabyAgeEntry>) -> Void) {
        let baby = BabyDataStorage.shared.loadBaby()
        
        // Create a timeline that updates at midnight
        let currentDate = Date()
        let calendar = Calendar.current
        var entries: [BabyAgeEntry] = []
        
        // Add current entry
        entries.append(BabyAgeEntry(date: currentDate, baby: baby))
        
        // Schedule next update for midnight
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        components.day! += 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        guard let nextMidnight = calendar.date(from: components) else {
            // Fallback to updating every 24 hours if we can't determine midnight
            let nextUpdateDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
            completion(timeline)
            return
        }
        
        // Add midnight entry
        entries.append(BabyAgeEntry(date: nextMidnight, baby: baby))
        
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

public struct BabyAgeWidgetConfiguration {
    public let provider: BabyAgeWidgetProvider
    public let kind: String
    public let displayName: String
    public let description: String
    
    public init(
        kind: String = "BabyAgeWidget",
        displayName: String = "Baby Age",
        description: String = "Track your baby's age in days."
    ) {
        self.provider = BabyAgeWidgetProvider()
        self.kind = kind
        self.displayName = displayName
        self.description = description
    }
}
