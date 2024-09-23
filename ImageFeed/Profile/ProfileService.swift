import UIKit

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

final class ProfileService {
    
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    
    private func loadProfileRequest(_ token: String?) -> URLRequest? {
        
        guard let url = Constants.defaultBaseURL else { preconditionFailure("Incorrect URL") }
        
        var request = URLRequest.setHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            url: url)
        
        guard let token else { preconditionFailure("Incorrect Token") }
    
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = loadProfileRequest(token) else { return }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error> ) in
            
            guard let self else { return }
            
            switch result {
                case .success(let profileResult):
                self.profile = Profile(userName: ("\(profileResult.userName ?? "")"),
                                       fullName: ("\(profileResult.firstName ?? "")"+" "+"\(profileResult.lastName ?? "")"),
                                       loginName: ("@\(profileResult.userName ?? "")"),
                                       bio: ("\(profileResult.bio ?? "")"))
            case .failure(let error):
                print("Incorrect profile: \(error.localizedDescription)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}


