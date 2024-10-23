import Foundation

final class ProfilePresenterSpy: ProfileViewProtocol {
    var avatarURLCalled: Bool = false
    var eraseServicesCalled: Bool = false
    var logoutCalled: Bool = false
    
    weak var delegate: ProfileViewPresenterProtocol?
    
    func avatarURL() -> URL? {
        avatarURLCalled = true
        return nil
    }

    func logout() {
        OAuth2TokenStorage.clear()
        eraseServises()
        delegate?.goToAuthViewController()
        NotificationCenter.default.post(name: .init(rawValue: "removePhotoArrayObserver"), object: nil)
        logoutCalled = true
    }
    
    func showAlert() {
        
    }
    
    func didSelectLogoutButton() {
        
    }
    
    func eraseServises() {
        eraseServicesCalled = true
    }
}
