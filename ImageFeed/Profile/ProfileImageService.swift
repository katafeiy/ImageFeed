import UIKit

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    
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
        
        var request = URLRequest.setHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            url: url)
    
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(_ token: String, _ username: String, _ completion: @escaping Closure.ClosureResultStringError) {
        
        guard let request = loadProfileImageRequest(token, username) else { return }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do  {
                    let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                    self.avatarURL = userResult.profileImage?.small
                    guard let avatarURL = self.avatarURL else {return}
                    completion(.success(avatarURL))
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["URL": avatarURL])
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

