import Foundation
import SwiftUI

public struct BabyAgeTracker {
    public static let version = "1.0.0"
    
    /// Initialize the BabyAgeTracker
    public static func initialize() {
        // Future initialization code if needed
        print("BabyAgeTracker initialized: \(version)")
    }
    
    /// Create a new BabyAgeViewModel instance
    /// - Returns: Configured BabyAgeViewModel
    public static func createViewModel() -> BabyAgeViewModel {
        return BabyAgeViewModel()
    }
    
    /// Get the main BabyAgeView for displaying baby age
    /// - Parameters:
    ///   - viewModel: The BabyAgeViewModel to use (creates a new one if not provided)
    ///   - fontSize: Font size for the main age display
    ///   - showDetailedAge: Whether to show detailed age breakdown
    /// - Returns: A SwiftUI view for displaying baby age
    public static func ageView(
        viewModel: BabyAgeViewModel? = nil,
        fontSize: CGFloat = 36,
        showDetailedAge: Bool = true
    ) -> BabyAgeView {
        return BabyAgeView(
            viewModel: viewModel ?? createViewModel(),
            fontSize: fontSize,
            showDetailedAge: showDetailedAge
        )
    }
    
    /// Get a date picker view for setting baby details
    /// - Parameter viewModel: The BabyAgeViewModel to use
    /// - Returns: A SwiftUI view for setting baby details
    public static func datePickerView(viewModel: BabyAgeViewModel) -> DatePickerView {
        return DatePickerView(viewModel: viewModel)
    }
    
    /// Get widget configuration for use in WidgetKit
    /// - Returns: Widget configuration
    public static func widgetConfiguration() -> BabyAgeWidgetConfiguration {
        return BabyAgeWidgetConfiguration()
    }
}
