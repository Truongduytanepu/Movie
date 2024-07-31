//
//  SelfieSearchVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 15/04/2024.
//

import UIKit
import PullToRefreshKit

enum SearchOrNoSearch {
    case search
    case noSearch
}

class SelfieSearchVC: BaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var noInternetView: UIView!
    @IBOutlet weak var noInternetImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var image = UIImage(named: "Search")
    private var searchOrNoSearch: SearchOrNoSearch = .noSearch
    private let footer = DefaultRefreshFooter()
    private var currentPageNoSearch = 1
    private var currentPageSearch = 1
    private var data: [Result]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieTopRateManager.shared.fetch(currentPageNoSearch, isLoadMore: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MovieTopRateManager.shared.fetch(1, isLoadMore: false)
        searchBar.text = nil
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideView()
    }
    
    override func binding() {
        MovieTopRateManager.shared.$topRateMovie
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.data = item
                self?.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        MovieSearchManager.shared.$searchMovie
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.data = item
                self?.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: NoSearchCVC.self)
        footer.setText("", mode: .refreshing)
        footer.setText("", mode: .pullToRefresh)
        footer.setText("", mode: .scrollAndTapToRefresh)
        footer.setText("", mode: .tapToRefresh)
        footer.tintColor = .white
        
        searchBar.delegate = self
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = (searchBar.frame.height + 5) / 3
        
        self.collectionView.configRefreshFooter(with: footer, container: self) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                switch self.searchOrNoSearch {
                case .search:
                    self.currentPageSearch += 1
                    if let searchText = self.searchBar.text, !searchText.isEmpty {
                        MovieSearchManager.shared.fetch(query: searchText, page: self.currentPageSearch, isLoadMore: true)
                    }
                case .noSearch:
                    self.currentPageNoSearch += 1
                    MovieTopRateManager.shared.fetch(self.currentPageNoSearch, isLoadMore: true)
                }
            }
        }
    }
    
    override func setColor() {
        searchBar.layer.borderColor = UIColor(rgb: 0x5E5F67).cgColor
        searchBar.tintColor = .white
        searchBar.barTintColor = UIColor(rgb: 0x323239)
        
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Type to search"
                                                                             ,attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x626472)])
        
        let maxSize = CGSize(width: 20, height: 20)
        let resizedImage = image!.resize(maxSize: maxSize)
        
        searchBar.setImage(resizedImage, for: .search, state: .normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .search)
    }
    
    func hideView() {
        self.noInternetView.isHidden = true
        self.noInternetImage.isHidden = true
        self.noDataImage.isHidden = true
    }
}

extension SelfieSearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch isNetworkConnected {
        case true:
            if data?.count == 0 {
                self.noDataImage.isHidden = false
            } else {
                self.noDataImage.isHidden = true
            }
            self.collectionView.isHidden = false
            return self.data?.count ?? 0
        case false:
            self.noDataImage.isHidden = true
            return 0
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: NoSearchCVC.self, indexPath: indexPath)
        let movie = data?[indexPath.item] ?? Result()
        cell.configTitle(movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = data?[indexPath.item]
        let vc = CameraVC()
        vc.movieSelected = movie
        push(to: vc, animated: true)
    }
}

extension SelfieSearchVC: UICollectionViewDelegate {
    
}

extension SelfieSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let a: CGFloat = 13
        let width = (collectionView.frame.width - a - 16 * 2) / 2
        return CGSize(width: width, height: collectionView.frame.height / 2.8)
    }
}

extension SelfieSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.network() { [weak self] isConnect in
            switch isConnect {
            case true:
                if let searchText = searchBar.text, !searchText.isEmpty {
                    MovieSearchManager.shared.fetch(query: searchText, page: 1, isLoadMore: false)
                    self?.searchOrNoSearch = .search
                } else {
                    MovieTopRateManager.shared.fetch(1, isLoadMore: false)
                    self?.searchOrNoSearch = .noSearch
                }
                self?.noInternetImage.isHidden = true
                self?.noInternetView.isHidden = true
                self?.collectionView.isHidden = false
                self?.noDataImage.isHidden = true
            case false:
                self?.noInternetImage.isHidden = false
                self?.noInternetView.isHidden = false
                self?.collectionView.isHidden = true
                self?.noDataImage.isHidden = true
            }
        }
        
        self.collectionView.isHidden = false
    }
}
