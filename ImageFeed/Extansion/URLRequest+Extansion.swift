import Foundation

extension URLRequest {
    
    static func setHTTPRequest(
        path: String,
        httpMethod: String
    ) -> URLRequest? {
        
        let urlDefault: URL = AuthConfiguration.standard.defaultBaseURL
        guard let url = URL(string: path, relativeTo: urlDefault)
        else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
