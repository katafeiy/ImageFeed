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
            guard let self = self else { return }
            
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
            
        }
    }
    
    private func fetchProfile(_ token: String) {
        
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.switchToBarController()
                
            case .failure:
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
        
    }
    
    private func fetchProfileImageURL(_ token: String, _ username: String) {
        
        ProfileImageService.shared.fetchProfileImageURL(token, username) { result in
            
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success (let token):
                fetchProfile(token)
                self.switchToBarController()
            case .failure (let error):
                print("Incorrect token: \(error.localizedDescription)")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}

