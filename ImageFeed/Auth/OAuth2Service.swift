import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private init() {}
    
    private func loadOAuth2ServiceToken(code: String) -> URLRequest {
        
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
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let request = loadOAuth2ServiceToken(code: code)
        
        let task = URLSession.shared.data(for: request) { result in
            
            print("3: urlsession")
            
            switch result {
                
            case .success(let data):
                
                print("4:\(data)")
                
                do {
                    
                    print("6:\(data)")
                    
                    let authToken = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    
                    guard let authToken = authToken.accessToken else { return }
                    
                    print("5: \(authToken))")
                    
                    completion(.success(authToken))
                    
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

enum OAuth2ServiceConstants {
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
}



