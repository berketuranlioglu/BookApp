//
//  BookViewModel.swift
//  BookApp
//
//  Created by Berke Turanlıoğlu on 1.12.2023.
//

import Foundation
import UIKit

enum SortOptions {
    case all, newToOld, oldToNew, likedOnes
}

enum SearchOptions {
    case bookTitle, genre
}

class BookViewModel {
    
    var bookList: [BookModel] = []
    private var firstBookList: [BookModel] = []
    private var selectedBook: BookModel?
    private var searchOption: SearchOptions = .bookTitle
    
    func loadHomeView(loadedSuccessfully: @escaping (() -> Void)) {
        BookManager.shared.performRequest(urlString: UrlConstants.mainUrl, handler: { data in
            if let safeData = data, let bookList = self.decodeJSON(bookData: safeData) {
                self.bookList = bookList
                self.firstBookList = bookList
                loadedSuccessfully()
            }
        })
    }
    
    func sortWithSelectedAction(for selectedOption: SortOptions) {
        self.bookList = self.firstBookList
        switch selectedOption {
        case .newToOld:
            self.bookList.sort { $0.releaseDate > $1.releaseDate }
        case .oldToNew:
            self.bookList.sort { $0.releaseDate < $1.releaseDate }
        case .likedOnes:
            let favBooks = UserDefaults.standard.array(forKey: Constants.likedBooks) as? [String] ?? []
            self.bookList = self.bookList.filter { favBooks.contains($0.id) }
        default:
            self.bookList = self.firstBookList
        }
    }
    
    func setImageDataForBook(index: Int, data: Data) {
        bookList[index].imageData = data
        firstBookList[index].imageData = data
    }
}

// MARK: - Cell customizations
extension BookViewModel {
    func isBookFavorite(bookId: String, keyId: String) -> Bool {
        if let favBooks = UserDefaults.standard.array(forKey: keyId) as? [String] {
            if favBooks.contains(where: { $0 == bookId }) {
                return true
            }
        }
        return false
    }
    
    func setStarButtonTintColor(bookId: String, keyId: String) -> String {
        let isFav = isBookFavorite(bookId: bookId, keyId: keyId)
        return isFav ? ColorConstants.favStar : ColorConstants.defaultStar
    }
    
    func starButtonTapped(bookId: String?, keyId: String) {
        if let id = bookId {
            var favBooks = UserDefaults.standard.array(forKey: keyId) as? [String] ?? []
            if isBookFavorite(bookId: id, keyId: Constants.likedBooks) {
                favBooks.removeAll(where: { $0 == id })
                UserDefaults.standard.set(favBooks, forKey: keyId)
                print("Removed from fav books")
            } else {
                favBooks.append(id)
                UserDefaults.standard.set(favBooks, forKey: keyId)
                print("Added to fav books")
            }
        }
    }
}

// MARK: - Search View
extension BookViewModel {
    func setFirstBookList(bookList: [BookModel]) {
        firstBookList = bookList
    }
    
    func getFirstBookList() -> [BookModel] {
        return firstBookList
    }
    
    func setSearchOption(option: SearchOptions) {
        searchOption = option
    }
    
    func filterBookList(text: String) -> [BookModel] {
        if searchOption == .bookTitle {
            return bookList.filter { $0.name.lowercased().contains(text.lowercased()) }
        } else {
            return bookList.filter { $0.genres.contains(where: { $0.name.lowercased().contains(text.lowercased()) }) }
        }
    }
    
    func setSearchedBook(bookId: String) {
        let searchedBookIndex = bookList.firstIndex(where: { $0.id == bookId })!
        setSelectedBook(index: searchedBookIndex)
    }
}

// MARK: - Detail View
extension BookViewModel {
    func setSelectedBook(index: Int) {
        selectedBook = bookList[index]
    }
    
    func getSelectedBook() -> BookModel? {
        return selectedBook
    }
    
    func getStarButtonImage(bookId: String, keyId: String) -> String {
        return isBookFavorite(bookId: bookId, keyId: keyId) ? "star.fill" : "star"
    }
    
    func getImageOfBook(url: String, handler: @escaping ((Data) -> Void)) {
        BookManager.shared.performRequest(urlString: url, handler: { data in
            if let safeData = data {
                handler(safeData)
            }
        })
    }
}

// MARK: - JSON handlers
extension BookViewModel {
    func decodeJSON(bookData: Data) -> [BookModel]? {
        do {
            let decodedData = try JSONDecoder().decode(MainModel.self, from: bookData)
            return decodedData.feed.results
        } catch {
            print("JSON Decoding error")
            return nil
        }
    }
}
