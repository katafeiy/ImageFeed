import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    static var token: String? = KeychainWrapper.standard.string(forKey: Keys.token.rawValue) {
        didSet {
            guard let token else { return }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: Keys.token.rawValue)
            guard isSuccess else { return }
        }
    }
    
    static func clear() {
        KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
        token = nil
    }
}




