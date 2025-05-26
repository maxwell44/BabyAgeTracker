import Foundation

public class BabyDataStorage {
    public static let shared = BabyDataStorage()
    
    private let babyKey = "com.babyagetracker.babydata"
    
    public init() {}
    
    public func saveBaby(_ baby: BabyModel) {
        if let encoded = try? JSONEncoder().encode(baby) {
            UserDefaults.standard.set(encoded, forKey: babyKey)
        }
    }
    
    public func loadBaby() -> BabyModel? {
        if let data = UserDefaults.standard.data(forKey: babyKey),
           let baby = try? JSONDecoder().decode(BabyModel.self, from: data) {
            return baby
        }
        return nil
    }
    
    public func deleteBaby() {
        UserDefaults.standard.removeObject(forKey: babyKey)
    }
}
