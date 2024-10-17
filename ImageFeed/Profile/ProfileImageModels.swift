import Foundation

// MARK: Модель для декодирования данных аватарки

struct UserResult: Codable {
    let profileImage: ImageURL?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageURL: Codable {
    let small: String?
    
    enum CodingKeys: String, CodingKey {
        case small = "small"
    }
}
