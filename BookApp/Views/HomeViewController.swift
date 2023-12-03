//
//  HomeViewController.swift
//  BookApp
//
//  Created by Berke Turanlıoğlu on 1.12.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = BookViewModel()
    let collectionViewSpacing: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationItem.title = "Contents"
        viewModel.loadHomeView(loadedSuccessfully: {
            self.setNavigationBar()
            self.setCollectionView()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    // MARK: - Setting Views
    func setNavigationBar() {
        DispatchQueue.main.async {
            let sortButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(self.sortButtonTapped))
            let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(self.searchButtonTapped))
            self.navigationItem.rightBarButtonItems = [searchButton, sortButton]
        }
    }
    
    func setCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Actions
    @objc func sortButtonTapped() {
        showSortMenu()
    }
    @objc func searchButtonTapped() {
        let sb = UIStoryboard(name: Constants.mainStoryBoard, bundle: .main)
        if let vc = sb.instantiateViewController(withIdentifier: Constants.searchViewControllerID) as? SearchViewController {
            vc.viewModel = self.viewModel
            vc.navigationItem.setHidesBackButton(true, animated: false)
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    func showSortMenu() {
        let alert = UIAlertController(title: "Sort", message: "Choose a method to sort.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "All", style: .default , handler:{ _ in
            self.viewModel.sortWithSelectedAction(for: .all)
            self.collectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "New to Old", style: .default , handler:{ _ in
            self.viewModel.sortWithSelectedAction(for: .newToOld)
            self.collectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Old to New", style: .default , handler:{ _ in
            self.viewModel.sortWithSelectedAction(for: .oldToNew)
            self.collectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Liked Ones", style: .default, handler:{ _ in
            self.viewModel.sortWithSelectedAction(for: .likedOnes)
            self.collectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Collection View Delegates
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.bookList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 2.0
        let spacing: CGFloat = collectionViewSpacing
        let itemSpace = (collectionView.bounds.width - spacing) / columns
        let itemWidth = itemSpace - spacing
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookViewCell.reuseIdentifier, for: indexPath) as? BookViewCell else {
            fatalError("No cell found or created as BookViewCell.")
        }
        
        let currentBook = self.viewModel.bookList[indexPath.row]
        cell.currentBook = currentBook
        cell.bookLabel.text = currentBook.name
        cell.bookStarButton.tintColor = UIColor(named: self.viewModel.setStarButtonTintColor(bookId: currentBook.id, keyId: Constants.likedBooks))
        
        cell.bookImage.isHidden = true
        cell.imageActivityIndicator.isHidden = false
        cell.imageActivityIndicator.startAnimating()
        
        viewModel.getImageOfBook(url: currentBook.artworkUrl100, handler: { data in
            DispatchQueue.main.async {
                cell.imageActivityIndicator.stopAnimating()
                cell.imageActivityIndicator.isHidden = true
                cell.bookImage.isHidden = false
                cell.bookImage.image = UIImage(data: data)
                self.viewModel.setImageDataForBook(index: indexPath.row, data: data)
            }
        })
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: Constants.mainStoryBoard, bundle: .main)
        if let vc = sb.instantiateViewController(withIdentifier: Constants.detailViewControllerID) as? DetailViewController {
            self.viewModel.setSelectedBook(index: indexPath.row)
            vc.viewModel = self.viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
