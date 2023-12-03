//
//  DetailViewController.swift
//  BookApp
//
//  Created by Berke Turanlıoğlu on 1.12.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var bookImage: UIImageView!
    @IBOutlet private weak var bookTitleLabel: UILabel!
    @IBOutlet private weak var bookDescriptionLabel: UILabel!
    var starButton = UIBarButtonItem()
    
    var viewModel: BookViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setViews()
    }
    
    func setNavigationBar() {
        guard let selectedBook = viewModel?.getSelectedBook() else {
            fatalError("No book is selected")
        }
        
        self.title = "Content Details"
        setStarButton(bookId: selectedBook.id)
    }
    
    func setStarButton(bookId: String) {
        if let starImage = self.viewModel?.getStarButtonImage(bookId: bookId, keyId: Constants.likedBooks) {
            starButton = UIBarButtonItem(image: UIImage(systemName: starImage), style: .plain, target: self, action: #selector(self.starButtonTapped))
        }
        self.navigationItem.rightBarButtonItem = starButton
    }
    
    func setViews() {
        guard let selectedBook = viewModel?.getSelectedBook() else {
            fatalError("No book is selected")
        }
        
        if let imageData = selectedBook.imageData {
            bookImage.isHidden = false
            bookImage.image = UIImage(data: imageData)
        } else {
            bookImage.isHidden = true
            imageActivityIndicator.isHidden = false
            imageActivityIndicator.startAnimating()
            
            viewModel?.getImageOfBook(url: selectedBook.artworkUrl100, handler: { data in
                DispatchQueue.main.async {
                    self.imageActivityIndicator.stopAnimating()
                    self.imageActivityIndicator.isHidden = true
                    self.bookImage.isHidden = false
                    self.bookImage.image = UIImage(data: data)
                }
            })
        }
        bookTitleLabel.text = selectedBook.name
        setDescriptionText(book: selectedBook)
    }
    
    func setDescriptionText(book: BookModel) {
        var finalDescriptionStr = ""
        finalDescriptionStr += "Author: \(book.artistName)\n"
        finalDescriptionStr += "Release Date: \(book.releaseDate)"
        bookDescriptionLabel.text = finalDescriptionStr
    }
    
    // MARK: - Actions
    @objc private func starButtonTapped() {
        guard let selectedBook = viewModel?.getSelectedBook() else {
            fatalError("No book is selected")
        }
        
        self.viewModel?.starButtonTapped(bookId: selectedBook.id, keyId: Constants.likedBooks)
        setStarButton(bookId: selectedBook.id)
    }
}
