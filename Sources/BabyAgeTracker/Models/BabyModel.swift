import Foundation

public struct BabyModel: Identifiable, Codable, Equatable {
    public var id: UUID
    public var name: String
    public var birthDate: Date
    public var photoData: Data?
    
    public init(id: UUID = UUID(), name: String, birthDate: Date, photoData: Data? = nil) {
        self.id = id
        self.name = name
        self.birthDate = birthDate
        self.photoData = photoData
    }
    
    public static func == (lhs: BabyModel, rhs: BabyModel) -> Bool {
        lhs.id == rhs.id
    }
}
