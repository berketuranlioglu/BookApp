//
//  FetchingDataTests.swift
//  BookAppTests
//
//  Created by Berke Turanlıoğlu on 3.12.2023.
//

import XCTest
@testable import BookApp

final class FetchingDataTests: XCTestCase {
    
    func testDataIsFetchedFromUrl() {
        // Given
        var comingData: Data? = nil
        
        // When
        BookManager.shared.performRequest(urlString: UrlConstants.mainUrl, handler: { data in
            comingData = data
            XCTAssertNotNil(comingData) // it is async, therefore it should now be Data
        })
        
        // Then (because it is async function, it should go as nil
        XCTAssertNil(comingData)
    }
    
    func testLoadHomeView() {
        // Given
        let viewModel = BookViewModel()
        var isLoadedSuccessfully: Bool = false
        
        // When
        viewModel.loadHomeView(loadedSuccessfully: {
            isLoadedSuccessfully = true
            XCTAssertTrue(isLoadedSuccessfully) // it is async, therefore it should now be true
        })
        
        // Then (because it is async function, it should go as false
        XCTAssertFalse(isLoadedSuccessfully)
    }

}
