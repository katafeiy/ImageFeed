import UIKit

final class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.vector
        return imageView
    }()
    
    private let oAuth2Service = OAuth2Service.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationView()
        print(#function)
    }
    
    private func configurationView() {
        
        view.backgroundColor = .ypBlack
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 77.68),
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        if let token = OAuth2TokenStorage.token, !token.isEmpty {
            fetchProfileSplash(token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {return}
            authViewController.setDelegate(self)
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
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
            .instantiateViewController(withIdentifier: "TabBarController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        fetchOAuthToken(code, vc)
    }
    
    private func fetchProfileSplash(_ token: String) {
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                guard let userName = profile.userName else { return }
                ProfileImageService.shared.fetchProfileImageURL(token, userName) { _ in }
                self.switchToBarController()
            case .failure(let error):
                print("[fetchProfileSplash]:[Incorrect profile]:[Error:\(error.localizedDescription)]")
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchOAuthToken(_ code: String, _ vc: UIViewController) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else {return}
            switch result {
            case .success (let token):
                vc.dismiss(animated: true){ [weak self] in
                    self?.fetchProfileSplash(token)
                }
            case .failure (let error):
                self.showAlertError()
                print("[fetchOAuthToken]:[Incorrect token]:[Error:\(error.localizedDescription)]")
                break
            }
        }
    }
    
    func showAlertError() {
        
        let alert = UIAlertController(title: "Ой что то пошло не так...(\n",
                                      message: "Не удалось войти в систему\n",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        guard let splash = UIApplication.shared.windows.first?.rootViewController else { return }
        if var topController = splash.presentedViewController {
            while let presented = topController.presentedViewController {
                topController = presented
            }
            topController.present(alert, animated: true)
            return
        }
        splash.present(alert, animated: true)
    }
}
