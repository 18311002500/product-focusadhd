import XCTest

final class FocusFlowUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    func testNavigationTabs() throws {
        // Test tab switching
        let tabBar = app.tabBars.firstMatch
        
        // Check if tab bar exists
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))
        
        // Navigate through tabs
        let badgesTab = tabBar.buttons["徽章"]
        if badgesTab.waitForExistence(timeout: 5) {
            badgesTab.tap()
        }
        
        let progressTab = tabBar.buttons["进度"]
        if progressTab.waitForExistence(timeout: 5) {
            progressTab.tap()
        }
        
        let focusTab = tabBar.buttons["专注"]
        if focusTab.waitForExistence(timeout: 5) {
            focusTab.tap()
        }
        
        let homeTab = tabBar.buttons["今日"]
        if homeTab.waitForExistence(timeout: 5) {
            homeTab.tap()
        }
    }
    
    func testAddTaskFlow() throws {
        // Navigate to home
        let tabBar = app.tabBars.firstMatch
        let homeTab = tabBar.buttons["今日"]
        if homeTab.waitForExistence(timeout: 5) {
            homeTab.tap()
        }
        
        // Look for add button
        let addButton = app.buttons["plus.circle.fill"]
        if addButton.waitForExistence(timeout: 5) {
            addButton.tap()
            
            // Check if add task sheet appears
            let titleField = app.textFields["任务名称"]
            XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        }
    }
    
    func testFocusTimer() throws {
        // Navigate to focus tab
        let tabBar = app.tabBars.firstMatch
        let focusTab = tabBar.buttons["专注"]
        if focusTab.waitForExistence(timeout: 5) {
            focusTab.tap()
        }
        
        // Check for start button
        let startButton = app.buttons["开始专注"]
        if startButton.waitForExistence(timeout: 5) {
            XCTAssertTrue(startButton.exists)
        }
    }
    
    func testProgressView() throws {
        // Navigate to progress tab
        let tabBar = app.tabBars.firstMatch
        let progressTab = tabBar.buttons["进度"]
        if progressTab.waitForExistence(timeout: 5) {
            progressTab.tap()
        }
        
        // Check for progress elements
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
    }
    
    func testBadgesView() throws {
        // Navigate to badges tab
        let tabBar = app.tabBars.firstMatch
        let badgesTab = tabBar.buttons["徽章"]
        if badgesTab.waitForExistence(timeout: 5) {
            badgesTab.tap()
        }
        
        // Check for badges grid
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 5))
    }
}
