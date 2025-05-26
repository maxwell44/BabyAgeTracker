import XCTest
@testable import BabyAgeTracker

final class AgeCalculatorTests: XCTestCase {
    func testCalculateDaysFromBirth() {
        let calendar = Calendar.current
        let today = Date()
        
        // Test with a date 100 days ago
        let birthDate100DaysAgo = calendar.date(byAdding: .day, value: -100, to: today)!
        XCTAssertEqual(AgeCalculator.calculateDaysFromBirth(birthDate100DaysAgo), 100)
        
        // Test with a date 365 days ago
        let birthDate365DaysAgo = calendar.date(byAdding: .day, value: -365, to: today)!
        XCTAssertEqual(AgeCalculator.calculateDaysFromBirth(birthDate365DaysAgo), 365)
        
        // Test with today (should be 0)
        XCTAssertEqual(AgeCalculator.calculateDaysFromBirth(today), 0)
    }
    
    func testFormatDetailedAge() {
        let calendar = Calendar.current
        let today = Date()
        
        // Test with a date 1 year, 2 months, and 5 days ago
        var components = DateComponents()
        components.year = -1
        components.month = -2
        components.day = -5
        let pastDate = calendar.date(byAdding: components, to: today)!
        
        let formattedAge = AgeCalculator.formatDetailedAge(from: pastDate)
        XCTAssertTrue(formattedAge.contains("1 year"))
        XCTAssertTrue(formattedAge.contains("2 months"))
        XCTAssertTrue(formattedAge.contains("5 days"))
    }
}
