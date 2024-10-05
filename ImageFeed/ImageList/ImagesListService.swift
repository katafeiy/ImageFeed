import Foundation

struct Photo {
    let id: String?
    let size: CGSize?
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLike: Bool?
}

struct PhotoResult: Decodable {
    let id: String?
    let width: Int?
    let height: Int?
    let createdAt: Date?
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

final class ImagesListService {
    
    static let shared = ImagesListService()
    private init() {}
    
    static let didChangeNotification: Notification.Name = .init("ImagesListServiceDidChange")
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let perPage = "10"
    private var task: URLSessionTask?
    
    func loadPhotosRequest(_ token: String, page: String, perPage: String) -> URLRequest? {
        
        guard let url = Constants.defaultBaseURL else { preconditionFailure("Incorrect URL") }
        
        var request = URLRequest.setHTTPRequest(
            path: "/photos?page=\(page)&per_page=\(perPage)",
            httpMethod: "GET",
            url: url)
        
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotoNextPage(completion: @escaping (Result<Photo, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        let page = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let token = OAuth2TokenStorage.token else { return }
        
        guard let request = loadPhotosRequest(token, page: String(page), perPage: perPage) else { return }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photos):
                let newPhotos = Photo(id: photos.id,
                                      size: CGSize(width: Double(photos.width ?? 0), height: Double(photos.height ?? 0)),
                                      createdAt: photos.createdAt,
                                      welcomeDescription: photos.welcomeDescription,
                                      thumbImageURL: photos.ImageURL?.thumb,
                                      largeImageURL: photos.ImageURL?.large,
                                      isLike: photos.isLike)
                self.photos.append(newPhotos)
                self.lastLoadedPage = page
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                object: self,
                                                userInfo: ["URL": newPhotos])
                completion(.success(newPhotos))
            case .failure(let error):
                print("[fetchPhotoNextPage -> objectTask]:[Incorrect photos]: [Error: \(error.localizedDescription) ]")
                completion(.failure(error))
                break
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

protocol ImagesListServiceProtocol {
    
    func getImagesList(completion: @escaping (Result<Photo, Error>) -> Void)
    func loadPhotosRequest(_ token: String, page: String, perPage: String) -> URLRequest?
    var photos: [Photo] { get }
    
}
