import Foundation

public struct AgeCalculator {
    /// Calculate days between birth date and current date
    /// - Parameter birthDate: The baby's birth date
    /// - Returns: Number of days since birth
    public static func calculateDaysFromBirth(_ birthDate: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Calculate days between dates
        let components = calendar.dateComponents([.day], from: birthDate, to: currentDate)
        return components.day ?? 0
    }
    
    /// Calculate detailed age information
    /// - Parameter birthDate: The baby's birth date
    /// - Returns: A tuple with years, months, weeks, and days
    public static func calculateDetailedAge(from birthDate: Date) -> (years: Int, months: Int, weeks: Int, days: Int) {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: birthDate, to: currentDate)
        
        return (
            years: components.year ?? 0,
            months: components.month ?? 0,
            weeks: components.weekOfYear ?? 0,
            days: components.day ?? 0
        )
    }
    
    /// Format age as a readable string
    /// - Parameter birthDate: The baby's birth date
    /// - Returns: A formatted string showing the age
    public static func formatAge(from birthDate: Date) -> String {
        let days = calculateDaysFromBirth(birthDate)
        return "\(days) days"
    }
    
    /// Get a detailed formatted age string
    /// - Parameter birthDate: The baby's birth date
    /// - Returns: A detailed formatted string
    public static func formatDetailedAge(from birthDate: Date) -> String {
        let age = calculateDetailedAge(from: birthDate)
        
        var parts: [String] = []
        
        if age.years > 0 {
            let yearString = age.years == 1 ? "year" : "years"
            parts.append("\(age.years) \(yearString)")
        }
        
        if age.months > 0 {
            let monthString = age.months == 1 ? "month" : "months"
            parts.append("\(age.months) \(monthString)")
        }
        
        if age.weeks > 0 {
            let weekString = age.weeks == 1 ? "week" : "weeks"
            parts.append("\(age.weeks) \(weekString)")
        }
        
        if age.days > 0 || parts.isEmpty {
            let dayString = age.days == 1 ? "day" : "days"
            parts.append("\(age.days) \(dayString)")
        }
        
        return parts.joined(separator: ", ")
    }
}
