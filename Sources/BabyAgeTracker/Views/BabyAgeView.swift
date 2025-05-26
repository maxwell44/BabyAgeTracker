import SwiftUI

public struct BabyAgeView: View {
    @ObservedObject private var viewModel: BabyAgeViewModel
    private var fontSize: CGFloat
    private var showDetailedAge: Bool
    
    public init(
        viewModel: BabyAgeViewModel = BabyAgeViewModel(),
        fontSize: CGFloat = 36,
        showDetailedAge: Bool = true
    ) {
        self.viewModel = viewModel
        self.fontSize = fontSize
        self.showDetailedAge = showDetailedAge
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            if let baby = viewModel.baby {
                // Baby name and age in days
                Text(baby.name)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("\(viewModel.totalDays)")
                    .font(.system(size: fontSize, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("days old")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if showDetailedAge {
                    Text(viewModel.detailedAgeFormatted)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
                
                Text("Born on \(formatDate(baby.birthDate))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            } else {
                Text("No baby information")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Button("Add Baby Details") {
                    // This will be handled by the parent view
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .animation(.easeInOut, value: viewModel.baby != nil)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }
    
    private var accessibilityLabel: String {
        if let baby = viewModel.baby {
            return "\(baby.name) is \(viewModel.totalDays) days old. Born on \(formatDate(baby.birthDate))."
        } else {
            return "No baby information available."
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
