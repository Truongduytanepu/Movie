//
//  PopularMovieCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 20/03/2024.
//

import UIKit
import FSPagerView
import AdMobManager

protocol PopularMovieCVCDelegate: AnyObject {
    func showMoviePopular()
    func showImageMovieIndexpath(_ image: String?)
    func showArlert()
    func showMoviePopularDetail(at indexPath: Int)
}

class PopularMovieCVC: BaseCollectionViewCell {
    @IBOutlet weak var pagerView: FSPagerView!
    
    private var dataMovies: [Result] = []
    private var vcReceiveMovieVC: UIViewController?
    weak var delegate: PopularMovieCVCDelegate?
    var image: String?
    var chooseMovieOrTVReceiMovieVC = MovieVC().chooseMovieOrTvShow
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setProperties() {
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(UINib(nibName: "PopularDetailCVC", bundle: nil), forCellWithReuseIdentifier: "PopularDetailCVC")
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 4.0
        pagerView.itemSize = CGSize(width: UIScreen.main.bounds.width / 1.9, height: UIScreen.main.bounds.width / 1.4)
        pagerView.reloadData()
    }
    
    func setUpCell(_ dataMovie: [Result]?, vc: UIViewController) {
        if let newDataMovies = dataMovie {
            if !newDataMovies.isEmpty {
                self.dataMovies = newDataMovies
                self.vcReceiveMovieVC = vc
                delegate?.showImageMovieIndexpath(newDataMovies[self.pagerView.currentIndex].posterPath)
            }
        }
        pagerView.reloadData()
    }
    
    @IBAction func seeAllPopularBtnTapped(_ sender: Any) {
        delegate?.showMoviePopular()
    }
}

extension PopularMovieCVC: FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return dataMovies.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "PopularDetailCVC", at: index) as! PopularDetailCVC
        cell.configDataMovies(dataMovies[index])
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if isNetworkConnected {
            delegate?.showMoviePopularDetail(at: index)
        } else {
            delegate?.showArlert()
        }
    }
}

extension PopularMovieCVC: FSPagerViewDelegate {
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        let currentMovie = dataMovies[targetIndex]
        delegate?.showImageMovieIndexpath(currentMovie.posterPath)
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        let currentMovie = dataMovies[pagerView.currentIndex]
        delegate?.showImageMovieIndexpath(currentMovie.posterPath)
    }
}
