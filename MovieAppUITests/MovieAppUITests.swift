//
//  MovieAppUITests.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import XCTest

final class MovieAppUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testLaunchShowsSearchAndFavoritesTabs() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Search"].exists)
        XCTAssertTrue(app.tabBars.buttons["Favorites"].exists)
    }

    func testFavoritesEmptyState() {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Favorites"].tap()
        XCTAssertTrue(app.staticTexts["No favorites yet"].exists)
    }

    func testSearchFieldExists() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.searchFields.firstMatch.exists)
    }
}
