//
//  GenresMovieVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 20/03/2024.
//

import UIKit
import AdMobManager

class GenresMovieVC: BaseViewController {
    @IBOutlet weak var nativeAdView: CustomNativeAdView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieGenreManager.shared.fetch()
        TVGenresManager.shared.fetch()
    }
    
    var chooseMovieOrTvReceiveMovieVC: MovieVC.MovieOrTVShow = .movie
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: GenresMovieCVC.self)
        if AdMobManager.shared.state == .allow {
            addAds(name: "SeeAll_Native")
        } else {
            nativeAdView.isHidden = true
        }
    }
    
    override func binding() {
        MovieGenreManager.shared.$movieGenre
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }
            .store(in: &subscriptions)
        
        TVGenresManager.shared.$tvGenre
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
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
    
    @IBAction func backNavigation(_ sender: Any) {
        pop(animated: true)
    }
}

extension GenresMovieVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch chooseMovieOrTvReceiveMovieVC {
        case .movie:
            return MovieGenreManager.shared.movieGenre.count
        case .tvShow:
            return TVGenresManager.shared.tvGenre.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: GenresMovieCVC.self, indexPath: indexPath)
        switch chooseMovieOrTvReceiveMovieVC {
        case .movie:
            let genre = MovieGenreManager.shared.movieGenre[indexPath.item]
            cell.config(genre)
        case .tvShow:
            let genre = TVGenresManager.shared.tvGenre[indexPath.item]
            cell.config(genre)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch chooseMovieOrTvReceiveMovieVC {
        case .movie:
            let genre = MovieGenreManager.shared.movieGenre[indexPath.item]
            let vc = SeeAllVC()
            vc.genre = genre
            vc.chooseMovieOrTvShowReceiveGenresVC = .movie
            push(to: vc, animated: true)
        case .tvShow:
            let genre = TVGenresManager.shared.tvGenre[indexPath.item]
            let vc = SeeAllVC()
            vc.genre = genre
            vc.chooseMovieOrTvShowReceiveGenresVC = .tvShow
            push(to: vc, animated: true)
        }
    }
}

extension GenresMovieVC: UICollectionViewDelegate {
    
}

extension GenresMovieVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftSpace: CGFloat = 42
        let itemSpace: CGFloat = 8
        let totalSpace: CGFloat = leftSpace * 2 + 8
        let widthItem = (collectionView.frame.width - totalSpace) / 2
        let heightItem = widthItem / 3
        return CGSize(width: widthItem, height: heightItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
