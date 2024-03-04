//
//  DavidWeeCodeChallengeTests.swift
//  DavidWeeCodeChallengeTests
//
//  Created by David Wee on 3/1/24.
//

import XCTest
import Combine
@testable import DavidWeeCodeChallenge

final class DavidWeeCodeChallengeTests: XCTestCase {

    var sut: SearchImageViewModel!
    var networkMock: NetworkMock! = NetworkMock()

    override func setUp() {
        super.setUp()
        sut = SearchImageViewModel(network: networkMock)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        networkMock = nil
    }

    private func loadItems(string: String) {
        let expectaion = expectation(description: "Wait for items")
        var cancellable: AnyCancellable?

        cancellable = sut.$itemColumns.dropFirst().sink { _ in
            expectaion.fulfill()
            cancellable = nil
        }

        sut.searchString = string
        waitForExpectations(timeout: 2.0)
    }

    func testValidItemsResponse() {
        // When items are loaded successfully
        loadItems(string: "image_list_success")

        // Error message should be nil
        XCTAssertNil(sut.errorMessage)
        // Has Items shold be true
        XCTAssertTrue(sut.hasItems)
        
        // Column 3 should have 2 items since it is the smallest
        XCTAssertEqual(sut.itemColumns[0].count, 1)
        XCTAssertEqual(sut.itemColumns[1].count, 1)
        XCTAssertEqual(sut.itemColumns[2].count, 2)
    }

    func testEmptyItemsResponse() {
        // When items are empty
        networkMock.mock(endpoint: ImageEndpoint.search(tag: "image_list_empty"), with: "image_list_empty")
        loadItems(string: "image_list_empty")

        // Error message should be empty message
        XCTAssertEqual(sut.errorMessage, Strings.Search.noItems("image_list_empty"))
        // Has Items shold be false
        XCTAssertFalse(sut.hasItems)

        // Columns should be empty
        XCTAssertEqual(sut.itemColumns[0].count, 0)
        XCTAssertEqual(sut.itemColumns[1].count, 0)
        XCTAssertEqual(sut.itemColumns[2].count, 0)
    }

    func testErrorItemsResponse() {
        // There is an invalid response
        networkMock.mock(endpoint: ImageEndpoint.search(tag: "image_list_failure"), with: "image_list_failure")
        loadItems(string: "image_list_failure")

        // Error message should be empty message
        XCTAssertEqual(sut.errorMessage, Strings.APIErrors.generic)
        // Has Items shold be false
        XCTAssertFalse(sut.hasItems)

        // Columns should be empty
        XCTAssertEqual(sut.itemColumns.count, 0)
    }
}
