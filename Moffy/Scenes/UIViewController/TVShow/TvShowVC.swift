//
//  TvShowVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 06/04/2024.
//

import UIKit
import CustomBlurEffectView
import AdMobManager

class TvShowVC: BaseViewController {
    @IBOutlet weak var blurView: CustomBlurEffectView!
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum TVHome: CaseIterable {
        case popular
        case newMovie
        case forYou
        case popularPeople
    }
    
    enum MovieOrTVShow {
        case movie
        case tvShow
    }
    
    private var imageIndexpath: String?
    private var arrayGenresIdTvShow: [Int] = []
    private var arrayTvShow: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTvShowGenreId()
        UpComingManager.share.fetch(1, isLoadMore: false)
        ActorPopularManager.shared.fetch(1, isLoadMore: false)
        TvShowPopularManager.shared.fetch(1, false)
        TvShowAiringTodayManager.shared.fetch(1, false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageBG.sd_setImage(with: URL(string: URLs.domainImage + "\(imageIndexpath ?? "")"),
                            placeholderImage: UIImage(named: "DefaultNil"))
        self.collectionView.reloadData()
    }
    
    override func binding() {
        UpComingManager.share.$upComing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self = self else {
                    return
                }
                collectionView.reloadData()
            }.store(in: &subscriptions)
        
        ActorPopularManager.shared.$actorPopular
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self = self else {
                    return
                }
                collectionView.reloadData()
            }.store(in: &subscriptions)
        
        TvShowPopularManager.shared.$tvShowPopular
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        TvShowAiringTodayManager.shared.$tvshowAiringToday
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        TvShowGenreIdManager.shared.$tvShowGenreId
            .receive(on: DispatchQueue.main)
            .sink { items in
                let newItems = items.filter { newItem in
                    !self.arrayTvShow.contains(where: { $0.id == newItem.id })
                }
                self.arrayTvShow.append(contentsOf: newItems)
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: PopularPeopleCVC.self)
        collectionView.registerNib(ofType: PopularTvCVC.self)
        collectionView.registerNib(ofType: NewTvCVC.self)
        collectionView.registerNib(ofType: ForYouTvCVC.self)
    }
    
    override func setColor() {
        blurView.blurRadius = 10
        blurView.colorTintAlpha = 0.5
        blurView.colorTint = UIColor.black
    }
    
    private func fetchTvShowGenreId() {
        for item in RealmService.shared.fetch(ofType: TVGenreObject.self) {
            arrayGenresIdTvShow.append(item.id)
        }
        for item in arrayGenresIdTvShow {
            TvShowGenreIdManager.shared.fetch("\(item)", page: 1, isLoadMore: false)
        }
    }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        if isNetworkConnected {
            AdMobManager.shared.show(type: .interstitial,
                                     name: "Search_Inter",
                                     rootViewController: self,
                                     didFail: nil,
                                     didHide: nil)
            let searchVc = SearchVC()
            push(to: searchVc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the interntet")
        }
    }
    
    @IBAction func genresBtnTapped(_ sender: Any) {
        if isNetworkConnected {
            let vc = GenresTvVC()
            push(to: vc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the interntet")
        }
    }
    
    @IBAction func settingBtnTapped(_ sender: Any) {
        let vc = SettingVC()
        push(to: vc, animated: true)
    }
}

extension TvShowVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return TVHome.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch TVHome.allCases[section] {
        case .popular:
            return 1
        case .newMovie:
            return 1
        case .forYou:
            return 1
        case .popularPeople:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch TVHome.allCases[indexPath.section] {
        case .popular:
            let cell = collectionView.dequeueCell(ofType: PopularTvCVC.self, indexPath: indexPath)
            cell.setUpCell(TvShowPopularManager.shared.tvShowPopular, vc: self)
            cell.delegate = self
            return cell
        case .newMovie:
            let cell = collectionView.dequeueCell(ofType: NewTvCVC.self, indexPath: indexPath)
            cell.setUpCell(TvShowAiringTodayManager.shared.tvshowAiringToday, vc: self)
            cell.delegate = self
            return cell
        case .forYou:
            let cell = collectionView.dequeueCell(ofType: ForYouTvCVC.self, indexPath: indexPath)
            cell.setUpCell(arrayTvShow, vc: self)
            cell.delegate = self
            return cell
        case .popularPeople:
            let cell = collectionView.dequeueCell(ofType: PopularPeopleCVC.self, indexPath: indexPath)
            cell.setUpCell(ActorPopularManager.shared.actorPopular)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch TVHome.allCases[indexPath.section] {
        case .popular:
            AdMobManager.shared.show(type: .interstitial,
                                     name: "AllLayout_Inter",
                                     rootViewController: self,
                                     didFail: nil,
                                     didHide: nil)
            let tv = TvShowPopularManager.shared.tvShowPopular[indexPath.item]
            let vc = TVDetailVC()
            vc.genreIDReceiveTVShowVC = "\(tv.id ?? 0)"
            push(to: vc, animated: true)
        case .newMovie:
            break
        case .forYou:
            break
        case .popularPeople:
            break
        }
    }
}

extension TvShowVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightScreen: CGFloat = UIScreen.main.bounds.height
        let heightTabbar: CGFloat = 70
        switch TVHome.allCases[indexPath.section] {
        case .popular:
            if UIDevice.current.userInterfaceIdiom == .phone {
                return CGSize(width: collectionView.frame.width, height: heightScreen / 2)
            }else{
                return CGSize(width: collectionView.frame.width, height: heightScreen / 1.5)
            }
        case .newMovie:
            return CGSize(width: collectionView.frame.width, height: heightScreen / 1.6)
        case .forYou:
            return CGSize(width: collectionView.frame.width, height: heightScreen / 1.6)
        case .popularPeople:
            return CGSize(width: collectionView.frame.width, height: heightScreen / 5.14 + heightTabbar)
        }
    }
}

extension TvShowVC: UICollectionViewDelegate {
    
}

extension TvShowVC: PopularTvCVCDelegate {
    func showTVDetail(at indexPath: Int) {
        AdMobManager.shared.show(type: .interstitial,
                                 name: "AllLayout_Inter",
                                 rootViewController: self,
                                 didFail: nil,
                                 didHide: nil)
        let tv = TvShowPopularManager.shared.tvShowPopular[indexPath]
        let vc = TVDetailVC()
        vc.genreIDReceiveTVShowVC = "\(tv.id ?? 0)"
        push(to: vc, animated: true)
    }
    
    func showAlert() {
        showAlert(title: "No Internet", message: "Please connect to the interntet")
    }
    
    func showTvPopular() {
        if isNetworkConnected {
            let vc = SeeAllTvVC()
            vc.screenMovieAndSeeAll = .popular
            push(to: vc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the interntet")
        }
    }
    
    func showImageTVIndexpath(_ image: String?) {
        self.imageBG.sd_setImage(with: URL(string: URLs.domainImage + "\(image ?? "")"),
                                 placeholderImage: UIImage(named: "DefaultNil"))
    }
}

extension TvShowVC: NewTvCVCDelegate {
    func showNewTVDetail(at indexPath: IndexPath) {
        AdMobManager.shared.show(type: .interstitial,
                                 name: "AllLayout_Inter",
                                 rootViewController: self,
                                 didFail: nil,
                                 didHide: nil)
        let tv = TvShowAiringTodayManager.shared.tvshowAiringToday[indexPath.item]
        let vc = TVDetailVC()
        vc.genreIDReceiveTVShowVC = "\(tv.id ?? 0)"
        push(to: vc, animated: true)
    }
    
    func seeAllNewTV() {
        if isNetworkConnected {
            let vc = SeeAllTvVC()
            vc.screenMovieAndSeeAll = .newMovie
            push(to: vc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the interntet")
        }
    }
}

extension TvShowVC: ForYouTvCVCDelegate {
    func showForYouDetail(at indexPath: IndexPath) {
        AdMobManager.shared.show(type: .interstitial,
                                 name: "AllLayout_Inter",
                                 rootViewController: self,
                                 didFail: nil,
                                 didHide: nil)
        let tv = arrayTvShow[indexPath.item]
        let vc = TVDetailVC()
        vc.genreIDReceiveTVShowVC = "\(tv.id ?? 0)"
        push(to: vc, animated: true)
    }
    
    func seeMoreForYou() {
        if isNetworkConnected {
            let vc = SeeAllTvVC()
            vc.screenMovieAndSeeAll = .forYou
            vc.arrayForYouMovieReceiveMovieVc = arrayTvShow
            push(to: vc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the interntet")
        }
    }
}

extension TvShowVC: PopularPeopleCVCDelegate {
    func showActorDetail(at indexPath: IndexPath) {
        let actor = ActorPopularManager.shared.actorPopular[indexPath.item]
        let vc = ActorDetailVC()
        push(to: vc, animated: true)
        vc.actorID = actor.id
    }
    
    func showArlert() {
        showAlert(title: "No Internet", message: "Please connect to the interntet")
    }
    
    func seeAllPopularPeople() {
        if isNetworkConnected {
            let vc = SeeAllPopularPeopleVC()
            push(to: vc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the interntet")
        }
    }
}

