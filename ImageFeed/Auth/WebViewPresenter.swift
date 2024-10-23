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
    }
    
    private func loadAuthView() {
        
        guard let request = authHelper.authRequest() else { return }
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
}

protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func didUpdateProgressValue(_ progress: Double)
    func code(from url: URL) -> String?
    func viewDidLoad()
}
