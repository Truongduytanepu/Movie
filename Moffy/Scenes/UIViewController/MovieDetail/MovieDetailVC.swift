//
//  MovieDetailVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 01/04/2024.
//

enum MovieDetail: CaseIterable {
    case informationMovie
    case description
    case trailer
    case starring
    case similarMoive
}

import UIKit
import AdMobManager
import NVActivityIndicatorView
import SnapKit

class MovieDetailVC: BaseViewController {
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var bannerAdView: BannerAdMobView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var heightBio: CGFloat = 70
    private var movieDetail: MovieDetailModel?
    var movieReceiveSeeAllVC: Int?
    var chooseMovieOrTvShowReceiveMovieVC = MovieVC().chooseMovieOrTvShow
    private var loadingView: NVActivityIndicatorView = {
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
            make.width.equalTo(20)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MovieDetailManager.shared.fetch("\(movieReceiveSeeAllVC ?? 0)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let movieDetailObject = RealmService.shared.fetch(ofType: MovieDetailObject.self)
        if movieDetailObject.contains(where: { $0.idMovie == movieReceiveSeeAllVC}) {
            favoriteBtn.setImage(UIImage(named: "Favorite"), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: "UnFavotite"), for: .normal)
        }
        MovieDetailManager.shared.movieDetailBack = false
    }
    
    override func binding() {
        MovieDetailManager.shared.$movieDetail
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
        collectionView.registerNib(ofType: InformationMovieCVC.self)
        collectionView.registerNib(ofType: DescriptionCVC.self)
        collectionView.registerNib(ofType: TrailerCVC.self)
        collectionView.registerNib(ofType: StarringCVC.self)
        collectionView.registerNib(ofType: SimilarMoviesCVC.self)
        collectionView.contentInsetAdjustmentBehavior = .never
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
    
    private func addMovieToMovieDetailObject(_ movie: MovieDetailModel, _ movieObject: MovieDetailObject) {
        if let existingMovie = RealmService.shared.getByIdMovie(ofType: MovieDetailObject.self, idMovie: movie.id ?? 0 ) {
            RealmService.shared.delete(existingMovie)
            favoriteBtn.setImage(UIImage(named: "UnFavotite"), for: .normal)
        } else {
            RealmService.shared.add(movieObject)
            favoriteBtn.setImage(UIImage(named: "Favorite"), for: .normal)
        }
    }
    
    @IBAction func favoriteMovieBtnTapped(_ sender: Any) {
        if let movie = MovieDetailManager.shared.movieDetail {
            let movieObject = MovieDetailObject(movie)
            addMovieToMovieDetailObject(movie, movieObject)
        }
    }
    
    @IBAction func backNavigationBtnTapped(_ sender: Any) {
        FavoriteMovieManager.shared.tabSelected = .movie
        pop(animated: true)
    }
}

extension MovieDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MovieDetail.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movie = MovieDetailManager.shared.movieDetail {
            self.movieDetail = movie
        }
        switch MovieDetail.allCases[section] {
        case .informationMovie:
            return 1
        case .description:
            if movieDetail.debugDescription != "" {
                return 1
            } else {
                return 0
            }
        case .trailer:
            if movieDetail?.videos?.results.map({$0.map({$0.key ?? ""})})?.count != 0 {
                return 1
            } else {
                return 0
            }
        case .starring:
            if movieDetail?.credits?.cast?.count != 0 {
                return 1
            } else {
                return 0
            }
        case .similarMoive:
            if movieDetail?.recommendations?.results?.count != 0 {
                return 1
            } else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch MovieDetail.allCases[indexPath.section] {
        case .informationMovie:
            let cell = collectionView.dequeueCell(ofType: InformationMovieCVC.self, indexPath: indexPath)
            if let movie = MovieDetailManager.shared.movieDetail {
                cell.configDataMovie(movie)
                cell.delegate = self
            }
            return cell
        case .description:
            let cell = collectionView.dequeueCell(ofType: DescriptionCVC.self, indexPath: indexPath)
            if let movie = MovieDetailManager.shared.movieDetail {
                cell.configDataDescription(movie)
                cell.checkLineText(movie)
                cell.delegate = self
            }
            return cell
        case .trailer:
            let cell = collectionView.dequeueCell(ofType: TrailerCVC.self, indexPath: indexPath)
            if let movie = MovieDetailManager.shared.movieDetail {
                cell.setUpThumb(movie.videos?.results.map({$0.map({$0.key ?? ""})}))
                cell.delegate = self
            }
            return cell
        case .starring:
            let cell = collectionView.dequeueCell(ofType: StarringCVC.self, indexPath: indexPath)
            if let movie = MovieDetailManager.shared.movieDetail {
                let actorNames = movie.credits?.cast
                cell.setUpCell(actorNames)
                cell.delegate = self
            }
            return cell
        case .similarMoive:
            let cell = collectionView.dequeueCell(ofType: SimilarMoviesCVC.self, indexPath: indexPath)
            if let movie = MovieDetailManager.shared.movieDetail {
                let similar = movie.recommendations?.results
                cell.setUpDataSimilar(similar)
                cell.delegate = self
            }
            return cell
        }
    }
}

extension MovieDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch MovieDetail.allCases[indexPath.section] {
        case .informationMovie:
            break
        case .description:
            break
        case .trailer:
            break
        case .starring:
            break
        case .similarMoive:
            let vc = MovieDetailVC()
            if let movie = MovieDetailManager.shared.movieDetail {
                let similar = movie.recommendations?.results?[indexPath.item]
                vc.movieReceiveSeeAllVC = similar?.id
                push(to: vc, animated: true)
            }
        }
    }
}

extension MovieDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = (collectionView.frame.width / 2 - 13) * 1.36
        let heightCollectionView = collectionView.frame.height
        let widthCollectionView = collectionView.frame.width
        var minimumLineSpacing: CGFloat = 0
        switch MovieDetail.allCases[indexPath.section] {
        case .informationMovie:
            return CGSize(width: widthCollectionView, height: heightCollectionView / 1.58)
        case .description:
            return CGSize(width: widthCollectionView, height: heightBio)
        case .trailer:
            return CGSize(width: widthCollectionView, height: heightCollectionView / 7.28)
        case .starring:
            return CGSize(width: widthCollectionView, height: heightCollectionView / 7.28)
        case .similarMoive:
            let movie = MovieDetailManager.shared.movieDetail
            let similarMovieCount = movie?.recommendations?.results?.count
            let numberOfRow = ceil(CGFloat( min(6, similarMovieCount ?? 0) / 2))
            if numberOfRow > 0 {
                minimumLineSpacing = CGFloat((numberOfRow - 1) * 10)
            }
            let totalHeight = numberOfRow * height + minimumLineSpacing
            return CGSize(width: collectionView.frame.width, height: totalHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch MovieDetail.allCases[section] {
        case .informationMovie:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .description:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .trailer:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .starring:
            return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        case .similarMoive:
            return UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        }
    }
}

extension MovieDetailVC: DescriptionCVCDelegate {
    func setBioHeight(_ height: CGFloat) {
        self.heightBio = height
        self.collectionView.reloadData()
    }
}

extension MovieDetailVC: SimilarMoviesCVCDelegate {
    func showMovieDetail(for cell: SimilarMoviesCVC, at indexPath: IndexPath) {
        if isNetworkConnected {
            AdMobManager.shared.show(type: .interstitial,
                                     name: "AllLayout_Inter",
                                     rootViewController: self,
                                     didFail: nil,
                                     didHide: nil)
            let vc = MovieDetailVC()
            if let movie = MovieDetailManager.shared.movieDetail {
                let similar = movie.recommendations?.results?[indexPath.item]
                vc.movieReceiveSeeAllVC = similar?.id
                push(to: vc, animated: true)
            }
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
    
    func seeMoreSimilar() {
        if isNetworkConnected {
            let vc = SeeAllVC()
            vc.screenMovieAndSeeAll = .similar
            if let movie = MovieDetailManager.shared.movieDetail {
                vc.movieDetail = movie
            }
            push(to: vc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
}

extension MovieDetailVC: InformationMovieCVCDelegate {
    func showTrailerWatchNow() {
        if isNetworkConnected {
            if let movie = MovieDetailManager.shared.movieDetail {
                let trailerID = movie.videos?.results?.first?.key
                let vc = PlayTrailerVC()
                vc.trailerID = trailerID
                push(to: vc, animated: true)
            }
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
    
    func showPopUpAddMovieToPlan() {
        let childVC = PopUpAddMovie()
        self.addSubViewController(childVC)
        if let movieData = MovieDetailManager.shared.movieDetail {
            childVC.movieReceiveMovieDetail = MovieDetailManager.shared.convertToMovieObjects(results: movieData)
        }
    }
}

extension MovieDetailVC: TrailerCVCDelegate {
    func showTrailerPlayVC(for cell: TrailerCVC, at indexPath: IndexPath) {
        if isNetworkConnected {
            var trailerIndex = indexPath.item
            if AdMobManager.shared.state == .allow {
                if indexPath.item > 1 {
                    trailerIndex -= 1
                }
                if let movie = MovieDetailManager.shared.movieDetail {
                    let trailerID = movie.videos?.results?[trailerIndex].key
                    let vc = PlayTrailerVC()
                    vc.trailerID = trailerID
                    push(to: vc, animated: true)
                }
            } else {
                if let movie = MovieDetailManager.shared.movieDetail {
                    let trailerID = movie.videos?.results?[trailerIndex].key
                    let vc = PlayTrailerVC()
                    vc.trailerID = trailerID
                    push(to: vc, animated: true)
                }
            }
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
}

extension MovieDetailVC: StarringCVCDelegate {
    func showStarringDetail(for cell: StarringCVC, at indexPath: IndexPath) {
        if isNetworkConnected {
            if let starring = MovieDetailManager.shared.movieDetail {
                let actorIndexpath = starring.credits?.cast?[indexPath.item]
                let vc = ActorDetailVC()
                vc.actorID = actorIndexpath?.id
                push(to: vc, animated: true)
            }
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
}
