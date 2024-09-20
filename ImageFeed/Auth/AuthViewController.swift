import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    private let showWebView = "ShowWebView"
    private var webView: WebViewViewControllerProtocol?
    private var tokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service.shared
    private var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
    
    func setDelegate(_ delegate: AuthViewControllerDelegate ) {
        self.delegate = delegate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showWebView {
            guard let webView = segue.destination as? WebViewViewController
                    
            else { 
                assertionFailure("Invalid segue destination")
                return }
            webView.setDelegate(self)
        }
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                
                OAuth2TokenStorage.token = token
                delegate?.didAuthenticate(self, didAuthenticateWithCode: code)
                
            case .failure(let error):
                print("Ошибка чтения токена: \(error)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
}

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
