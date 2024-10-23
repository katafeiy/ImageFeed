import XCTest
@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
    
    private var app = XCUIApplication() 
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app.launch()
    }

    func testAuthorization() throws {
        
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["WebViewViewController"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextFiled = webView.descendants(matching: .textField).element
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        loginTextFiled.tap()
        loginTextFiled.typeText("fkv.katafey@yandex.ru")
        webView.swipeUp()
        
        let passwordTextFiled = webView.descendants(matching: .secureTextField).element
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        passwordTextFiled.tap()
        passwordTextFiled.typeText("Filippov_82")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        print(app.debugDescription)
    }
    
    func testImagesList() throws {
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["offActive"].tap()
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        cellToLike.buttons["onActive"].tap()
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        cellToLike.tap()
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["BackButton"]
        navBackButtonWhiteButton.tap()
    }

    func testProfile() throws {
        
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Konstantin Filippov"].exists)
        XCTAssertTrue(app.staticTexts["@katafey"].exists)
        
        app.buttons["Logout"].tap()
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["OK"].tap()
    }
}
