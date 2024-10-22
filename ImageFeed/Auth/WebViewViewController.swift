import UIKit
@preconcurrency import WebKit

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    
    var presenter: WebViewPresenterProtocol?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var progressView: UIProgressView!
    
    private var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        configProgressView()
        updateProgressObservation()
                
    }
    
    private func configProgressView() {
        progressView.progress = 0.5
        progressView.progressTintColor = .ypBlack
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    private func updateProgressObservation() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return}
                 self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
    }
    
    func setDelegate(_ delegate: WebViewViewControllerDelegate) {
        self.delegate = delegate
    }
    
    func setProgressValue(_ progress: Float) {
        progressView.progress = progress
    }
    
    func setProgressHidden(_ hidden: Bool) {
        progressView.isHidden = hidden
    }
    
    @IBAction private func tapBackButton(_ sender: Any) {
        guard let delegate else { return }
        delegate.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let code = code(from: navigationAction) {
            
            guard let delegate else { return }
            
            delegate.webViewViewController(self, didAuthenticateWithCode: code)
            
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}

protocol WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

protocol WebViewViewControllerProtocol: AnyObject {
    
    var presenter: WebViewPresenterProtocol? { get set }
    func setDelegate(_ delegate: WebViewViewControllerDelegate)
    func load(request: URLRequest)
    func setProgressValue(_ progress: Float)
    func setProgressHidden(_ hidden: Bool)
}
