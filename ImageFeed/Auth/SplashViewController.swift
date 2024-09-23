import UIKit

final class SplashViewController: UIViewController {
    
    private let showAuthViewControllerSegueIdentifier = "showAuthViewController"
    private let oAuth2Service = OAuth2Service.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = OAuth2TokenStorage.token, !token.isEmpty {
            fetchProfile(token)
            self.switchToBarController()
        } else {
            performSegue(withIdentifier: showAuthViewControllerSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showAuthViewControllerSegueIdentifier {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthViewControllerSegueIdentifier)")
                return
            }
            
            viewController.setDelegate(self)
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self, let token = OAuth2TokenStorage.token else { return }
            
            fetchProfile(token)
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
            
        }
    }
    
    private func fetchProfile(_ token: String) {
        
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToBarController()
            case .failure:
                break
            }
        }
        
        guard let profile = ProfileService.shared.profile, let username = profile.userName else { return }
        
        ProfileImageService.shared.fetchProfileImageURL(token, username: username) { result in
            
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success:
                self.switchToBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
}

