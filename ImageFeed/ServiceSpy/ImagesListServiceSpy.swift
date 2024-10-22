import Foundation

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    
    func eraseImageListService() {
        
    }
    
    func changeLike(photoId: String?, isLike: Bool!, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        completion(.success(true))
    }
    
    /// отслеживать вызов каждого из методов XXXXCalled: Bool
    /// TODO:  прочитать по тестирование (Кидал ранее)

    func loadPhotosRequest(_ token: String, page: String, perPage: String) -> URLRequest? {
        return nil
    }

    func fetchPhotoNextPage(completion: @escaping (Result<[Photo], any Error>) -> Void) {
        completion(.success([]))
    }
}
