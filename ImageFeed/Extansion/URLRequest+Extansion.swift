import Foundation

extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        url: URL = {
            guard let url = Constants.defaultBaseURL else { preconditionFailure("IncorrectURL") }
            return url
        }()
    ) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: url)
        else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
