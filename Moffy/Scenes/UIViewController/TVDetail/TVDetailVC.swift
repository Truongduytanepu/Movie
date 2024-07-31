//
//  TVDetailVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 06/04/2024.
//

import UIKit
import AdMobManager
import NVActivityIndicatorView
import SnapKit

enum TVDetailScreen: CaseIterable {
    case informationMovie
    case detailAndEpisodes
}

class TVDetailVC: BaseViewController {
    @IBOutlet weak var bannerAdView: BannerAdMobView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var detailOrEposidesReceiveDelegate: DetailOrEposides = .detail
    private var numberOfSeason: Int?
    private var bioHeight: CGFloat = 0
    var genreIDReceiveTVShowVC: String?
    private lazy var loadingView: NVActivityIndicatorView = {
        let loadingView = NVActivityIndicatorView(frame: .zero)
        loadingView.type = .ballPulse
        loadingView.padding = 30.0
        return loadingView
    }()
    
    override func addComponents() {
        bannerAdView.addSubview(loadingView)
    }
    
    override func setConstraints() {
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let movieDetailObject = RealmService.shared.fetch(ofType: MovieDetailObject.self)
        if movieDetailObject.contains(where: { $0.idMovie == Int(genreIDReceiveTVShowVC ?? "")}) {
            favoriteBtn.setImage(UIImage(named: "Favorite"), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: "UnFavotite"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TVDetailManager.shared.fetch(genreIDReceiveTVShowVC ?? "")
        EposidesManager.shared.fetch(genreIDReceiveTVShowVC ?? "", 1)
    }
    
    override func binding() {
        TVDetailManager.shared.$tvDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else {
                    return
                }
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        EposidesManager.shared.$eposides
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    override func setProperties() {
        if AdMobManager.shared.state == .allow {
            setAdsBanner()
        } else {
            bannerAdView.isHidden = true
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.registerNib(ofType: InformationTvCVC.self)
        collectionView.registerNib(ofType: DetailAndEpisodesCVC.self)
    }
    
    private func setAdsBanner() {
        bannerAdView.addSubview(loadingView)
        loadingView.color = .black
        bannerAdView.bringSubviewToFront(loadingView)
        loadingView.snp.makeConstraints { make in
          make.width.height.equalTo(20.0)
          make.center.equalToSuperview()
        }
        loadingView.startAnimating()
        if AdMobManager.shared.status(type: .onceUsed(.banner), name: "DetailMovie_Banner") == true {
            bannerAdView.load(name: "DetailMovie_Banner", rootViewController: self, didReceive: { [weak self] in
            guard let self = self else {
              return
            }
            self.loadingView.stopAnimating()
          }, didError: { [weak self] in
            guard let self = self else {
              return
            }
            self.loadingView.stopAnimating()
              bannerAdView.isHidden = true
          })
        } else {
            bannerAdView.isHidden = true
        }
      }
    
    private func addTVToMovieDetailObject(_ tv: MovieDetailModel, _ movieObject: MovieDetailObject) {
        if let existingMovie = RealmService.shared.getByIdMovie(ofType: MovieDetailObject.self, idMovie: tv.id ?? 0 ) {
            RealmService.shared.delete(existingMovie)
            favoriteBtn.setImage(UIImage(named: "UnFavotite"), for: .normal)
        } else {
            RealmService.shared.add(movieObject)
            favoriteBtn.setImage(UIImage(named: "Favorite"), for: .normal)
        }
    }
    
    @IBAction func favoriteTvBtnTapped(_ sender: Any) {
        if let tv = TVDetailManager.shared.tvDetail {
            let movieObject = MovieDetailObject(tv)
            addTVToMovieDetailObject(tv, movieObject)
            print(RealmService.shared.fetch(ofType: MovieDetailObject.self))
        }
    }
    
    @IBAction func backNavigationBtnTapped(_ sender: Any) {
        FavoriteMovieManager.shared.tabSelected = .tvShow
        pop(animated: true)
    }
}

extension TVDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return TVDetailScreen.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch TVDetailScreen.allCases[section] {
        case .informationMovie:
            return 1
        case .detailAndEpisodes:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch TVDetailScreen.allCases[indexPath.section] {
        case .informationMovie:
            let cell = collectionView.dequeueCell(ofType: InformationTvCVC.self, indexPath: indexPath)
            if let tv = TVDetailManager.shared.tvDetail {
                cell.configDataTV(tv)
                cell.delegate = self
            }
            return cell
        case .detailAndEpisodes:
            let cell = collectionView.dequeueCell(ofType: DetailAndEpisodesCVC.self, indexPath: indexPath)
            let dataEposides = EposidesManager.shared.eposides?.episodes
            if let tv = TVDetailManager.shared.tvDetail {
                cell.setUpCellDetail(tv)
                cell.setUpCellEposides(tv.seasons, dataEposides)
                cell.delegate = self
            }
            return cell
        }
    }
}

extension TVDetailVC: UICollectionViewDelegate {
    
}

extension TVDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch TVDetailScreen.allCases[indexPath.section] {
        case .informationMovie:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 1.5)
        case .detailAndEpisodes:
            switch detailOrEposidesReceiveDelegate {
            case .detail:
                return CGSize(width: collectionView.frame.width, height: totalHeightDetail())
            case .eposides:
                return CGSize(width: collectionView.frame.width, height: totalHeightEposides())
            }
        }
    }
}

extension TVDetailVC: DetailAndEpisodesCVCDelegate {
    func setBioHeight(_ height: CGFloat) {
        self.bioHeight = height
        self.collectionView.reloadData()
    }
    
    func showDetailOrEposides(_ detailOrEposides: DetailOrEposides) {
        self.detailOrEposidesReceiveDelegate = detailOrEposides
        self.collectionView.reloadData()
    }
    
    func showMoreSimilar() {
        if isNetworkConnected {
            let vc = SeeAllTvVC()
            vc.screenMovieAndSeeAll = .similar
            if let tv = TVDetailManager.shared.tvDetail {
                vc.tvDetail = tv
            }
            push(to: vc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
    
    func showTvDetailSimilar(for: SimilarTvCVC, at indexpath: IndexPath) {
        if isNetworkConnected {
            AdMobManager.shared.show(type: .interstitial,
                                     name: "AllLayout_Inter",
                                     rootViewController: self,
                                     didFail: nil,
                                     didHide: nil)
            let vc = TVDetailVC()
            if let tv = TVDetailManager.shared.tvDetail {
                let similar = tv.recommendations?.results?[indexpath.item]
                vc.genreIDReceiveTVShowVC = "\(similar?.id ?? 0)"
                push(to: vc, animated: true)
            }
            self.collectionView.reloadData()
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
    
    func showActorDetail(for cell: ActorTvCVC, at indexpath: IndexPath) {
        if isNetworkConnected {
            if let starring = TVDetailManager.shared.tvDetail {
                let actorIndexpath = starring.credits?.cast?[indexpath.item]
                let vc = ActorDetailVC()
                vc.actorID = actorIndexpath?.id
                push(to: vc, animated: true)
            }
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
    
    func showTrailerPlayVC(for cell: TrailerTvCVC, at indexpath: IndexPath) {
        if isNetworkConnected {
            var trailerIndex = indexpath.item
            if AdMobManager.shared.state == .allow {
                if indexpath.item > 1 {
                    trailerIndex -= 1
                }
                if let tv = TVDetailManager.shared.tvDetail {
                    let trailerID = tv.videos?.results?[trailerIndex].key
                    let vc = PlayTrailerVC()
                    vc.trailerID = trailerID
                    push(to: vc, animated: true)
                }
            } else {
                if let tv = TVDetailManager.shared.tvDetail {
                    let trailerID = tv.videos?.results?[trailerIndex].key
                    let vc = PlayTrailerVC()
                    vc.trailerID = trailerID
                    push(to: vc, animated: true)
                }
            }
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
    
    func showSeasonDetail(for cell: EpisodesCVC, at indexpath: IndexPath) {
        if isNetworkConnected {
            self.numberOfSeason = indexpath.item
            EposidesManager.shared.fetch(genreIDReceiveTVShowVC ?? "", (numberOfSeason ?? 0) + 1)
            collectionView.reloadData()
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
}

extension TVDetailVC: InformationTvCVCDelegate {
    func showTrailerPlayVC() {
        if isNetworkConnected {
            if let tv = TVDetailManager.shared.tvDetail {
                let trailerID = tv.videos?.results?.first?.key
                let vc = PlayTrailerVC()
                vc.trailerID = trailerID
                push(to: vc, animated: true)
            }
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
    
    func showPopUpAddTVToPlan() {
        let childVC = PopUpAddMovie()
        self.addSubViewController(childVC)
        if let tv = TVDetailManager.shared.tvDetail {
            childVC.movieReceiveMovieDetail = MovieDetailManager.shared.convertToMovieObjects(results: tv)
        }
    }
}

extension TVDetailVC {
    func totalHeightDetail() -> CGFloat {
        let tv = TVDetailManager.shared.tvDetail
        let heightCollectionView = UIScreen.main.bounds.height
        let height: CGFloat = (collectionView.frame.width / 2 - 13 + 32) * 1.36
        var minimumLineSpacing: CGFloat = 0
        var totalHeight: CGFloat = 0
        if tv?.overview != "" {
            totalHeight += bioHeight
        }
        if tv?.videos?.results.map({$0.map({$0.key ?? ""})})?.count != 0 {
            totalHeight += heightCollectionView / 7.28
        }
        if tv?.credits?.cast?.count != 0 {
            totalHeight += heightCollectionView / 7.28
        }
        let similarMovieCount = tv?.recommendations?.results?.count
        let numberOfRow = ceil(CGFloat( min(6, similarMovieCount ?? 0) / 2))
        if numberOfRow > 0 {
            minimumLineSpacing += CGFloat((numberOfRow - 1) * 10)
        }
        totalHeight += numberOfRow * height + minimumLineSpacing + 66
        return totalHeight
    }
    
    func totalHeightEposides() -> CGFloat {
        var totalHeight: CGFloat = collectionView.frame.height / 3
        let firstEposides = EposidesManager.shared.eposides?.episodes?.prefix(5)
        if let eposides = firstEposides {
            for episode in eposides {
                let episodeText = "\(episode.overview ?? "")"
                let width = collectionView.frame.width
                let height = episodeText.heightForView(font: AppFont.get(fontName: .manaropeMedium, size: 12), width: width - 32)
                totalHeight += height + UIScreen.main.bounds.height / 4
            }
        }
        return totalHeight
    }
}
