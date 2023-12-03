//
//  SearchViewController.swift
//  BookApp
//
//  Created by Berke Turanlıoğlu on 1.12.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: BookViewModel?
    var searchedBookList: [BookModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        setNavigationBar()
        setViews()
        viewModel?.setSearchOption(option: .bookTitle)
        searchedBookList = viewModel?.getFirstBookList() ?? []
    }
    
    func setNavigationBar() {
        self.title = "Search"
        let backButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.cancelButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setViews() {
        setCategoryMenu()
    }
    
    func setCategoryMenu() {
        let bookTitleItem = UIAction(title: "Book Title", image: nil) { _ in
            self.viewModel?.setSearchOption(option: .bookTitle)
            self.categoryButton.setTitle("Book Title", for: .normal)
        }
        let genreItem = UIAction(title: "Genre", image: nil) { _ in
            self.viewModel?.setSearchOption(option: .genre)
            self.categoryButton.setTitle("Genre", for: .normal)
        }
        let menu = UIMenu(title: "Search Option", options: .displayInline, children: [bookTitleItem, genreItem])
        categoryButton.menu = menu
        categoryButton.showsMenuAsPrimaryAction = true
        categoryButton.setTitle("Book Title", for: .normal)
    }
    
    // MARK: - Actions
    @objc private func cancelButtonPressed() {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        searchedBookList = viewModel?.getFirstBookList() ?? []
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchedBookList = viewModel?.getFirstBookList() ?? []
        } else {
            searchedBookList = viewModel?.filterBookList(text: searchText) ?? []
        }
        tableView.reloadData()
    }
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedBookList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookSearchViewCell.reuseIdentifier, for: indexPath) as? BookSearchViewCell else {
            fatalError("No search cell can be constructed.")
        }
        
        let currentBook = searchedBookList[indexPath.row]
        cell.bookTitleLabel.text = currentBook.name
        cell.bookAuthorLabel.text = currentBook.artistName
        cell.bookDateLabel.text = currentBook.releaseDate
        
        cell.bookImage.isHidden = true
        cell.imageActivityIndicator.isHidden = false
        cell.imageActivityIndicator.startAnimating()
        
        viewModel?.getImageOfBook(url: currentBook.artworkUrl100, handler: { data in
            DispatchQueue.main.async {
                cell.imageActivityIndicator.stopAnimating()
                cell.imageActivityIndicator.isHidden = true
                cell.bookImage.isHidden = false
                cell.bookImage.image = UIImage(data: data)
                self.viewModel?.setImageDataForBook(index: indexPath.row, data: data)
            }
        })
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: Constants.mainStoryBoard, bundle: .main)
        if let vc = sb.instantiateViewController(withIdentifier: Constants.detailViewControllerID) as? DetailViewController {
            let selectedBookId = searchedBookList[indexPath.row].id
            self.viewModel?.setSearchedBook(bookId: selectedBookId)
            vc.viewModel = self.viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
