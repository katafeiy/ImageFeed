import UIKit

final class OAuth2Service {

    static let shared = OAuth2Service()
    
    
    private var task: URLSessionTask?
    private var lastCode: String?

    private init() {}
 
    private func loadOAuth2ServiceToken(code: String) -> URLRequest? {
        
        guard var urlComponent = URLComponents(string: OAuth2ServiceConstants.unsplashTokenURLString)
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
        
        guard
            let request = loadOAuth2ServiceToken(code: code)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
    
        let task = URLSession.shared.data(for: request) { result in
    
            switch result {
            case .success(let data):
                do {
                    let authToken = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    guard let authToken = authToken.accessToken else { return }
                    completion(.success(authToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
                self.lastCode = nil
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

enum OAuth2ServiceConstants {
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
}

enum AuthServiceError: Error {
    case invalidRequest
}


