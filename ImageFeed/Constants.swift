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
}


