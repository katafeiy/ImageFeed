import UIKit
@preconcurrency import WebKit

final class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var progressView: UIProgressView!
    
    private var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        webView.navigationDelegate = self
        loadAuthView()
        configProgressView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self,
                               forKeyPath: #keyPath(WKWebView.estimatedProgress),
                               context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func setDelegate(_ delegate: WebViewViewControllerDelegate) {
        self.delegate = delegate
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    
    private func configProgressView() {
        progressView.progress = 0.5
        progressView.progressTintColor = .ypBlack
    }
    
    private func loadAuthView() {
        
        guard var urlComponents = URLComponents(string: WebViewConstatns.unsplashAuthorizeURLString) else {
            print("Incorrect URLComponents")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("Incorrect URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
    @IBAction private func tapBackButton(_ sender: Any) {
        
        guard let delegate else { return }
        delegate.webViewViewControllerDidCancel(self)
        
    }    
}

enum WebViewConstatns {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
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
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

protocol WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

protocol WebViewViewControllerProtocol {
    func setDelegate()
}
