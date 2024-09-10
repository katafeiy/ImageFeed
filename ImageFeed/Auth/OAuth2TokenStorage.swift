import UIKit

final class OAuth2TokenStorage {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case token
    }
    
    var token: String {
        get {
            storage.string(forKey: Keys.token.rawValue) ?? ""
        }
        set {
            let newToken = storage.string(forKey: Keys.token.rawValue)
            storage.set(newToken, forKey: Keys.token.rawValue)
        }
    }
}

protocol OAuth2TokenStorageProtocol {
    var token: String { get set }
}
