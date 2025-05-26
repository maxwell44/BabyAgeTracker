import Foundation

public class BabyDataStorage {
    public static let shared = BabyDataStorage()
    
    private let babyKey = "com.babyagetracker.babydata"
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults? = nil) {
        // 如果提供了特定的UserDefaults(如App Group共享的)，则使用它
        // 否则使用标准UserDefaults
        self.userDefaults = userDefaults ?? UserDefaults.standard
    }
    
    public func saveBaby(_ baby: BabyModel) {
        if let encoded = try? JSONEncoder().encode(baby) {
            userDefaults.set(encoded, forKey: babyKey)
        }
    }
    
    public func loadBaby() -> BabyModel? {
        if let data = userDefaults.data(forKey: babyKey),
           let baby = try? JSONDecoder().decode(BabyModel.self, from: data) {
            return baby
        }
        return nil
    }
    
    public func deleteBaby() {
        userDefaults.removeObject(forKey: babyKey)
    }
}
