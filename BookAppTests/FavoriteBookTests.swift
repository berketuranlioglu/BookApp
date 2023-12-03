//
//  FavoriteBookTests.swift
//  BookAppTests
//
//  Created by Berke Turanlıoğlu on 3.12.2023.
//

import XCTest
@testable import BookApp

final class FavoriteBookTests: XCTestCase {

    var viewModel: BookViewModel!
    var bookOlder: BookModel!
    var bookNewer: BookModel!
    var testKey: String!
    
    override func setUpWithError() throws {
        viewModel = BookViewModel()
        bookOlder = BookModel(artistName: "John Doe", id: "1", name: "Christmas for the Deputy", releaseDate: "2000-01-01", kind: "books", artistId: "11", artistUrl: "", contentAdvisoryRating: nil, artworkUrl100: "", imageData: nil, genres: [], url: "")
        bookNewer = BookModel(artistName: "Jane Doe", id: "2", name: "Christmas for the Farmer", releaseDate: "2023-01-01", kind: "books", artistId: "22", artistUrl: "", contentAdvisoryRating: "Explict", artworkUrl100: "", imageData: nil, genres: [], url: "")
        
        let newList: [BookModel] = [bookOlder, bookNewer]
        viewModel.bookList = newList
        viewModel.setFirstBookList(bookList: newList)
        
        testKey = "test-liked-ones"
    }

    override func tearDownWithError() throws {
        viewModel = nil
        bookOlder = nil
        bookNewer = nil
        if UserDefaults.standard.array(forKey: testKey) != nil {
            UserDefaults.standard.removeObject(forKey: testKey)
        }
        testKey = nil
    }
    
    func testDefaultStarForBook() {
        // Given
        var defaultStarImage = ""
        var defaultStarTintColor = ""
        
        // When
        defaultStarImage = viewModel.getStarButtonImage(bookId: bookOlder.id, keyId: testKey)
        
        defaultStarTintColor = viewModel.setStarButtonTintColor(bookId: bookOlder.id, keyId: testKey)
        
        // Then
        XCTAssertEqual(defaultStarImage, "star")
        XCTAssertEqual(defaultStarTintColor, ColorConstants.defaultStar)
    }
    
    func testFavoriteStarForBook() {
        // Given
        var favStarImage = ""
        var favStarTintColor = ""
        
        // When
        viewModel.starButtonTapped(bookId: bookOlder.id, keyId: testKey)
        favStarImage = viewModel.getStarButtonImage(bookId: bookOlder.id, keyId: testKey)
        
        favStarTintColor = viewModel.setStarButtonTintColor(bookId: bookOlder.id, keyId: testKey)
        
        // Then
        XCTAssertEqual(favStarImage, "star.fill")
        XCTAssertEqual(favStarTintColor, ColorConstants.favStar)
    }

}
