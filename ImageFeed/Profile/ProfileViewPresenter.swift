import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    func showAlert()
    func goToAuthViewController()
}

final class ProfileViewPresenter { // Presenter -> delegate? -> ViewController -> showAlert()
    weak var delegate: ProfileViewPresenterProtocol?
   

    func didSelectLogoutButton() {
        delegate?.showAlert()
    }
    
    func logout() {
        OAuth2TokenStorage.token = nil
        delegate?.goToAuthViewController()
    }
}
