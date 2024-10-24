@testable import ImageFeed
import XCTest

final class ImagesListTest: XCTestCase {
    
    func testViewDidLoadedCalled() {
        let presenter = ImagesListViewPresenterSpy()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        presenter.attach(viewController)
        viewController.presenter = presenter
        
        _ = viewController.view
        
        viewController.viewDidLoad()
        
        XCTAssertTrue(presenter.testViewDidLoadCalled)
        
    }
    
    func testArrayIsNotEmpty() {
        let presenter = ImagesListViewPresenterSpy()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        presenter.attach(viewController)
        viewController.presenter = presenter
        
        _ = viewController.view
        
        presenter.photos = [.init(id: "1", size: .init(width: 1, height: 1), createdAt: .init(timeIntervalSince1970: 1), welcomeDescription: "", thumbImageURL: .init(""), largeImageURL: .init(""))]
        
        XCTAssertFalse(presenter.photos.isEmpty)
    }
    
    func testArrayIsEmpty() {
        let presenter = ImagesListViewPresenterSpy()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        presenter.attach(viewController)
        viewController.presenter = presenter
        
        _ = viewController.view
        
        viewController.viewDidLoad()
        
        presenter.photos = []
        
        XCTAssertTrue(presenter.photos.isEmpty)
    }
}
