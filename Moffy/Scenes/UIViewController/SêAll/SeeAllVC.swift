//
//  SeeAllVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 25/03/2024.
//

import UIKit
import PullToRefreshKit
import AdMobManager

class SeeAllVC: BaseViewController {
    @IBOutlet weak var noInternerView: UIView!
    @IBOutlet weak var nativeAdView: CustomNativeAdView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    
    enum ScreenMovieAndSeeAll {
        case popular
        case newMovie
        case forYou
        case seeAll
        case similar
    }
    
    private var footer = DefaultRefreshFooter()
    private var currentPagePopular = 1
    private var currentPageNewMovie = 1
    private var currentPageSeeAll = 1
    var arrayForYouMovieReceiveMovieVc = [Result]()
    var genre: MovieGenre?
    var movieDetail: MovieDetailModel?
    var screenMovieAndSeeAll: ScreenMovieAndSeeAll = .seeAll
    var chooseMovieOrTvShowReceiveGenresVC: MovieVC.MovieOrTVShow = .movie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.network() { [weak self] isConnect in
            switch isConnect {
            case true:
                self?.fetchData()
                self?.collectionView.isHidden = false
                self?.noInternerView.isHidden = true
                self?.collectionView.reloadData()
            case false:
                self?.collectionView.isHidden = true
                self?.noInternerView.isHidden = false
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func binding() {
        MovieGenreIdManager.shared.$movie
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        MoviePopularManager.shared.$moviePopular
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        UpComingManager.share.$upComing
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        MovieDetailManager.shared.$movieDetail
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    override func setProperties() {
        titleLbl.text = genre?.name
        showTitle()
        if AdMobManager.shared.state == .allow {
            addAds(name: "SeeAll_Native")
        } else {
            nativeAdView.isHidden = true
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: NoSearchCVC.self)
        footer.setText("", mode: .refreshing)
        footer.setText("", mode: .pullToRefresh)
        footer.setText("", mode: .scrollAndTapToRefresh)
        footer.setText("", mode: .tapToRefresh)
        footer.tintColor = .white
        
        self.collectionView.configRefreshFooter(with: footer,container: self) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.collectionView.switchRefreshFooter(to: .normal)
                switch self.screenMovieAndSeeAll {
                case .popular:
                    self.currentPagePopular += 1
                    MoviePopularManager.shared.fetch(self.currentPagePopular, isLoadMore: true)
                case .newMovie:
                    self.currentPageNewMovie += 1
                    UpComingManager.share.fetch(self.currentPageNewMovie, isLoadMore: true)
                case .forYou:
                    break
                case .seeAll:
                    self.currentPageSeeAll += 1
                    MovieGenreIdManager.shared.fetch(genreId: "\(self.genre?.id ?? 0)", page: self.currentPageSeeAll, isLoadMore: true)
                case .similar:
                    break
                }
            }
        }
    }
    
    private func showTitle() {
        switch screenMovieAndSeeAll {
        case .popular:
            titleLbl.text = "Polular"
        case .newMovie:
            titleLbl.text = "New Movie"
        case .forYou:
            titleLbl.text = "For You"
        case .similar:
            titleLbl.text = "Similar"
        case .seeAll:
            break
        }
    }
    
    private func addAds(name: String) {
        if AdMobManager.shared.status(type: .onceUsed(.native), name: name) == true {
          nativeAdView.setupAds(name: name, didError: { [weak self] in
            guard let self else { return }
              nativeAdView.isHidden = true
          })
        } else {
            nativeAdView.isHidden = true
        }
      }
    
    private func fetchData() {
        MoviePopularManager.shared.fetch(1, isLoadMore: false)
        UpComingManager.share.fetch(1, isLoadMore: false)
        MovieGenreIdManager.shared.fetch(genreId: "\(self.genre?.id ?? 0)", page: 1, isLoadMore: false)
    }
    
    @IBAction func backNavigationBtnTapped(_ sender: Any) {
        pop(animated: true)
    }
    
}

extension SeeAllVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch screenMovieAndSeeAll {
        case .popular:
            return MoviePopularManager.shared.moviePopular.count
        case .newMovie:
            return UpComingManager.share.upComing.count
        case .forYou:
            return arrayForYouMovieReceiveMovieVc.count
        case .seeAll:
            return MovieGenreIdManager.shared.movie.count
        case .similar:
            return movieDetail?.recommendations?.results?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: NoSearchCVC.self, indexPath: indexPath)
        switch screenMovieAndSeeAll {
        case .popular:
            let movie = MoviePopularManager.shared.moviePopular
            cell.configTitle(movie[indexPath.item])
            return cell
        case .newMovie:
            let movie = UpComingManager.share.upComing
            cell.configTitle(movie[indexPath.item])
            return cell
        case .forYou:
            cell.configTitle(arrayForYouMovieReceiveMovieVc[indexPath.item])
            return cell
        case .seeAll:
            let movie = MovieGenreIdManager.shared.movie
            cell.configTitle(movie[indexPath.item])
            return cell
        case .similar:
            cell.configSimilar(movieDetail?.recommendations?.results?[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AdMobManager.shared.show(type: .interstitial,
                                 name: "AllLayout_Inter",
                                 rootViewController: self,
                                 didFail: nil,
                                 didHide: nil)
        
        switch screenMovieAndSeeAll{
        case .popular:
            let movie = MoviePopularManager.shared.moviePopular[indexPath.item]
            let vc = MovieDetailVC()
            vc.chooseMovieOrTvShowReceiveMovieVC = self.chooseMovieOrTvShowReceiveGenresVC
            vc.movieReceiveSeeAllVC = movie.id
            push(to: vc, animated: true)
        case .newMovie:
            let movie = UpComingManager.share.upComing[indexPath.item]
            let vc = MovieDetailVC()
            vc.movieReceiveSeeAllVC = movie.id
            vc.chooseMovieOrTvShowReceiveMovieVC = self.chooseMovieOrTvShowReceiveGenresVC
            push(to: vc, animated: true)
        case .forYou:
            let movie = arrayForYouMovieReceiveMovieVc
            let vc = MovieDetailVC()
            vc.movieReceiveSeeAllVC = movie.map({$0.id})[indexPath.item]
            vc.chooseMovieOrTvShowReceiveMovieVC = self.chooseMovieOrTvShowReceiveGenresVC
            push(to: vc, animated: true)
        case .seeAll:
            let movie = MovieGenreIdManager.shared.movie[indexPath.item]
            let vc = MovieDetailVC()
            vc.chooseMovieOrTvShowReceiveMovieVC = self.chooseMovieOrTvShowReceiveGenresVC
            vc.movieReceiveSeeAllVC = movie.id
            push(to: vc, animated: true)
        case .similar:
            let vc = MovieDetailVC()
            vc.chooseMovieOrTvShowReceiveMovieVC = self.chooseMovieOrTvShowReceiveGenresVC
            vc.movieReceiveSeeAllVC = movieDetail?.recommendations?.results?[indexPath.item].id
            push(to: vc, animated: true)
        }
    }
}

extension SeeAllVC: UICollectionViewDelegate {
    
}

extension SeeAllVC: UICollectionViewDelegateFlowLayout{
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
