import UIKit

final class ImagesListService: ImagesListServiceProtocol {
    
    static let shared = ImagesListService()
    private init() {}
    
    static let didChangeNotification: Notification.Name = .init("ImagesListServiceDidChange")
    private var lastLoadedPage: Int?
    private let perPage = "10"
    private var task: URLSessionTask?

    private let dateFormatter = ISO8601DateFormatter()
    
    func loadPhotosRequest(_ token: String, page: String, perPage: String) -> URLRequest? {
        
        guard let url = Constants.defaultBaseURL else { preconditionFailure("Incorrect URL") }
        
        var request = URLRequest.setHTTPRequest(
            path: "/photos?page=\(page)&&per_page=\(perPage)",
            httpMethod: "GET",
            url: url)
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotoNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        let page = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let token = OAuth2TokenStorage.token else { return }
        
        guard let request = loadPhotosRequest(token, page: String(page), perPage: perPage) else { return }
        print(page)
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResults):
                
                let photos = photoResults.map({ photoResult in
                    self.convert(photoResult)
                })
                
                self.lastLoadedPage = page
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                object: self,
                                                userInfo: ["Images": photos])
                completion(.success(photos))
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
    
    private func convert(_ photoResult: PhotoResult) -> Photo {
        let newPhotos = Photo(id: photoResult.id ?? "",
                              size: CGSize(width: Double(photoResult.width ?? 0), height: Double(photoResult.height ?? 0)),
                              createdAt: dateFormatter.date(from: photoResult.createdAt ?? "") ?? Date(),
                              welcomeDescription: photoResult.welcomeDescription ?? "",
                              thumbImageURL: photoResult.ImageURL?.thumb ?? "",
                              largeImageURL: photoResult.ImageURL?.large ?? "",
                              isLike: photoResult.isLike ?? false)
        return newPhotos
    }
    
    func changeLike(photoId: String?, isLike: Bool! = false, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let token = OAuth2TokenStorage.token, let photoId else { return }
        guard let request = isLike ? postLikeRequest(token, photoId) : deleteLikeRequest(token, photoId) else { return }
         
        let task = URLSession.shared.objectTask(for: request) { (result: Result<UnSplashPhoto, Error>) in
            
            self.task = nil
            switch result {
            case .success(let photoResult):
                
                let isLike = photoResult.photo?.isLike ?? false
                print("Is like: \(String(describing: isLike))")
                completion(.success(isLike))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    // Устанавливаем лайк
    
    func postLikeRequest(_ token: String, _ photoId: String) -> URLRequest? {
        
        guard let url = Constants.defaultBaseURL else { preconditionFailure("Incorrect URL") }
        
        var requestLikeOn = URLRequest.setHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: "POST",
            url: url)
        requestLikeOn?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return requestLikeOn
    }
    
    // Снимаем лайк
    
    func deleteLikeRequest(_ token: String, _ photoId: String) -> URLRequest? {
        
        guard let url = Constants.defaultBaseURL else { preconditionFailure("Incorrect URL") }
        
        var requestLikeOff = URLRequest.setHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: "DELETE",
            url: url)
        requestLikeOff?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return requestLikeOff
    }
    
    func eraseImageListService() {
        lastLoadedPage = nil
        task?.cancel()
        task = nil
    }
    
}

protocol ImagesListServiceProtocol {
    func changeLike(photoId: String?, isLike: Bool!, _ completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchPhotoNextPage(completion: @escaping (Result<[Photo], Error>) -> Void)
    func loadPhotosRequest(_ token: String, page: String, perPage: String) -> URLRequest?
    func eraseImageListService()
}

