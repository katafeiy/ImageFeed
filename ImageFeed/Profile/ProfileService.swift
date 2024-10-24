import UIKit

final class ProfileService {
    
//  MARK: Объявление строгого singleton:
    
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    
    
    private func loadProfileRequest(_ token: String?) -> URLRequest? {
        
//        guard let url = Constants.defaultBaseURL else { preconditionFailure("Incorrect URL") }
        
        var request = URLRequest.setHTTPRequest(
            path: "/me",
            httpMethod: "GET")
        
        guard let token else { preconditionFailure("Incorrect token") }
    
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = loadProfileRequest(token) else { return }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
                case .success(let profileResult):
                self.profile = Profile(userName: ("\(profileResult.userName ?? "")"),
                                       fullName: ("\(profileResult.firstName ?? "")"+" "+"\(profileResult.lastName ?? "")"),
                                       loginName: ("@\(profileResult.userName ?? "")"),
                                       bio: ("\(profileResult.bio ?? "")"))
                guard let profile = self.profile else { return }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
                print("[fetchProfile -> objectTask]:[Incorrect profile]: [Error:\(error.localizedDescription)]")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func eraseProfile() {
        profile = nil
        task?.cancel()
        task = nil
    }    
}


