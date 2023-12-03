//
//  BookModel.swift
//  BookApp
//
//  Created by Berke Turanlıoğlu on 1.12.2023.
//

import Foundation

struct BookModel: Codable {
    let artistName: String
    let id: String
    let name: String
    let releaseDate: String
    let kind: String
    let artistId: String
    let artistUrl: String
    let contentAdvisoryRating: String?
    let artworkUrl100: String
    var imageData: Data?
    let genres: [GenreModel]
    let url: String
}

struct GenreModel: Codable {
    let genreId: String
    let name: String
    let url: String
}
