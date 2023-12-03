//
//  BookViewCell.swift
//  BookApp
//
//  Created by Berke Turanlıoğlu on 1.12.2023.
//

import UIKit

class BookViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: BookViewCell.self)
    
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var bookStarButton: UIButton!
    
    let viewModel = BookViewModel()
    var currentBook: BookModel?
    
    @IBAction func bookStarButtonTapped(_ sender: Any) {
        if let book = currentBook {
            self.viewModel.starButtonTapped(bookId: book.id, keyId: Constants.likedBooks)
            bookStarButton.tintColor = UIColor(named: self.viewModel.setStarButtonTintColor(bookId: book.id, keyId: Constants.likedBooks))
        }
    }
}
