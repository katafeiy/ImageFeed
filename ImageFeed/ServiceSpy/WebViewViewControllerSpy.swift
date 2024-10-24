import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var loadRequestCalled: Bool = false
    var presenter: WebViewPresenterProtocol?
    
    func setDelegate(_ delegate: any WebViewViewControllerDelegate) {
        
    }
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ progress: Float) {
        
    }
    
    func setProgressHidden(_ hidden: Bool) {
        
    }

}
