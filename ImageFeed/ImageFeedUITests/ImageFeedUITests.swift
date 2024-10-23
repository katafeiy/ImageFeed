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
        
        XCTAssert(webView.waitForExistence(timeout: 8))
//        sleep(3)
        
        let loginTextFiled = webView.descendants(matching: .textField).element
        
        XCTAssert(loginTextFiled.waitForExistence(timeout: 8))
//        sleep(3)
        
        loginTextFiled.tap()
        loginTextFiled.typeText("")
        XCUIApplication().toolbars.buttons["Done"].tap()
        webView.swipeUp()
        
        let passwordTextFiled = webView.descendants(matching: .secureTextField).element
        
        XCTAssert(passwordTextFiled.waitForExistence(timeout: 8))
//        sleep(3)
        
        passwordTextFiled.tap()
        passwordTextFiled.typeText("")
        XCUIApplication().toolbars.buttons["Done"].tap()
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
//        sleep(3)
        
//        print(app.debugDescription)
    }
    
    func testImagesList() throws {
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(3)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["offActive"].tap()
//        cellToLike.buttons["likeButtonTap"].tap()
        
        sleep(3)
                
        cellToLike.buttons["offActive"].tap()
//        cellToLike.buttons["likeButtonTap"].tap()
        
        sleep(3)
        
        cellToLike.tap()
        
        sleep(3)
        
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
        app.alerts["ByeByeAlert!"].scrollViews.otherElements.buttons["yesAction"].tap()
    }
}
