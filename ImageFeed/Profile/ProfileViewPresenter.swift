import UIKit
import SwiftKeychainWrapper

protocol ProfileViewPresenterProtocol: AnyObject {
    var delegate: ProfileViewControllerProtocol? { get set }
    func avatarURL() -> URL?
    func didSelectLogoutButton()
    func logout()
    func eraseServises()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol { // Presenter -> delegate? -> ViewController -> showAlert()
    weak var delegate: ProfileViewControllerProtocol?
    
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
        eraseServises()
        delegate?.goToAuthViewController()
        NotificationCenter.default.post(name: .init(rawValue: "removePhotoArrayObserver"), object: nil)
    }
    
    func eraseServises() {
        ProfileService.shared.eraseProfile()
        ProfileImageService.shared.eraseProfileImage()
        ImagesListService.shared.eraseImageListService()
        ProfileLogoutService.shared.erase()
    }
    
}
