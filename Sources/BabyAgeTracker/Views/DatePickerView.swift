// 只使用最基础的数据结构，不依赖SwiftUI
// 创建一个数据模型用于编辑婴儿信息

import Foundation

public struct BabyInputForm {
    public var name: String
    public var birthDate: Date
    public var photoData: Data?
    
    public init(name: String = "", birthDate: Date = Date(), photoData: Data? = nil) {
        self.name = name
        self.birthDate = birthDate
        self.photoData = photoData
    }
    
    // 从现有的婴儿模型创建表单数据
    public init(from baby: BabyModel?) {
        if let baby = baby {
            self.name = baby.name
            self.birthDate = baby.birthDate
            self.photoData = baby.photoData
        } else {
            self.name = ""
            self.birthDate = Date()
            self.photoData = nil
        }
    }
    
    // 创建或更新婴儿模型
    public func createOrUpdateBaby(existingBaby: BabyModel? = nil) -> BabyModel {
        return BabyModel(
            id: existingBaby?.id ?? UUID(),
            name: self.name,
            birthDate: self.birthDate,
            photoData: self.photoData
        )
    }
}

// 定义一个协议用于表单控制器
public protocol BabyFormController {
    // 保存婴儿数据
    func saveBaby(_ baby: BabyModel)
    
    // 获取当前婴儿数据（如果有）
    var currentBaby: BabyModel? { get }
    
    // 检查数据是否有效
    func validateBabyData(_ form: BabyInputForm) -> Bool
}

// BabyAgeViewModel的扩展，实现表单控制器协议
extension BabyAgeViewModel: BabyFormController {
    public var currentBaby: BabyModel? {
        return self.baby
    }
    
    public func validateBabyData(_ form: BabyInputForm) -> Bool {
        // 验证名称不为空
        return !form.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
