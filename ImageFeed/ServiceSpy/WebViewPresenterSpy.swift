import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var viewDidLoadCalled: Bool = false
    var view:WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ progress: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
}
