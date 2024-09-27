import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    private func loadOAuth2ServiceToken(code: String) -> URLRequest? {
        
        guard var urlComponent = URLComponents(string: OAuth2ServiceConstants.unSplashTokenURLString)
        else {
            preconditionFailure("Incorrect URL")
        }
        
        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponent.url else {
            preconditionFailure("Incorrect URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping Closure.ClosureResultStringError) {
        
        // Логика для предотвращения гонки
        
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        
        guard let request = loadOAuth2ServiceToken(code: code)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            print("[fetchOAuthToken -> loadOAuth2ServiceToken]:[Invalid request]-[Error: \(AuthServiceError.invalidRequest)")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let authToken):
                guard let authToken = authToken.accessToken else { return }
                OAuth2TokenStorage.token = authToken
                completion(.success(authToken))
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
                print("[fetchOAuthToken -> objectTask]:[Incorrect token]-[Error: \(error.localizedDescription)]")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

enum OAuth2ServiceConstants {
    static let unSplashTokenURLString = "https://unsplash.com/oauth/token"
}

enum AuthServiceError: Error {
    case invalidRequest
}


