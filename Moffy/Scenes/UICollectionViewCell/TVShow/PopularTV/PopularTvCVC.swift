//
//  PopularTvCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 07/04/2024.
//

import UIKit
import FSPagerView
import AdMobManager

protocol PopularTvCVCDelegate: AnyObject {
    func showTvPopular()
    func showTVDetail(at indexPath: Int)
    func showImageTVIndexpath(_ image: String?)
    func showAlert()
}

class PopularTvCVC: BaseCollectionViewCell {
    @IBOutlet weak var pagerView: FSPagerView!
    
    private var dataTV: [Result] = []
    private var vcReceiveTvVC: UIViewController?
    weak var delegate: PopularTvCVCDelegate?
    var image: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setProperties() {
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(UINib(nibName: "PopularTVDetailCVC", bundle: nil), forCellWithReuseIdentifier: "PopularTVDetailCVC")
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 4.0
        pagerView.itemSize = CGSize(width: UIScreen.main.bounds.width / 1.9, height: UIScreen.main.bounds.width / 1.4)
        pagerView.reloadData()
    }
    
    func setUpCell(_ dataTV: [Result]?, vc: UIViewController?) {
        if let newDataTVs = dataTV {
            if !newDataTVs.isEmpty {
                self.dataTV = newDataTVs
                self.vcReceiveTvVC = vc
                delegate?.showImageTVIndexpath(newDataTVs[self.pagerView.currentIndex].posterPath)
            }
        }
        pagerView.reloadData()
    }
    
    @IBAction func seeAllPopularBtnTapped(_ sender: Any) {
        delegate?.showTvPopular()
    }
}

extension PopularTvCVC: FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return dataTV.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "PopularTVDetailCVC", at: index) as! PopularTVDetailCVC
        cell.configDataMovies(dataTV[index])
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if isNetworkConnected {
            delegate?.showTVDetail(at: index)
        } else {
            delegate?.showAlert()
        }
    }
}

extension PopularTvCVC: FSPagerViewDelegate {
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        let currentMovie = dataTV[targetIndex]
        delegate?.showImageTVIndexpath(currentMovie.posterPath)
        
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        let currentMovie = dataTV[pagerView.currentIndex]
        delegate?.showImageTVIndexpath(currentMovie.posterPath)
    }
}

