//
//  SortAndSearchTests.swift
//  BookAppTests
//
//  Created by Berke Turanlıoğlu on 3.12.2023.
//

import XCTest
@testable import BookApp

final class SortAndSearchTests: XCTestCase {
    
    var viewModel: BookViewModel!
    var genreOne: GenreModel!
    var genreTwo: GenreModel!
    var bookOlder: BookModel!
    var bookNewer: BookModel!
    
    override func setUpWithError() throws {
        viewModel = BookViewModel()
        genreOne = GenreModel(genreId: "111", name: "Holiday", url: "")
        genreTwo = GenreModel(genreId: "222", name: "Romance", url: "")
        bookOlder = BookModel(artistName: "John Doe", id: "1", name: "Christmas for the Deputy", releaseDate: "2000-01-01", kind: "books", artistId: "11", artistUrl: "", contentAdvisoryRating: nil, artworkUrl100: "", imageData: nil, genres: [genreOne, genreTwo], url: "")
        bookNewer = BookModel(artistName: "Jane Doe", id: "2", name: "Christmas for the Farmer", releaseDate: "2023-01-01", kind: "books", artistId: "22", artistUrl: "", contentAdvisoryRating: "Explict", artworkUrl100: "", imageData: nil, genres: [genreTwo], url: "")
        
        let newList: [BookModel] = [bookOlder, bookNewer]
        viewModel.bookList = newList
        viewModel.setFirstBookList(bookList: newList)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        bookOlder = nil
        bookNewer = nil
        genreOne = nil
        genreTwo = nil
    }

    func testFirstBookListIfEqual() {
        // Given
        let vmFirstBookList = viewModel.getFirstBookList()
        
        // Then
        XCTAssertEqual(viewModel.bookList.count, vmFirstBookList.count)
    }
    
    func testSortWithSelectedAction() {
        // Given
        var isAllSelected: Bool = false
        var isLikedOnesSelected: Bool = false
        var isNewToOldSelected: Bool = false
        var isOldToNewSelected: Bool = false
        
        // When
        viewModel.sortWithSelectedAction(for: .all)
        isAllSelected = viewModel.bookList.count == viewModel.getFirstBookList().count
        
        viewModel.sortWithSelectedAction(for: .likedOnes)
        isLikedOnesSelected = viewModel.bookList.count == 0
        
        viewModel.sortWithSelectedAction(for: .newToOld)
        isNewToOldSelected = viewModel.bookList[0].id == bookNewer.id
        
        viewModel.sortWithSelectedAction(for: .oldToNew)
        isOldToNewSelected = viewModel.bookList[0].id == bookOlder.id
        
        // Then
        XCTAssertTrue(isAllSelected)
        XCTAssertTrue(isLikedOnesSelected)
        XCTAssertTrue(isNewToOldSelected)
        XCTAssertTrue(isOldToNewSelected)
    }
    
    func testSearchBookWithBookTitle() {
        // Given
        viewModel.setSearchOption(option: .bookTitle)
        var filteredList: [BookModel] = []
        var isWordDeputySearched: Bool = false
        var isWordChristmasSearched: Bool = false
        
        // When
        filteredList = viewModel.filterBookList(text: "Deputy")
        isWordDeputySearched = filteredList.count == 1 && filteredList[0].name.contains("Deputy")
        
        filteredList = viewModel.filterBookList(text: "Christmas")
        isWordChristmasSearched = filteredList.count == 2
        
        // Then
        XCTAssertTrue(isWordDeputySearched)
        XCTAssertTrue(isWordChristmasSearched)
    }
    
    func testSearchBookWithGenre() {
        // Given
        viewModel.setSearchOption(option: .genre)
        var filteredList: [BookModel] = []
        var isGenreHolidaySearched: Bool = false
        var isGenreRomanceSearched: Bool = false
        var isGenreExists: Bool = false
        
        // When
        filteredList = viewModel.filterBookList(text: "Holiday")
        for genre in filteredList[0].genres {
            if genre.name == "Holiday" {
                isGenreHolidaySearched = true
            }
        }
        
        filteredList = viewModel.filterBookList(text: "Romance")
        for genre in filteredList[0].genres {
            if genre.name == "Romance" {
                isGenreRomanceSearched = true
            }
        }
        
        // Then
        XCTAssertTrue(isGenreHolidaySearched)
        XCTAssertTrue(isGenreRomanceSearched)
    }
}
