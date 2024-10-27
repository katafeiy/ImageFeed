@testable import ImageFeed
import XCTest

final class ProfileTest: XCTestCase {
    
    func testEraseServicesCalled() {
        
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        viewController.viewDidLoad()
        presenter.eraseServises()
        
        XCTAssertTrue(presenter.eraseServicesCalled)
        
    }
    
    func testLoggoutCalled() {
        
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        viewController.viewDidLoad()
        presenter.logout()
        
        XCTAssertTrue(presenter.logoutCalled)
                
    }
    
    func testTokenIsNil() {
        
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        viewController.viewDidLoad()
        presenter.logout()
        
        XCTAssertEqual(OAuth2TokenStorage.token, nil)
        
    }
}
