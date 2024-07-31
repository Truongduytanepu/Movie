//
//  MovieVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 20/03/2024.
//

import UIKit
import CustomBlurEffectView
import AdMobManager

class MovieVC: BaseViewController {
    
    @IBOutlet weak var blurView: CustomBlurEffectView!
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum MovieHome: CaseIterable {
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
    private var arrayGenresIdMovie: [Int] = []
    private var arrayMovie: [Result] = []
    private var arrayGenresIdTvShow: [Int] = []
    private var arrayTvShow: [Result] = []
    private var currentPageMoviePopular = 1
    var chooseMovieOrTvShow: MovieOrTVShow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieGenreId()
        fetchTvShowGenreId()
        UpComingManager.share.fetch(1, isLoadMore: false)
        ActorPopularManager.shared.fetch(1, isLoadMore: false)
        MoviePopularManager.shared.fetch(currentPageMoviePopular, isLoadMore: false)
        TvShowPopularManager.shared.fetch(1, false)
        TvShowAiringTodayManager.shared.fetch(1, false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageBG.sd_setImage(with: URL(string: URLs.domainImage + "\(imageIndexpath ?? "")"),
                            placeholderImage: UIImage(named: "DefaultNil"))
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        
        MoviePopularManager.shared.$moviePopular
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self = self else {
                    return
                }
                collectionView.reloadData()
            }.store(in: &subscriptions)
        
        MovieGenreIdManager.shared.$movie
            .receive(on: DispatchQueue.main)
            .sink { items in
                let newItems = items.filter { newItem in
                    !self.arrayMovie.contains(where: { $0.id == newItem.id })
                }
                self.arrayMovie.append(contentsOf: newItems)
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    override func setColor() {
        blurView.blurRadius = 10
        blurView.colorTintAlpha = 0.5
        blurView.colorTint = UIColor.black
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: PopularPeopleCVC.self)
        collectionView.registerNib(ofType: PopularMovieCVC.self)
        collectionView.registerNib(ofType: NewMovieCVC.self)
        collectionView.registerNib(ofType: ForYouCVC.self)
    }
    
    private func fetchMovieGenreId() {
        for item in RealmService.shared.fetch(ofType: MovieGenreObject.self) {
            arrayGenresIdMovie.append(item.id)
        }
        for item in arrayGenresIdMovie {
            MovieGenreIdManager.shared.fetch(genreId: "\(item)", page: 1, isLoadMore: false)
        }
    }
    
    private func fetchTvShowGenreId() {
        for item in RealmService.shared.fetch(ofType: TVGenreObject.self) {
            arrayGenresIdTvShow.append(item.id)
        }
        for item in arrayGenresIdTvShow {
            TvShowGenreIdManager.shared.fetch("\(item)", page: 1, isLoadMore: false)
        }
    }
    
    @IBAction func genresMovieBtnTapped(_ sender: Any) {
        if isNetworkConnected {
            let vc = GenresMovieVC()
            vc.chooseMovieOrTvReceiveMovieVC = chooseMovieOrTvShow ?? .movie
            push(to: vc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the interntet")
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
    
    @IBAction func settingBtnTapped(_ sender: Any) {
        let vc = SettingVC()
        push(to: vc, animated: true)
    }
}

extension MovieVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MovieHome.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch MovieHome.allCases[section] {
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
        switch MovieHome.allCases[indexPath.section] {
        case .popular:
            let cell = collectionView.dequeueCell(ofType: PopularMovieCVC.self, indexPath: indexPath)
            cell.setUpCell(MoviePopularManager.shared.moviePopular, vc: self)
            cell.chooseMovieOrTVReceiMovieVC = .movie
            cell.delegate = self
            return cell
        case .newMovie:
            let cell = collectionView.dequeueCell(ofType: NewMovieCVC.self, indexPath: indexPath)
            cell.setUpCell(UpComingManager.share.upComing, vc: self)
            cell.delegate = self
            return cell
        case .forYou:
            let cell = collectionView.dequeueCell(ofType: ForYouCVC.self, indexPath: indexPath)
            cell.setUpCell(arrayMovie, vc: self)
            cell.chooseMovieOrTVReceiMovieVC = .movie
            cell.delegate = self
            return cell
        case .popularPeople:
            let cell = collectionView.dequeueCell(ofType: PopularPeopleCVC.self, indexPath: indexPath)
            cell.setUpCell(ActorPopularManager.shared.actorPopular)
            cell.delegate = self
            return cell
        }
    }
}

extension MovieVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightScreen: CGFloat = UIScreen.main.bounds.height
        let heightTabbar: CGFloat = 70
        switch MovieHome.allCases[indexPath.section] {
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

extension MovieVC: UICollectionViewDelegate {
    
}

extension MovieVC: PopularMovieCVCDelegate {
    func showMoviePopularDetail(at indexPath: Int) {
        AdMobManager.shared.show(type: .interstitial,
                                 name: "AllLayout_Inter",
                                 rootViewController: self,
                                 didFail: nil,
                                 didHide: nil)
        let movie = MoviePopularManager.shared.moviePopular[indexPath]
        let vc = MovieDetailVC()
        vc.movieReceiveSeeAllVC = movie.id
        self.push(to: vc, animated: true)
    }
    
    func showArlert() {
        showAlert(title: "No Internet", message: "Please connect to the interntet")
    }
    
    func showImageMovieIndexpath(_ image: String?) {
        self.imageBG.sd_setImage(with: URL(string: URLs.domainImage + "\(image ?? "")"),
                                 placeholderImage: UIImage(named: "DefaultNil"))
    }
    
    func showMoviePopular() {
        if isNetworkConnected {
            let vc = SeeAllVC()
            vc.screenMovieAndSeeAll = .popular
            vc.chooseMovieOrTvShowReceiveGenresVC = .movie
            push(to: vc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the interntet")
        }
    }
}

extension MovieVC: NewMovieCVCDelegate {
    func showNewMovieDetail(at indexPath: IndexPath) {
        AdMobManager.shared.show(type: .interstitial,
                                 name: "AllLayout_Inter",
                                 rootViewController: self,
                                 didFail: nil,
                                 didHide: nil)
        let movie = UpComingManager.share.upComing[indexPath.item]
        let vc = MovieDetailVC()
        vc.movieReceiveSeeAllVC = movie.id
        push(to: vc, animated: true)
    }
    
    func seeAllNewMovie() {
        if isNetworkConnected {
            let vc = SeeAllVC()
            vc.screenMovieAndSeeAll = .newMovie
            vc.chooseMovieOrTvShowReceiveGenresVC = .movie
            push(to: vc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the interntet")
        }
    }
}

extension MovieVC: ForYouCVCDelegate {
    func showForYouDetail(at indexPath: IndexPath) {
        AdMobManager.shared.show(type: .interstitial,
                                 name: "AllLayout_Inter",
                                 rootViewController: self,
                                 didFail: nil,
                                 didHide: nil)
        let movie = arrayMovie[indexPath.item]
        let vc = MovieDetailVC()
//        vc.chooseMovieOrTvShowReceiveMovieVC = self.chooseMovieOrTVReceiMovieVC
        vc.movieReceiveSeeAllVC = movie.id
        push(to: vc, animated: true)
    }
    
    func seeMoreForYou() {
        if isNetworkConnected {
            let vc = SeeAllVC()
            vc.screenMovieAndSeeAll = .forYou
            vc.arrayForYouMovieReceiveMovieVc = arrayMovie
            vc.chooseMovieOrTvShowReceiveGenresVC = .movie
            push(to: vc, animated: true)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the interntet")
        }
    }
}

extension MovieVC: PopularPeopleCVCDelegate {
    func showActorDetail(at indexPath: IndexPath) {
        let actor = ActorPopularManager.shared.actorPopular[indexPath.item]
        let vc = ActorDetailVC()
        push(to: vc, animated: true)
        vc.actorID = actor.id
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
