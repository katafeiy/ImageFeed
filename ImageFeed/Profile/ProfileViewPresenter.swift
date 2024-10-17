import UIKit
import SwiftKeychainWrapper

protocol ProfileViewPresenterProtocol: AnyObject {
    func showAlert()
    func goToAuthViewController()
}

final class ProfileViewPresenter { // Presenter -> delegate? -> ViewController -> showAlert()
    weak var delegate: ProfileViewPresenterProtocol?
    
    func avatarURL() -> URL? {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
   
    func didSelectLogoutButton() {
        delegate?.showAlert()
    }
    
    func logout() {
        OAuth2TokenStorage.clear()
        ProfileLogoutService.shared.erase()
        ProfileService.shared.eraseProfile()
        ProfileImageService.shared.eraseProfileImage()
        ImagesListService.shared.eraseImageListService()
        delegate?.goToAuthViewController()
        NotificationCenter.default.post(name: .init(rawValue: "removePhotoArrayObserver"), object: nil)
    }
}
