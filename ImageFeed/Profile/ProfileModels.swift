import Foundation

// MARK: Модель для декодирования данных профиля

struct ProfileResult: Codable {
    let userName: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    let userName: String?
    let fullName: String?
    let loginName: String?
    let bio: String?
}

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
