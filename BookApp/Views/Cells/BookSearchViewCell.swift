//
//  BookSearchViewCell.swift
//  BookApp
//
//  Created by Berke Turanlıoğlu on 2.12.2023.
//

import UIKit

class BookSearchViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: BookSearchViewCell.self)
    
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookInfoStackView: UIStackView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
