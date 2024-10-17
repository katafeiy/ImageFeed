import Foundation
import WebKit

final class ProfileLogoutService {
    
    static let shared = ProfileLogoutService()
    private init() {}
    
    func erase() {
        eraseCookies()
    }
    
    private func eraseCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { records in
                WKWebsiteDataStore.default().removeData(ofTypes: records.dataTypes, for: [records], completionHandler: {})
            }
        }
    }
}
