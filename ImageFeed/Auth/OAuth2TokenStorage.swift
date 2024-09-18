import UIKit

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    static var token: String? = UserDefaults.standard.string(forKey: Keys.token.rawValue) {
        didSet {
            UserDefaults.standard.set(token, forKey: Keys.token.rawValue)
        }
    }
}




