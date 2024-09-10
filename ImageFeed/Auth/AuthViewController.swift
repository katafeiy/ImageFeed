import UIKit

final class AuthViewController: UIViewController {
    
    private let showWebView = "ShowWebView"
    private var webView: WebViewViewControllerProtocol?
    private var tokenStorage: OAuth2TokenStorageProtocol?
    private let oauth2Service = OAuth2Service.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showWebView {
            
            guard let webView = segue.destination as? WebViewViewController
                    
            else {
                
                assertionFailure("Invalid segue destination")
                return
            }
            
            webView.setDelegate(self)
        }
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let token):
                
                self.tokenStorage?.token = token
                
            case .failure(let error):
                
                print("Ошибка чтения токена: \(error) ")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
}
