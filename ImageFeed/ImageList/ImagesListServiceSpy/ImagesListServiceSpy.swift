import Foundation

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    /// отслеживать вызов каждого из методов XXXXCalled: Bool
    /// TODO:  прочитать по тестирование (Кидал ранее)

    func loadPhotosRequest(_ token: String, page: String, perPage: String) -> URLRequest? {
        return nil
    }

    func fetchPhotoNextPage(completion: @escaping (Result<[Photo], any Error>) -> Void) {
        completion(.success([]))
    }
}
