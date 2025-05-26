import Foundation
import Combine
import SwiftUI

public class BabyAgeViewModel: ObservableObject {
    @Published public var baby: BabyModel?
    @Published public var totalDays: Int = 0
    @Published public var ageFormatted: String = ""
    @Published public var detailedAgeFormatted: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let storage: BabyDataStorage
    
    public init(storage: BabyDataStorage = .shared) {
        self.storage = storage
        loadBabyData()
        setupTimerForDailyUpdates()
    }
    
    public func loadBabyData() {
        baby = storage.loadBaby()
        updateAgeCalculations()
    }
    
    public func saveBaby(_ baby: BabyModel) {
        self.baby = baby
        storage.saveBaby(baby)
        updateAgeCalculations()
    }
    
    public func updateAgeCalculations() {
        guard let birthDate = baby?.birthDate else { return }
        
        totalDays = AgeCalculator.calculateDaysFromBirth(birthDate)
        ageFormatted = AgeCalculator.formatAge(from: birthDate)
        detailedAgeFormatted = AgeCalculator.formatDetailedAge(from: birthDate)
    }
    
    private func setupTimerForDailyUpdates() {
        // Create a timer that fires at midnight for daily updates
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.day! += 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        guard let tomorrow = calendar.date(from: dateComponents) else { return }
        
        let timer = Timer(fire: tomorrow, interval: 86400, repeats: true) { [weak self] _ in
            self?.updateAgeCalculations()
        }
        
        RunLoop.main.add(timer, forMode: .common)
        
        // Also set up a publisher for time zone changes
        NotificationCenter.default.publisher(for: .NSSystemTimeZoneDidChange)
            .sink { [weak self] _ in
                self?.updateAgeCalculations()
            }
            .store(in: &cancellables)
    }
}
