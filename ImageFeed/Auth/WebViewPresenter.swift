import Foundation


final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        loadAuthView()
    }
    
    func didUpdateProgressValue(_ progress: Double) {
        let newProgressValue = Float(progress)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for valve: Float) -> Bool {
        abs(valve - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        
        authHelper.code(from: url)
        
//        if
//            let urlComponents = URLComponents(string: url.absoluteString),
//            urlComponents.path == "/oauth/authorize/native",
//            let items = urlComponents.queryItems,
//            let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
        
    }
    
    private func loadAuthView() {
        
        guard let request = authHelper.authRequest() else { return }
        view?.load(request: request)
        didUpdateProgressValue(0)
        
//        guard var urlComponents = URLComponents(string: Constants.unSplashAuthorizeURLString) else {
//            print("Incorrect URLComponents")
//            return
//        }
//
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: Constants.accessKey),
//            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: Constants.accessScope)
//        ]
//
//        guard let url = urlComponents.url else {
//            print("Incorrect URL")
//            return
//        }
//
//        let request = URLRequest(url: url)
    }
}

protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func didUpdateProgressValue(_ progress: Double)
    func code(from url: URL) -> String?
    func viewDidLoad()
}
