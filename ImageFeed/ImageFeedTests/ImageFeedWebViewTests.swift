import ImageFeed
import XCTest

final class WebWiewTests: XCTestCase {
    
    func testViewControllerClassViewDidLoad() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
    }

}

