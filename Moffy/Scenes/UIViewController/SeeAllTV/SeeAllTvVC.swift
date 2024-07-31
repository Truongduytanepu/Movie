//
//  SeeAllTvVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 07/04/2024.
//

import UIKit
import PullToRefreshKit
import AdMobManager

class SeeAllTvVC: BaseViewController {
    @IBOutlet weak var noInternerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var customNativeAdView: CustomNativeAdView!
    @IBOutlet weak var noInternetViewBot: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    enum ScreenMovieAndSeeAll {
        case popular
        case newMovie
        case forYou
        case seeAll
        case similar
    }
    
    private var currentPagePopularTV = 1
    private var currentPageTVAiring = 1
    private var currentPageSeeAll = 1
    private var footer = DefaultRefreshFooter()
    var arrayForYouMovieReceiveMovieVc = [Result]()
    var genre: MovieGenre?
    var tvDetail: MovieDetailModel?
    var screenMovieAndSeeAll: ScreenMovieAndSeeAll = .seeAll
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkInternet()
    }
    
    override func binding() {
        TvShowPopularManager.shared.$tvShowPopular
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        TvShowAiringTodayManager.shared.$tvshowAiringToday
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        TvShowGenreIdManager.shared.$tvShowGenreId
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        TVDetailManager.shared.$tvDetail
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    override func setProperties() {
        collectionView.isHidden = false
        noInternerView.isHidden = true
        titleLbl.text = genre?.name
        showTitle()
        if AdMobManager.shared.state == .allow {
            self.addAds(name: "SeeAll_Native")
        } else {
            customNativeAdView.isHidden = true
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: NoSearchCVC.self)
        footer.setText("", mode: .refreshing)
        footer.setText("", mode: .pullToRefresh)
        footer.setText("", mode: .scrollAndTapToRefresh)
        footer.setText("", mode: .tapToRefresh)
        footer.tintColor = .white
        collectionView.configRefreshFooter(with: footer,container: self) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.collectionView.switchRefreshFooter(to: .normal)
                switch self.screenMovieAndSeeAll {
                case .popular:
                    self.currentPagePopularTV += 1
                    TvShowPopularManager.shared.fetch(self.currentPagePopularTV, true)
                case .newMovie:
                    self.currentPageTVAiring += 1
                    TvShowAiringTodayManager.shared.fetch(self.currentPageTVAiring, true)
                case .forYou:
                    break
                case .seeAll:
                    self.currentPageSeeAll += 1
                    TvShowGenreIdManager.shared.fetch("\(self.genre?.id ?? 0)", page: self.currentPageSeeAll, isLoadMore: true)
                case .similar:
                    break
                }
            }
        }
    }
    
    private func showTitle() {
        switch screenMovieAndSeeAll {
        case .popular:
            titleLbl.text = "Popular"
        case .newMovie:
            titleLbl.text = "New TV Show"
        case .forYou:
            titleLbl.text = "For You"
        case .similar:
            titleLbl.text = "Similar"
        case .seeAll:
            break
        }
    }
    
    private func checkInternet() {
        self.network() { [weak self] isConnect in
            switch isConnect {
            case true:
                TvShowPopularManager.shared.fetch(self?.currentPagePopularTV ?? 0, false)
                TvShowAiringTodayManager.shared.fetch(self?.currentPageTVAiring ?? 0, false)
                TvShowGenreIdManager.shared.fetch("\(self?.genre?.id ?? 0)", page: 1, isLoadMore: false)
                self?.collectionView.isHidden = false
                self?.noInternerView.isHidden = true
                self?.noInternetViewBot.isHidden = true
            case false:
                self?.collectionView.isHidden = true
                self?.noInternerView.isHidden = false
                self?.noInternetViewBot.isHidden = false
            }
        }
    }
    
    private func addAds(name: String) {
        if AdMobManager.shared.status(type: .onceUsed(.native), name: name) == true {
            customNativeAdView.setupAds(name: name, didError: { [weak self] in
            guard let self else { return }
                customNativeAdView.isHidden = true
          })
        } else {
            customNativeAdView.isHidden = true
        }
      }
    
    @IBAction func backNavigationBtnTapped(_ sender: Any) {
        pop(animated: true)
    }
    
}

extension SeeAllTvVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch screenMovieAndSeeAll {
        case .popular:
            return TvShowPopularManager.shared.tvShowPopular.count
        case .newMovie:
            return TvShowAiringTodayManager.shared.tvshowAiringToday.count
        case .forYou:
            return arrayForYouMovieReceiveMovieVc.count
        case .seeAll:
            return TvShowGenreIdManager.shared.tvShowGenreId.count
        case .similar:
            return tvDetail?.recommendations?.results?.count ?? 0        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: NoSearchCVC.self, indexPath: indexPath)
        switch screenMovieAndSeeAll {
        case .popular:
            let tv = TvShowPopularManager.shared.tvShowPopular
            cell.configTitleTvShow(tv[indexPath.item])
            return cell
        case .newMovie:
            let tv = TvShowAiringTodayManager.shared.tvshowAiringToday
            cell.configTitleTvShow(tv[indexPath.item])
            return cell
        case .forYou:
            cell.configTitleTvShow(arrayForYouMovieReceiveMovieVc[indexPath.item])
            return cell
        case .seeAll:
            let tv = TvShowGenreIdManager.shared.tvShowGenreId
            cell.configTitleTvShow(tv[indexPath.item])
            return cell
        case .similar:
            cell.configSimilar(tvDetail?.recommendations?.results?[indexPath.item])
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
            let tv = TvShowPopularManager.shared.tvShowPopular[indexPath.item]
            let vc = TVDetailVC()
            vc.genreIDReceiveTVShowVC = "\(tv.id ?? 0)"
            push(to: vc, animated: true)
        case .newMovie:
            let tv = TvShowAiringTodayManager.shared.tvshowAiringToday[indexPath.item]
            let vc = TVDetailVC()
            vc.genreIDReceiveTVShowVC = "\(tv.id ?? 0)"
            push(to: vc, animated: true)
        case .forYou:
            let tv = arrayForYouMovieReceiveMovieVc
            let vc = TVDetailVC()
            vc.genreIDReceiveTVShowVC = "\(tv.map({$0.id})[indexPath.item] ?? 0)"
            push(to: vc, animated: true)
        case .seeAll:
            let tv = TvShowGenreIdManager.shared.tvShowGenreId[indexPath.item]
            let vc = TVDetailVC()
            vc.genreIDReceiveTVShowVC = "\(tv.id ?? 0)"
            push(to: vc, animated: true)
        case .similar:
            let tvSimilar = tvDetail?.recommendations?.results?[indexPath.item]
            let vc = TVDetailVC()
            vc.genreIDReceiveTVShowVC = "\(tvSimilar?.id ?? 0)"
            push(to: vc, animated: true)
        }
    }
}

extension SeeAllTvVC: UICollectionViewDelegate {
    
}

extension SeeAllTvVC: UICollectionViewDelegateFlowLayout{
    
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
