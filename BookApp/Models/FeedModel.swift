//
//  FeedModel.swift
//  BookApp
//
//  Created by Berke Turanlıoğlu on 1.12.2023.
//

import Foundation

struct FeedModel: Decodable {
    let title: String
    let id: String
    let author: AuthorModel
    let links: [LinkModel]
    let copyright: String
    let country: String
    let icon: String
    let updated: String
    let results: [BookModel]
}

struct AuthorModel: Decodable {
    let name: String
    let url: String
}

struct LinkModel: Decodable {
    let `self`: String
}

struct MainModel: Decodable {
    let feed: FeedModel
}
