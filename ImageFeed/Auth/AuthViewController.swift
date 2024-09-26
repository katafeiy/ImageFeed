import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    private let showWebView = "ShowWebView"
    private var webView: WebViewViewControllerProtocol?
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
        
                delegate?.didAuthenticate(self, didAuthenticateWithCode: code)
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
