//
//  FavoriteVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 15/04/2024.
//

import UIKit
import AdMobManager

enum TabSelectedType {
    case movie
    case tvShow
    case actor
}

class FavoriteVC: BaseViewController {
    @IBOutlet weak var naviteAdView: CustomNativeAdView!
    @IBOutlet weak var actorBtn: UIButton!
    @IBOutlet weak var tvShowBtn: UIButton!
    @IBOutlet weak var collectionViewMovie: UICollectionView!
    @IBOutlet weak var collectionViewTV: UICollectionView!
    @IBOutlet weak var movieBtn: UIButton!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var imageNoInternet: UIImageView!
    @IBOutlet weak var nodataLbl: UILabel!
    @IBOutlet weak var collectionViewActor: UICollectionView!
    
    private var arrMovieFavorite: [MovieDetailObject]? {
        didSet {
            collectionViewMovie.reloadData()
        }
    }
    private var arrActorFavorite: [ActorFavoriteObject]? {
        didSet {
            collectionViewActor.reloadData()
        }
    }
    private var arrTVFavorite: [MovieDetailObject]? {
        didSet {
            collectionViewTV.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDataActorFavorite()
        self.fetchDataMovieFavorite()
        self.fetchDataTVFavorite()
        self.switchTab(to: FavoriteMovieManager.shared.tabSelected ?? .movie)
        self.setTitleTab(for: FavoriteMovieManager.shared.tabSelected ?? .movie)
    }
    
    override func setProperties() {
        collectionViewMovie.delegate = self
        collectionViewMovie.dataSource = self
        collectionViewActor.delegate = self
        collectionViewActor.dataSource = self
        collectionViewTV.dataSource = self
        collectionViewTV.delegate = self
        collectionViewActor.registerNib(ofType: FavoriteActorCVC.self)
        collectionViewMovie.registerNib(ofType: FavoriteMovieCVC.self)
        collectionViewTV.registerNib(ofType: FavoriteTvCVC.self)
        if AdMobManager.shared.state == .allow {
            addAds(name: "SeeAll_Native")
        }
    }
    
    private func switchTab(to tab: TabSelectedType) {
        actorBtn.setBackgroundImage(tab == .actor ? UIImage(named: "BGButtonPhoto") : nil, for: .normal)
        tvShowBtn.setBackgroundImage(tab == .tvShow ? UIImage(named: "BGButtonPhoto") : nil, for: .normal)
        movieBtn.setBackgroundImage(tab == .movie ? UIImage(named: "BGButtonPhoto") : nil, for: .normal)
        
        switch tab {
        case .actor:
            collectionViewTV.isHidden = true
            collectionViewMovie.isHidden = true
            collectionViewActor.isHidden = false
            viewNoData.isHidden = true
            imageNoInternet.isHidden = true
            noDataActor()
        case .movie:
            collectionViewMovie.isHidden = false
            collectionViewActor.isHidden = true
            collectionViewTV.isHidden = true
            viewNoData.isHidden = true
            imageNoInternet.isHidden = true
            noDataMovie()
        case .tvShow:
            collectionViewMovie.isHidden = true
            collectionViewActor.isHidden = true
            collectionViewTV.isHidden = false
            viewNoData.isHidden = true
            imageNoInternet.isHidden = true
            noDataTV()
        }
    }
    
    private func hiddenView() {
        collectionViewActor.isHidden = true
        collectionViewTV.isHidden = true
        viewNoData.isHidden = true
        imageNoInternet.isHidden = true
        noDataMovie()
    }
    
    private func noDataActor() {
        if arrActorFavorite?.count == 0 {
            collectionViewActor.isHidden = true
            viewNoData.isHidden = false
            nodataLbl.text = "You don't have any actor favorite yet"
            imageNoInternet.isHidden = false
        }
        
        if AdMobManager.shared.state == .allow {
            if arrActorFavorite?.count ?? 0 >= 2 {
                naviteAdView.isHidden = false
            } else {
                naviteAdView.isHidden = true
            }
        } else {
            naviteAdView.isHidden = true
        }
    }
    
    private func noDataMovie() {
        if arrMovieFavorite?.count == 0 {
            collectionViewMovie.isHidden = true
            viewNoData.isHidden = false
            nodataLbl.text = "You don't have any movie favorite yet"
            imageNoInternet.isHidden = false
        }
        
        if AdMobManager.shared.state == .allow {
            if arrMovieFavorite?.count ?? 0 >= 2 {
                naviteAdView.isHidden = false
            } else {
                naviteAdView.isHidden = true
            }
        } else {
            naviteAdView.isHidden = true
        }
    }
    
    private func noDataTV() {
        if arrTVFavorite?.count == 0 {
            collectionViewTV.isHidden = true
            viewNoData.isHidden = false
            nodataLbl.text = "You don't have any tvshow favorite yet"
            imageNoInternet.isHidden = false
        }
        
        if AdMobManager.shared.state == .allow {
            if arrTVFavorite?.count ?? 0 >= 2 {
                naviteAdView.isHidden = false
            } else {
                naviteAdView.isHidden = true
            }
        } else {
            naviteAdView.isHidden = true
        }
    }
    
    private func setTitleTab(for tab: TabSelectedType) {
        switch tab {
        case .movie:
            movieBtn.titleLabel?.font = AppFont.get(fontName: .quicksandSemiBold, size: 20)
            tvShowBtn.titleLabel?.font = AppFont.get(fontName: .quicksandRegular, size: 16)
            actorBtn.titleLabel?.font = AppFont.get(fontName: .quicksandRegular, size: 16)
        case .tvShow:
            tvShowBtn.titleLabel?.font = AppFont.get(fontName: .quicksandSemiBold, size: 20)
            movieBtn.titleLabel?.font = AppFont.get(fontName: .quicksandRegular, size: 16)
            actorBtn.titleLabel?.font = AppFont.get(fontName: .quicksandRegular, size: 16)
        case .actor:
            actorBtn.titleLabel?.font = AppFont.get(fontName: .quicksandSemiBold, size: 20)
            tvShowBtn.titleLabel?.font = AppFont.get(fontName: .quicksandRegular, size: 16)
            movieBtn.titleLabel?.font = AppFont.get(fontName: .quicksandRegular, size: 16)
        }
    }
    
    private func addAds(name: String) {
        if AdMobManager.shared.status(type: .onceUsed(.native), name: name) == true {
            naviteAdView.setupAds(name: name, didError: { [weak self] in
            guard let self else { return }
                naviteAdView.isHidden = true
          })
        } else {
            naviteAdView.isHidden = true
        }
      }
    
    @IBAction func actorBtnTapped(_ sender: Any) {
        switchTab(to: .actor)
        setTitleTab(for: .actor)
        collectionViewActor.reloadData()
    }
    
    @IBAction func tvShowBtnTapped(_ sender: Any) {
        switchTab(to: .tvShow)
        setTitleTab(for: .tvShow)
        collectionViewTV.reloadData()
    }
    
    @IBAction func movieBtnTapped(_ sender: Any) {
        switchTab(to: .movie)
        setTitleTab(for: .movie)
        collectionViewMovie.reloadData()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        FavoriteMovieManager.shared.tabSelected = .movie
        pop(animated: true)
    }
}

extension FavoriteVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewMovie:
            return arrMovieFavorite?.count ?? 0
        case collectionViewTV:
            return arrTVFavorite?.count ?? 0
        case collectionViewActor:
            return arrActorFavorite?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionViewMovie:
            let cell = collectionViewMovie.dequeueCell(ofType: FavoriteMovieCVC.self, indexPath: indexPath)
            let movie = arrMovieFavorite?[indexPath.item] ?? MovieDetailObject()
            cell.configTitle(movie)
            cell.indexPathReceiveFavoriteVC = indexPath
            cell.delegate = self
            return cell
        case collectionViewTV:
            let cell = collectionViewTV.dequeueCell(ofType: FavoriteTvCVC.self, indexPath: indexPath)
            let movie = arrTVFavorite?[indexPath.item] ?? MovieDetailObject()
            cell.configTitle(movie)
            cell.indexPathReceiveFavoriteVC = indexPath
            cell.delegate = self
            return cell
        case collectionViewActor:
            let cell = collectionViewActor.dequeueCell(ofType: FavoriteActorCVC.self, indexPath: indexPath)
            let actor = arrActorFavorite?[indexPath.item] ?? ActorFavoriteObject()
            cell.configDataActorFavorite(actor)
            cell.indexPathReceiveFavoriteVC = indexPath
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isNetworkConnected {
            AdMobManager.shared.show(type: .interstitial,
                                     name: "AllLayout_Inter",
                                     rootViewController: self,
                                     didFail: nil,
                                     didHide: nil)
            switch collectionView {
            case collectionViewMovie:
                let movie = arrMovieFavorite?[indexPath.item]
                let vc = MovieDetailVC()
                vc.movieReceiveSeeAllVC = movie?.idMovie
                push(to: vc, animated: true)
            case collectionViewTV:
                let tv = arrTVFavorite?[indexPath.item]
                let vc = TVDetailVC()
                vc.genreIDReceiveTVShowVC = "\(tv?.idMovie ?? 0)"
                push(to: vc, animated: true)
            case collectionViewActor:
                let actorItem = arrActorFavorite?[indexPath.item]
                let vc = ActorDetailVC()
                vc.actorID = actorItem?.id
                push(to: vc, animated: true)
            default:
                break
            }
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
}

extension FavoriteVC: UICollectionViewDelegate {
    
}

extension FavoriteVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collectionViewMovie:
            let a: CGFloat = 13
            let width = (collectionView.frame.width - a - 16 * 2) / 2
            return CGSize(width: width, height: width * 1.36)
        case collectionViewTV:
            let a: CGFloat = 13
            let width = (collectionView.frame.width - a - 16 * 2) / 2
            return CGSize(width: width, height: width * 1.36)
        case collectionViewActor:
            return CGSize(width: collectionView.frame.width - 32, height: 89)
        default:
            return CGSize(width: collectionView.frame.width - 32, height: 89)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension FavoriteVC: FavoriteMovieCVCDelegate {
    func removeMovieFavorite(at indexPath: IndexPath?) {
        guard let movieToRemove = arrMovieFavorite?[indexPath?.item ?? 0] else {
            return
        }
        
        RealmService.shared.delete(movieToRemove)
        arrMovieFavorite?.remove(at: indexPath?.item ?? 0)
        noDataMovie()
        collectionViewMovie.reloadData()
    }
}

extension FavoriteVC: FavoriteActorCVCDelegate {
    func removeFavorite(at indexPath: IndexPath?) {
        guard let actor = arrActorFavorite?[indexPath?.item ?? 0] else {
            return
        }
        
        RealmService.shared.delete(actor)
        arrActorFavorite?.remove(at: indexPath?.item ?? 0)
        noDataActor()
        collectionViewActor.reloadData()
    }
}

extension FavoriteVC: FavoriteTvCVCDelegate {
    func removeTVFavorite(at indexPath: IndexPath?) {
        guard let tvToRemove = arrTVFavorite?[indexPath?.item ?? 0] else {
            return
        }
        
        RealmService.shared.delete(tvToRemove)
        arrTVFavorite?.remove(at: indexPath?.item ?? 0)
        noDataTV()
        collectionViewTV.reloadData()
    }
}


extension FavoriteVC {
    func fetchDataMovieFavorite() {
        arrMovieFavorite = RealmService.shared.fetch(ofType: MovieDetailObject.self).filter { $0.name == nil }
    }
    
    func fetchDataTVFavorite() {
        arrTVFavorite = RealmService.shared.fetch(ofType: MovieDetailObject.self).filter { $0.title ==  nil }
    }
    
    func fetchDataActorFavorite() {
        arrActorFavorite = RealmService.shared.fetch(ofType: ActorFavoriteObject.self)
    }
}
