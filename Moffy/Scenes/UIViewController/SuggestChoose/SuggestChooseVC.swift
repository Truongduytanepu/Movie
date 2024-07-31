//
//  SuggestChooseVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 16/02/2024.
//

import UIKit
import PullToRefreshKit

class SuggestChooseVC: BaseViewController {
    @IBOutlet weak var viewChooseMovieOrTV: UIView!
    @IBOutlet weak var viewNointernet: UIView!
    @IBOutlet weak var chooseLbl: UILabel!
    @IBOutlet weak var tutorialLblStack: UILabel!
    @IBOutlet weak var viewChooseFilm: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieBtn: UIButton!
    @IBOutlet weak var tvBtn: UIButton!
    @IBOutlet weak var lineMovie: UIImageView!
    @IBOutlet weak var lineTV: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var imageNoData: UIImageView!
    @IBOutlet weak var noInternet: UIView!
    @IBOutlet weak var noInternerImageBot: UIImageView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    private var currentSearch: Search = .noSearch
    private var currentMedia: MediaType = .movie
    private var buttonTapCount = 0
    private var contentShowPopup = "Maximum 20 selected movies/tv show"
    private var image = UIImage(named: "Search")
    private var checkSetImagePlan: Bool = false
    private let movieDefault = MovieTopRateManager.shared.movieDefaultRealm
    private var footer = DefaultRefreshFooter()
    private var currentPageTV = 1
    private var currentPageMovie = 1
    var screenHome: ScreenHome = .suggestMovie
    var planReceiveChooseMovieBot: PlanObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkScreen()
        MovieGenreManager.shared.fetch()
        TVGenresManager.shared.fetch()
        MovieTopRateManager.shared.fetch(currentPageMovie, isLoadMore: false)
        TVTopRateManager.shared.fetch(currentPageTV, isLoadMore: false)
        
        if MovieTopRateManager.shared.cacheCoverPlan == "" {
            if planReceiveChooseMovieBot?.image != "" {
                MovieTopRateManager.shared.cacheCoverPlan1 = planReceiveChooseMovieBot?.image ?? ""
            }
        } else if !MovieTopRateManager.shared.cacheCoverPlan.isEmpty {
            MovieTopRateManager.shared.cacheCoverPlan1 = MovieTopRateManager.shared.cacheCoverPlan
        } else if MovieTopRateManager.shared.cacheCoverPlan1 == ""{
            MovieTopRateManager.shared.cacheCoverPlan1 = MovieTopRateManager.shared.cacheCoverPlan
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func binding() {
        super.binding()
        MovieTopRateManager.shared.$movieGenreId
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        TVTopRateManager.shared.$topRateTV
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        MovieSearchManager.shared.$searchMovie
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        TvSearchManager.shared.$searchTV
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        MovieTopRateManager.shared.$topRateMovie
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        MovieGenreIdManager.shared.$movie
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    override func setColor() {
        let maxSize = CGSize(width: 20, height: 20)
        let resizedImage = image!.resize(maxSize: maxSize)
        
        searchBar.layer.borderColor = UIColor(rgb: 0x5E5F67).cgColor
        searchBar.tintColor = .white
        searchBar.barTintColor = UIColor(rgb: 0x1E2032)
        
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Type to search"
                                                                             ,attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x626472)])
        
        searchBar.setImage(resizedImage, for: .search, state: .normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .search)
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: SuggestChooseCVC.self)
        footer.setText("", mode: .refreshing)
        footer.setText("", mode: .pullToRefresh)
        footer.setText("", mode: .scrollAndTapToRefresh)
        footer.setText("", mode: .tapToRefresh)
        footer.tintColor = .white
        
//        self.collectionView.configRefreshFooter(with: footer,container: self) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.collectionView.switchRefreshFooter(to: .normal)
//                switch self.currentSearch {
//                case .search:
//                    switch self.currentMedia {
//                    case .movie:
//                        switch self.screenHome {
//                        case .suggestMovie:
//                            <#code#>
//                        case .chooseCover:
//                            <#code#>
//                        case .chooseMovie:
//                            <#code#>
//                        }
//                    case .tv:
//                        switch self.screenHome {
//                        case .suggestMovie:
//                            <#code#>
//                        case .chooseCover:
//                            <#code#>
//                        case .chooseMovie:
//                            <#code#>
//                        }
//                    }
//                case .noSearch:
//                    <#code#>
//                }
//            }
//        }
        
        searchBar.delegate = self
        searchBar.layer.borderWidth = 1
        
        DispatchQueue.main.async { [self] in
            searchBar.layer.cornerRadius = searchBar.frame.height / 2
            nextBtn.layer.cornerRadius = nextBtn.frame.height / 2
            defaultButton()
        }
        
        lineMovie.isHidden = true
        lineTV.isHidden = true
        
        checkMovieOrTV(movieBtn: movieBtn, tvBtn: tvBtn)
        
        checkScreen()
        
        imageNoData.isHidden = true
        noInternet.isHidden = true
        noInternerImageBot.isHidden = true
    }
    
    private func checkScreen() {
        switch screenHome {
        case .suggestMovie:
            viewChooseFilm.isHidden = true
            tutorialLblStack.isHidden = false
        case .chooseCover:
            viewChooseFilm.isHidden = false
            tutorialLblStack.isHidden = true
            chooseLbl.text = "Choose Cover"
            nextBtn.setTitle("DONE", for: .normal)
        case .chooseMovie:
            viewChooseFilm.isHidden = false
            tutorialLblStack.isHidden = true
            chooseLbl.text = "Choose Movie"
            nextBtn.setTitle("DONE", for: .normal)
        }
    }
    
    private func defaultButton() {
        nextBtn.borderColor = UIColor(rgb: 0x7CDD9)
        nextBtn.borderWidth = 1
        nextBtn.layer.sublayers?.forEach {
            if $0 is CAGradientLayer {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    private func checkMovieOrTV(movieBtn: UIButton, tvBtn: UIButton) {
        switch currentMedia {
        case .movie:
            movieBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            movieBtn.setTitleColor(.white, for: .normal)
            lineMovie.isHidden = false
            
            tvBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            tvBtn.setTitleColor(.gray, for: .normal)
            lineTV.isHidden = true
        case .tv:
            tvBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            tvBtn.setTitleColor(.white, for: .normal)
            lineTV.isHidden = false
            
            movieBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            movieBtn.setTitleColor(.gray, for: .normal)
            lineMovie.isHidden = true
        }
    }
    
    private func checkItemSelected(cacheMovies: [MovieObject]) {
        if cacheMovies.isEmpty {
            defaultButton()
        } else {
            gradiant(button: nextBtn)
            nextBtn.borderColor = .clear
        }
    }
    
    @IBAction func backNavigation(_ sender: Any) {
        MovieTopRateManager.shared.cacheCoverPlan1 = ""
        MovieTopRateManager.shared.movieChooseArray = MovieTopRateManager.shared.movieDefaultRealm
        pop(animated: true)
    }
    
    @IBAction func nextHandle(_ sender: Any) {
        switch screenHome {
        case .suggestMovie:
            if MovieTopRateManager.shared.cacheMovies.count > 0 {
                PlanManager.shared.createYourPlanDefault()
                PlanManager.shared.createNameMoviePlan()
                PlanManager.shared.createPlanForGenre()
                PlanManager.shared.createPlanForWeekend()
                let tabbarVC = TabBarVC()
                self.push(to: tabbarVC, animated: true)
            }
        case .chooseCover:
            pop(animated: true)
            MovieTopRateManager.shared.cacheCoverPlan = MovieTopRateManager.shared.cacheCoverPlan1
        case .chooseMovie:
            MovieTopRateManager.shared.movieDefaultRealm = MovieTopRateManager.shared.movieChooseArray
            pop(animated: true)
        }
    }
    
    @IBAction func movieHandle(_ sender: Any) {
        currentMedia = .movie
        checkMovieOrTV(movieBtn: movieBtn, tvBtn: tvBtn)
        collectionView.reloadData()
    }
    
    @IBAction func tvShowHandle(_ sender: Any) {
        currentMedia = .tv
        checkMovieOrTV(movieBtn: movieBtn, tvBtn: tvBtn)
        
        if currentSearch == .search {
            TvSearchManager.shared.fetch(query: searchBar.text ?? "", page: 1, isLoadMore: false)
        }
        collectionView.reloadData()
    }
}

extension SuggestChooseVC: UICollectionViewDelegate{
    
}

extension SuggestChooseVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        switch currentSearch {
        case .search:
            switch currentMedia {
            case .movie:
                itemCount = MovieSearchManager.shared.searchMovie.count
            case .tv:
                itemCount = TvSearchManager.shared.searchTV.count
            }
        case .noSearch:
            switch currentMedia {
            case .movie:
                itemCount = MovieTopRateManager.shared.topRateMovie.count
            case .tv:
                itemCount = TVTopRateManager.shared.topRateTV.count
            }
        }
        
        if itemCount == 0 {
            imageNoData.isHidden = false
            collectionView.isHidden = true
        } else {
            imageNoData.isHidden = true
            collectionView.isHidden = false
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: SuggestChooseCVC.self, indexPath: indexPath)
        switch currentSearch {
        case .search:
            switch currentMedia {
            case .movie:
                switch screenHome {
                case .suggestMovie:
                    let movie = MovieSearchManager.shared.searchMovie[indexPath.row]
                    if MovieTopRateManager.shared.cacheMovies.contains(where: {$0.idMovie == movie.id})  {
                        cell.selectedCell()
                    }else {
                        cell.removeSelectedCell()
                    }
                    cell.configTitleTvShow(movie)
                case .chooseCover:
                    let movie = MovieSearchManager.shared.searchMovie[indexPath.row]
                    cell.configTitle(movie)
                    if !MovieTopRateManager.shared.cacheCoverPlan1.isEmpty || !MovieTopRateManager.shared.cacheCoverPlan.isEmpty{
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                case .chooseMovie:
                    let movie = MovieSearchManager.shared.searchMovie[indexPath.row]
                    let movieSelected = MovieTopRateManager.shared.movieChooseArray
                    cell.configTitle(movie)
                    if movieSelected.contains(where: {$0.idMovie == movie.id}){
                        cell.selectedCell()
                    } else {
                        cell.removeSelectedCell()
                    }
                    
                    checkItemSelected(cacheMovies: movieSelected)
                }
            case .tv:
                switch screenHome {
                case .suggestMovie:
                    let tv = TvSearchManager.shared.searchTV[indexPath.row]
                    if MovieTopRateManager.shared.cacheMovies.contains(where: {$0.idMovie == tv.id})  {
                        cell.selectedCell()
                    }else {
                        cell.removeSelectedCell()
                    }
                    cell.configTitleTvShow(tv)
                case .chooseCover:
                    let tv = TvSearchManager.shared.searchTV[indexPath.row]
                    cell.configTitle(tv)
                    if !MovieTopRateManager.shared.cacheCoverPlan1.isEmpty || !MovieTopRateManager.shared.cacheCoverPlan.isEmpty{
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                case .chooseMovie:
                    let tv = TvSearchManager.shared.searchTV[indexPath.row]
                    let movieSelected = MovieTopRateManager.shared.movieChooseArray
                    cell.configTitleTvShow(tv)
                    if movieSelected.contains(where: {$0.idMovie == tv.id}){
                        cell.selectedCell()
                    }else {
                        cell.removeSelectedCell()
                    }
                    
                    checkItemSelected(cacheMovies: movieSelected)
                }
            }
        case .noSearch:
            switch currentMedia {
            case .movie:
                switch screenHome {
                case .suggestMovie:
                    let movie = MovieTopRateManager.shared.topRateMovie[indexPath.row]
                    cell.configTitle(movie)
                    if MovieTopRateManager.shared.cacheMovies.contains(where: {$0.idMovie == movie.id})  {
                        cell.selectedCell()
                    }else {
                        cell.removeSelectedCell()
                    }
                    
                case .chooseCover:
                    let movie = MovieTopRateManager.shared.topRateMovie[indexPath.row]
                    cell.configTitle(movie)
                    if !MovieTopRateManager.shared.cacheCoverPlan1.isEmpty || !MovieTopRateManager.shared.cacheCoverPlan.isEmpty{
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                case .chooseMovie:
                    let movie = MovieTopRateManager.shared.topRateMovie[indexPath.row]
                    let movieSelected = MovieTopRateManager.shared.movieChooseArray
                    cell.configTitle(movie)
                    if movieSelected.contains(where: {$0.idMovie == movie.id}){
                        cell.selectedCell()
                    }else {
                        cell.removeSelectedCell()
                    }
                    checkItemSelected(cacheMovies: movieSelected)
                }
            case .tv:
                switch screenHome {
                case .suggestMovie:
                    let tv = TVTopRateManager.shared.topRateTV[indexPath.row]
                    cell.configTitleTvShow(tv)
                    if MovieTopRateManager.shared.cacheMovies.contains(where: {$0.idMovie == tv.id}) {
                        cell.selectedCell()
                    }else {
                        cell.removeSelectedCell()
                    }
                case .chooseCover:
                    let tv = TVTopRateManager.shared.topRateTV[indexPath.row]
                    cell.configTitle(tv)
                    if !MovieTopRateManager.shared.cacheCoverPlan1.isEmpty || !MovieTopRateManager.shared.cacheCoverPlan.isEmpty{
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                case .chooseMovie:
                    let tv = TVTopRateManager.shared.topRateTV[indexPath.row]
                    let movieSelected = MovieTopRateManager.shared.movieChooseArray
                    cell.configTitleTvShow(tv)
                    if movieSelected.contains(where: {$0.idMovie == tv.id}){
                        cell.selectedCell()
                    }else {
                        cell.removeSelectedCell()
                    }
                    
                    checkItemSelected(cacheMovies: movieSelected)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentSearch {
        case .search:
            switch currentMedia {
            case .movie:
                switch screenHome {
                case .suggestMovie:
                    let movie = MovieSearchManager.shared.searchMovie[indexPath.item]
                    let movieObject = MovieObject(movie)
                    if MovieTopRateManager.shared.cacheMovies.count < 20 {
                        MovieTopRateManager.shared.saveMovieSelected(with: movieObject)
                    } else if let existingMovie = MovieTopRateManager.shared.cacheMovies.firstIndex(where: {$0.idMovie == movie.id})  {
                        MovieTopRateManager.shared.cacheMovies.remove(at: existingMovie)
                        collectionView.reloadItems(at: [indexPath])
                    } else {
                        showPopUp(content: contentShowPopup)
                    }
                    
                    if MovieTopRateManager.shared.cacheMovies.count > 0 {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadItems(at: [indexPath])
                case .chooseCover:
                    let movie = MovieSearchManager.shared.searchMovie[indexPath.row]
                    let movieObject = MovieObject(movie)
                    MovieTopRateManager.shared.saveCoverMovieSelected(with: movieObject)
                    if !MovieTopRateManager.shared.cacheCoverPlan.isEmpty {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadData()
                    
                case .chooseMovie:
                    let movie = MovieSearchManager.shared.searchMovie[indexPath.item]
                    let movieObject = MovieObject(movie)
                    if MovieTopRateManager.shared.movieChooseArray.count < 20 {
                        MovieTopRateManager.shared.saveMovieToPlan(with: movieObject)
                        
                    } else if let existingMovie = MovieTopRateManager.shared.movieChooseArray.firstIndex(where: {$0.idMovie == movie.id})  {
                        MovieTopRateManager.shared.movieChooseArray.remove(at: existingMovie)
                        collectionView.reloadItems(at: [indexPath])
                    } else {
                        showPopUp(content: contentShowPopup)
                    }
                    
                    if MovieTopRateManager.shared.movieChooseArray.count > 0 {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadItems(at: [indexPath])
                }
            case .tv:
                switch screenHome {
                case .suggestMovie:
                    let tv = TvSearchManager.shared.searchTV[indexPath.item]
                    let tvObject = MovieObject(tv)
                    if MovieTopRateManager.shared.cacheMovies.count < 20{
                        MovieTopRateManager.shared.saveMovieSelected(with: tvObject)
                    } else if let existingMovie = MovieTopRateManager.shared.cacheMovies.firstIndex(where: {$0.idMovie == tv.id})  {
                        MovieTopRateManager.shared.cacheMovies.remove(at: existingMovie)
                        collectionView.reloadItems(at: [indexPath])
                    } else {
                        showPopUp(content: contentShowPopup)
                    }
                    
                    if MovieTopRateManager.shared.cacheMovies.count > 0 {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadItems(at: [indexPath])
                case .chooseCover:
                    let tv = TvSearchManager.shared.searchTV[indexPath.row]
                    let tvObject = MovieObject(tv)
                    MovieTopRateManager.shared.saveCoverMovieSelected(with: tvObject)
                    if !MovieTopRateManager.shared.cacheCoverPlan.isEmpty {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadData()
                case .chooseMovie:
                    let tv = TvSearchManager.shared.searchTV[indexPath.item]
                    let tvObject = MovieObject(tv)
                    if MovieTopRateManager.shared.movieChooseArray.count < 20{
                        MovieTopRateManager.shared.saveMovieToPlan(with: tvObject)
                    } else if let existingMovie = MovieTopRateManager.shared.movieChooseArray.firstIndex(where: {$0.idMovie == tv.id})  {
                        MovieTopRateManager.shared.movieChooseArray.remove(at: existingMovie)
                        collectionView.reloadItems(at: [indexPath])
                    } else {
                        showPopUp(content: contentShowPopup)
                    }
                    
                    if MovieTopRateManager.shared.movieChooseArray.count > 0 {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadItems(at: [indexPath])
                }
            }
        case .noSearch:
            switch currentMedia {
            case .movie:
                switch screenHome {
                case .suggestMovie:
                    let movie = MovieTopRateManager.shared.topRateMovie[indexPath.row]
                    let movieObject = MovieObject(movie)
                    if MovieTopRateManager.shared.cacheMovies.count < 20{
                        MovieTopRateManager.shared.saveMovieSelected(with: movieObject)
                    } else if let existingMovie = MovieTopRateManager.shared.cacheMovies.firstIndex(where: {$0.idMovie == movie.id})  {
                        MovieTopRateManager.shared.cacheMovies.remove(at: existingMovie)
                        collectionView.reloadItems(at: [indexPath])
                    } else {
                        showPopUp(content: contentShowPopup)
                    }
                    
                    if MovieTopRateManager.shared.cacheMovies.count > 0 {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadItems(at: [indexPath])
                case .chooseCover:
                    let movie = MovieTopRateManager.shared.topRateMovie[indexPath.row]
                    let movieObject = MovieObject(movie)
                    MovieTopRateManager.shared.saveCoverMovieSelected(with: movieObject)
                    if !MovieTopRateManager.shared.cacheCoverPlan.isEmpty {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadData()
                case .chooseMovie:
                    let movie = MovieTopRateManager.shared.topRateMovie[indexPath.row]
                    let movieObject = MovieObject(movie)
                    if MovieTopRateManager.shared.movieChooseArray.count < 20  {
                        MovieTopRateManager.shared.saveMovieToPlan(with: movieObject)
                    } else if let existingMovie = MovieTopRateManager.shared.movieChooseArray.firstIndex(where: {$0.idMovie == movie.id})  {
                        MovieTopRateManager.shared.movieChooseArray.remove(at: existingMovie)
                        collectionView.reloadItems(at: [indexPath])
                    } else {
                        showPopUp(content: contentShowPopup)
                    }
                    
                    if MovieTopRateManager.shared.movieChooseArray.count > 0 {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadItems(at: [indexPath])
                }
            case .tv:
                switch screenHome {
                case .suggestMovie:
                    let tv = TVTopRateManager.shared.topRateTV[indexPath.row]
                    let tvObject = MovieObject(tv)
                    if MovieTopRateManager.shared.cacheMovies.count < 20 {
                        MovieTopRateManager.shared.saveMovieSelected(with: tvObject)
                    } else if let existingMovie = MovieTopRateManager.shared.cacheMovies.firstIndex(where: {$0.idMovie == tv.id})  {
                        MovieTopRateManager.shared.cacheMovies.remove(at: existingMovie)
                        collectionView.reloadItems(at: [indexPath])
                    } else {
                        showPopUp(content: contentShowPopup)
                    }
                    
                    if MovieTopRateManager.shared.cacheMovies.count > 0 {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadItems(at: [indexPath])
                case .chooseCover:
                    let tv = TVTopRateManager.shared.topRateTV[indexPath.row]
                    let tvObject = MovieObject(tv)
                    MovieTopRateManager.shared.saveCoverMovieSelected(with: tvObject)
                    if !MovieTopRateManager.shared.cacheCoverPlan.isEmpty {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadData()
                case .chooseMovie:
                    let tv = TVTopRateManager.shared.topRateTV[indexPath.row]
                    let tvObject = MovieObject(tv)
                    if MovieTopRateManager.shared.movieChooseArray.count < 20 {
                        MovieTopRateManager.shared.saveMovieToPlan(with: tvObject)
                    } else if let existingMovie = MovieTopRateManager.shared.movieChooseArray.firstIndex(where: {$0.idMovie == tv.id})  {
                        MovieTopRateManager.shared.movieChooseArray.remove(at: existingMovie)
                        collectionView.reloadItems(at: [indexPath])
                    } else {
                        showPopUp(content: contentShowPopup)
                    }
                    
                    if MovieTopRateManager.shared.movieChooseArray.count > 0 {
                        gradiant(button: nextBtn)
                        nextBtn.borderColor = .clear
                    } else {
                        defaultButton()
                    }
                    collectionView.reloadItems(at: [indexPath])
                }
            }
        }
    }
}

extension SuggestChooseVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 4
        let spacingBetweenItems: CGFloat = 13
        let totalSpacing = spacingBetweenItems * (numberOfColumns - 1)
        let width = (collectionView.frame.width - totalSpacing) / numberOfColumns
        return CGSize(width: width, height: width * 1.36)
    }
}

extension SuggestChooseVC: UISearchBarDelegate {
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
                self?.collectionView.isHidden = false
                self?.doneBtn.isHidden = false
                self?.viewChooseMovieOrTV.isHidden = false
            case false:
                self?.noInternerImageBot.isHidden = false
                self?.noInternet.isHidden = false
                self?.collectionView.isHidden = true
                self?.imageNoData.isHidden = true
                self?.doneBtn.isHidden = true
                self?.viewChooseMovieOrTV.isHidden = true
            }
        }
        
        if ((searchBar.text?.isEmpty) ?? true) {
            currentSearch = .noSearch
            collectionView.reloadData()
        }
    }
}
