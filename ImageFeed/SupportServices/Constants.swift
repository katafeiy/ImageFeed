import UIKit

class Closure {
    typealias ClosureResultDataError = (Result<Data, Error>) -> Void
    typealias ClosureResultStringError = (Result<String, Error>) -> Void
}

enum Constants {
    
    static let accessKey = "FjboiHJifnIgeMzjX4GftScq06L9uM6ENVsXGBGHgGc"
    static let secretKey = "BeIfnH5J6JfabXKs_oVz1W8dMIkl4cKC4C3_ljTBbus"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let unSplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    
    static var standard: AuthConfiguration {
        
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 authURLString: Constants.unSplashAuthorizeURLString)
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
 
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
