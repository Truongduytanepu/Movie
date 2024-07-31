//
//  SearchVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/02/2024.
//

import UIKit
import IQKeyboardManagerSwift
import PullToRefreshKit
import AdMobManager
import NVActivityIndicatorView
import SnapKit

class SearchVC: BaseViewController {
    @IBOutlet weak var bannerAdMobView: BannerAdMobView!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var noInternerImageBot: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewRecommendHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRecommend: UIView!
    @IBOutlet weak var noInternet: UIView!
    @IBOutlet weak var noDataImage: UIImageView!
    
    private var viewEntiry: SearchEntity = SearchEntity()
    private var currentSearch: SearchEntity.TypeView = .noSearch
    private var image = UIImage(named: "Search")
    private var checkCount = 0
    private var movieCount = false
    private var tvCount = false
    private var actorCount = false
    private var hasData: Bool?
    private var totalData = 0
    private lazy var loadingView: NVActivityIndicatorView = {
        let loadingView = NVActivityIndicatorView(frame: .zero)
        loadingView.type = .ballPulse
        loadingView.padding = 30.0
        return loadingView
    }()
    
    override func addComponents() {
        bannerAdMobView.addSubview(loadingView)
    }
    
    override func setConstraints() {
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerAdMobView.isHidden = true
        MovieTopRateManager.shared.fetch(1, isLoadMore: false)
    }
    
    override func binding() {
        MovieTopRateManager.shared.$topRateMovie
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        MovieSearchManager.shared.$searchMovie
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.hasData = !(MovieSearchManager.shared.searchMovie.isEmpty)
                self?.totalData += item.count
                self?.viewEntiry = SearchEntity(movieData: MovieSearchManager.shared.searchMovie,
                                                tvShowData: TvSearchManager.shared.searchTV,
                                                actorData: ActorSearchManager.shared.actorSearch)
                self?.collectionView.reloadData()
            }.store(in: &subscriptions)
        TvSearchManager.shared.$searchTV
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.hasData = !(TvSearchManager.shared.searchTV.isEmpty)
                self?.totalData += item.count
                self?.viewEntiry = SearchEntity(movieData: MovieSearchManager.shared.searchMovie,
                                                tvShowData: TvSearchManager.shared.searchTV,
                                                actorData: ActorSearchManager.shared.actorSearch)
                self?.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        ActorSearchManager.shared.$actorSearch
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                
                self?.hasData = !(ActorSearchManager.shared.actorSearch.isEmpty)
                self?.totalData += item.count
                self?.showAdsBanner()
                self?.viewEntiry = SearchEntity(movieData: MovieSearchManager.shared.searchMovie,
                                                tvShowData: TvSearchManager.shared.searchTV,
                                                actorData: ActorSearchManager.shared.actorSearch)
                self?.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    override func setProperties() {
        if AdMobManager.shared.state == .allow {
            setAdsBanner()
        } else {
            bannerAdMobView.isHidden = true
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: NoSearchCVC.self)
        collectionView.registerNib(ofType: SearchSectionCVC.self)
        
        searchBar.delegate = self
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = (searchBar.frame.height + 5) / 3
        
        noDataImage.isHidden = true
        noInternet.isHidden = true
        noInternerImageBot.isHidden = true
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
    
    private func setAdsBanner() {
        bannerAdMobView.addSubview(loadingView)
        loadingView.color = .black
        bannerAdMobView.bringSubviewToFront(loadingView)
        loadingView.snp.makeConstraints { make in
            make.width.height.equalTo(20.0)
            make.center.equalToSuperview()
        }
        loadingView.startAnimating()
        if AdMobManager.shared.status(type: .onceUsed(.banner), name: "Search_Banner") == true {
            bannerAdMobView.load(name: "Search_Banner", rootViewController: self, didReceive: { [weak self] in
                guard let self = self else {
                    return
                }
                self.loadingView.stopAnimating()
            }, didError: { [weak self] in
                guard let self = self else {
                    return
                }
                self.loadingView.stopAnimating()
                bannerAdMobView.isHidden = true
            })
        } else {
            bannerAdMobView.isHidden = true
        }
    }
    
    private func showAdsBanner() {
        if AdMobManager.shared.state == .allow {
            if self.totalData >= 2 {
                self.bannerAdMobView.isHidden = false
            } else {
                self.bannerAdMobView.isHidden = true
            }
            self.totalData = 0
        } else {
            bannerAdMobView.isHidden = true
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        pop(animated: true)
    }
}

extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentSearch {
        case .search:
            if let hasData = self.hasData, hasData {
                noDataImage.isHidden = true
                collectionView.isHidden = false
                return viewEntiry.sections.count
            } else {
                noDataImage.isHidden = false
                collectionView.isHidden = true
                return 0
            }
        case .noSearch:
            return MovieTopRateManager.shared.topRateMovie.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch currentSearch {
        case .search:
            let cell = collectionView.dequeueCell(ofType: SearchSectionCVC.self, indexPath: indexPath)
            switch viewEntiry.sections[indexPath.item] {
            case .movie(data: let data, titleSection: let titleSection):
                cell.setupCell(dataMovie: data, dataTvShow: nil, dataActor: nil, title: titleSection)
                cell.delegate = self
            case .tvShow(data: let data, titleSection: let titleSection):
                cell.setupCell(dataMovie: nil, dataTvShow: data, dataActor: nil, title: titleSection)
                cell.delegate = self
            case .actor(data: let data, titleSection: let titleSection):
                cell.setupCell(dataMovie: nil, dataTvShow: nil, dataActor: data, title: titleSection)
                cell.delegate = self
            }
            return cell
        case .noSearch:
            let cell = collectionView.dequeueCell(ofType: NoSearchCVC.self, indexPath: indexPath)
            let movie = MovieTopRateManager.shared.topRateMovie[indexPath.row]
            cell.configTitle(movie)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentSearch {
        case .search:
            break
        case .noSearch:
            AdMobManager.shared.show(type: .interstitial,
                                     name: "AllLayout_Inter",
                                     rootViewController: self,
                                     didFail: nil,
                                     didHide: nil)
            let movie = MovieTopRateManager.shared.topRateMovie[indexPath.row]
            let vc = MovieDetailVC()
            vc.movieReceiveSeeAllVC = movie.id
            push(to: vc, animated: true)
        }
    }
}

extension SearchVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch currentSearch {
        case .search:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        case .noSearch:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let a: CGFloat = 13
        let width = (collectionView.frame.width - a - 16 * 2) / 2
        if currentSearch == .search {
            return CGSize(width: collectionView.frame.width, height: 248)
        } else {
            return CGSize(width: width, height: collectionView.frame.height / 2.8)
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        currentSearch = .search
        
        self.network() { [weak self] isConnect in
            switch isConnect {
            case true:
                MovieSearchManager.shared.fetch(query: searchBar.text ?? "", page: 1, isLoadMore: false)
                TvSearchManager.shared.fetch(query: searchBar.text ?? "", page: 1, isLoadMore: false)
                ActorSearchManager.shared.fetch(query: searchBar.text ?? "", page: 1, isLoadMore: false)
                self?.noInternerImageBot.isHidden = true
                self?.noInternet.isHidden = true
            case false:
                self?.noInternerImageBot.isHidden = false
                self?.noInternet.isHidden = false
                self?.collectionView.isHidden = true
                self?.viewRecommend.isHidden = true
                self?.noDataImage.isHidden = true
                
            }
        }
        
        self.viewRecommend.isHidden = true
        self.collectionView.isHidden = false
        self.noDataImage.isHidden = true
        self.viewRecommendHeight.constant = 0
        
        if ((searchBar.text?.isEmpty) ?? true) {
            self.currentSearch = .noSearch
            self.viewRecommend.isHidden = false
            self.noDataImage.isHidden = true
            self.collectionView.isHidden = false
            self.viewRecommendHeight.constant = 29
            self.bannerAdMobView.isHidden = true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}

extension SearchVC: SearchSectionCVCDelegate {
    func showActorDetail(_ result: Result) {
        let vc = ActorDetailVC()
        vc.actorID = result.id
        push(to: vc, animated: true)
    }
    
    func showTVDetail(_ result: Result) {
        AdMobManager.shared.show(type: .interstitial,
                                 name: "AllLayout_Inter",
                                 rootViewController: self,
                                 didFail: nil,
                                 didHide: nil)
        let vc = TVDetailVC()
        vc.genreIDReceiveTVShowVC = "\(result.id ?? 0)"
        push(to: vc, animated: true)
    }
    
    func showMovieDetail(_ result: Result) {
        AdMobManager.shared.show(type: .interstitial,
                                 name: "AllLayout_Inter",
                                 rootViewController: self,
                                 didFail: nil,
                                 didHide: nil)
        let vc = MovieDetailVC()
        vc.movieReceiveSeeAllVC = result.id
        push(to: vc, animated: true)
    }
}
