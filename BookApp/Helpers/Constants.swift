//
//  Constants.swift
//  BookApp
//
//  Created by Berke Turanlıoğlu on 1.12.2023.
//

import UIKit

struct Constants {
    
    // MARK: - UserDefaults Keys
    static let likedBooks = "liked-books"
    
    // MARK: - Storyboard
    static let mainStoryBoard = "Main"
    static let homeViewControllerID = "HomeViewController"
    static let searchViewControllerID = "SearchViewController"
    static let detailViewControllerID = "DetailViewController"
}

struct UrlConstants {
    static let mainUrl = "https://rss.applemarketingtools.com/api/v2/us/books/top-free/100/books.json"
}

struct ColorConstants {
    static let defaultStar = "DefaultStar"
    static let favStar = "FavStar"
}
