import UIKit

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    
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
    
    private func loadProfileImageRequest(_ token: String?, _ username: String?) -> URLRequest? {
        
        guard
            let url = Constants.defaultBaseURL,
            let token = token,
            let username = username
        else { preconditionFailure("Incorrect URL") }
        print("url: \(url)")
        var request = URLRequest.setHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            url: url)
    
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(_ token: String, _ username: String, _ completion: @escaping Closure.ClosureResultStringError) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = loadProfileImageRequest(token, username) else { return }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            
            guard let self else { return }
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage?.small
                guard let avatarURL = self.avatarURL else { return }
                completion(.success(avatarURL))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                object: self,
                                                userInfo: ["URL": avatarURL])
            case .failure(let error):
                completion(.failure(error))
                print("Invalid response: \(error.localizedDescription)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

