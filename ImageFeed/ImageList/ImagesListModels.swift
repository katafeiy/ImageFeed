import Foundation

struct unSplashPhoto {
    let photo: PhotoResult?
}

struct PhotoResult: Decodable {
    let id: String?
    let width: Int?
    let height: Int?
    let createdAt: String?
    let welcomeDescription: String?
    let ImageURL: ImageUrlsResult?
    let isLike: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case ImageURL = "urls"
        case isLike = "liked_by_user"
    }
}

struct ImageUrlsResult: Decodable {
    let thumb: String?
    let large: String?
    
    enum CodingKeys: String, CodingKey {
        case thumb = "thumb"
        case large = "full"
    }
}

struct Photo {
    let id: String?
    let size: CGSize?
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    var isLike: Bool?
}
