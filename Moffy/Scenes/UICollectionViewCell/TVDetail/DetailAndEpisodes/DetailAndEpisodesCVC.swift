//
//  DetailAndEpisodesCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 07/04/2024.
//

import UIKit

protocol DetailAndEpisodesCVCDelegate: AnyObject {
    func showSeasonDetail(for cell: EpisodesCVC, at indexpath: IndexPath)
    func showTrailerPlayVC(for cell: TrailerTvCVC, at indexpath: IndexPath)
    func showActorDetail(for cell: ActorTvCVC, at indexpath: IndexPath)
    func showTvDetailSimilar(for: SimilarTvCVC, at indexpath: IndexPath)
    func showMoreSimilar()
    func showDetailOrEposides(_ detailOrEposides: DetailOrEposides)
    func setBioHeight(_ height: CGFloat)
}

enum DetailScreenMovie: CaseIterable {
    case description
    case trailer
    case actor
    case similar
}

enum DetailOrEposides {
    case detail
    case eposides
}

class DetailAndEpisodesCVC: BaseCollectionViewCell {
    @IBOutlet weak var collectionViewEpisodes: UICollectionView!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var episodesBtn: UIButton!
    @IBOutlet weak var collectionViewDetail: UICollectionView!
    
    private var heightBio: CGFloat = 50
    weak var delegate: DetailAndEpisodesCVCDelegate?
    var detailOrEposides: DetailOrEposides = .detail
    var dataTV: MovieDetailModel?
    var dataSeason: [Season]?
    var dataEposides: [Episode]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewEpisodes.isHidden = true
    }
    
    override func setProperties() {
        collectionViewDetail.delegate = self
        collectionViewDetail.dataSource = self
        collectionViewEpisodes.delegate = self
        collectionViewEpisodes.dataSource = self
        collectionViewEpisodes.registerNib(ofType: EpisodesCVC.self)
        collectionViewEpisodes.registerNib(ofType: SeasonCVC.self)
        collectionViewDetail.registerNib(ofType: DescriptionTvCVC.self)
        collectionViewDetail.registerNib(ofType: TrailerTvCVC.self)
        collectionViewDetail.registerNib(ofType: ActorTvCVC.self)
        collectionViewDetail.registerNib(ofType: SimilarTvCVC.self)
    }
    
    func setUpCellDetail(_ dataTV: MovieDetailModel?) {
        if let newDataTV = dataTV {
            self.dataTV = newDataTV
        }
        self.collectionViewDetail.reloadData()
    }
    
    func setUpCellEposides(_ dataSeason: [Season]?, _ dataEposides: [Episode]?) {
        if let newDataSeason = dataSeason {
            self.dataSeason = newDataSeason
        }
        
        if let newDtaEposides = dataEposides {
            self.dataEposides = newDtaEposides
        }
        self.collectionViewEpisodes.reloadData()
    }
    
    @IBAction func detailBtnTapped(_ sender: Any) {
        collectionViewEpisodes.isHidden = true
        collectionViewDetail.isHidden = false
        detailBtn.setBackgroundImage(UIImage(named: "BGButtonPhoto"), for: .normal)
        episodesBtn.setBackgroundImage(nil, for: .normal)
        detailOrEposides = .detail
        delegate?.showDetailOrEposides(self.detailOrEposides)
    }
    
    @IBAction func episodesBtnTapped(_ sender: Any) {
        collectionViewDetail.isHidden = true
        collectionViewEpisodes.isHidden = false
        episodesBtn.setBackgroundImage(UIImage(named: "BGButtonPhoto"), for: .normal)
        detailBtn.setBackgroundImage(nil, for: .normal)
        detailOrEposides = .eposides
        delegate?.showDetailOrEposides(self.detailOrEposides)
    }
}

extension DetailAndEpisodesCVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case collectionViewDetail:
            return DetailScreenMovie.allCases.count
        case collectionViewEpisodes:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewDetail:
            switch DetailScreenMovie.allCases[section] {
            case .description:
                if dataTV?.overview != "" {
                    return 1
                } else {
                    return 0
                }
            case .trailer:
                if dataTV?.videos?.results.map({$0.map({$0.key ?? ""})})?.count != 0 {
                    return 1
                } else {
                    return 0
                }
            case .actor:
                if dataTV?.credits?.cast?.count != 0 {
                    return 1
                } else {
                    return 0
                }
            case .similar:
                if dataTV?.recommendations?.results?.count != 0 {
                    return 1
                } else {
                    return 0
                }
            }
        case collectionViewEpisodes:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionViewDetail:
            switch DetailScreenMovie.allCases[indexPath.section] {
            case .description:
                let cell = collectionViewDetail.dequeueCell(ofType: DescriptionTvCVC.self, indexPath: indexPath)
                if let dataTV = self.dataTV {
                    cell.configDataDescription(dataTV)
                    cell.checkLineText(dataTV)
                    cell.delegate = self
                }
                return cell
            case .trailer:
                let cell = collectionViewDetail.dequeueCell(ofType: TrailerTvCVC.self, indexPath: indexPath)
                if let dataTV = self.dataTV {
                    cell.setUpThumb(dataTV.videos?.results.map({$0.map({$0.key ?? ""})}))
                    cell.delegate = self
                }
                return cell
            case .actor:
                let cell = collectionViewDetail.dequeueCell(ofType: ActorTvCVC.self, indexPath: indexPath)
                if let dataTV = self.dataTV {
                    cell.setUpCell(dataTV.credits?.cast)
                    cell.delegate = self
                }
                return cell
            case .similar:
                let cell = collectionViewDetail.dequeueCell(ofType: SimilarTvCVC.self, indexPath: indexPath)
                if let dataTV = self.dataTV {
                    cell.setUpDataSimilar(dataTV.recommendations?.results)
                    cell.delegate = self
                }
                return cell
            }
        case collectionViewEpisodes:
            let cell = collectionViewEpisodes.dequeueCell(ofType: EpisodesCVC.self, indexPath: indexPath)
            cell.setUpCellSeason(dataSeason)
            cell.setUpCellEposides(dataEposides)
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension DetailAndEpisodesCVC: UICollectionViewDelegate {
    
}

extension DetailAndEpisodesCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = (collectionView.frame.width / 2 - 13) * 1.36
        let widthCollectionView = collectionView.frame.width
        let heightScreen = UIScreen.main.bounds.height
        var minimumLineSpacing: CGFloat = 0
        
        switch collectionView {
        case collectionViewDetail:
            switch DetailScreenMovie.allCases[indexPath.section] {
            case .description:
                return CGSize(width: widthCollectionView, height: 50 + heightBio)
            case .trailer:
                return CGSize(width: widthCollectionView, height: heightScreen / 7.28)
            case .actor:
                return CGSize(width: widthCollectionView, height: heightScreen / 7.28)
            case .similar:
                let numberOfRow = ceil(CGFloat( min(6, dataTV?.recommendations?.results?.count ?? 0) / 2))
                if numberOfRow > 0 {
                    minimumLineSpacing = CGFloat((numberOfRow - 1) * 10)
                }
                
                let totalHeight = numberOfRow * height + minimumLineSpacing
                return CGSize(width: collectionView.frame.width, height: totalHeight)
            }
        case collectionViewEpisodes:
            guard let episodes = dataEposides else {
                return CGSize(width: collectionViewEpisodes.frame.width, height: 0)
            }
            
            var totalHeight: CGFloat = 0
            let firstFiveEpisodes = episodes.prefix(5)
            for episode in firstFiveEpisodes {
                let episodeText = "\(episode.overview ?? "")"
                let width = collectionViewEpisodes.frame.width
                let height = episodeText.heightForView(font: AppFont.get(fontName: .manaropeMedium, size: 12), width: width - 32)
                totalHeight += height + 50 + (width + 32) / 2.17
            }
            return CGSize(width: collectionViewEpisodes.frame.width, height: totalHeight)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case collectionViewDetail:
            switch DetailScreenMovie.allCases[section] {
            case .description:
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            case .trailer:
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            case .actor:
                return UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
            case .similar:
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        case collectionViewEpisodes:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension DetailAndEpisodesCVC: EpisodesCVCDelegate {
    func showSeason(for cell: EpisodesCVC, at indexpath: IndexPath) {
        self.delegate?.showSeasonDetail(for: cell, at: indexpath)
    }
}

extension DetailAndEpisodesCVC: DescriptionTvCVCDelegate {
    func setBioHeight(_ height: CGFloat) {
        self.heightBio = height
        delegate?.setBioHeight(height)
        self.collectionViewDetail.reloadData()
    }
}

extension DetailAndEpisodesCVC: TrailerTvCVCDelegate {
    func showTrailerPlayVC(for cell: TrailerTvCVC, at indexPath: IndexPath) {
        delegate?.showTrailerPlayVC(for: cell, at: indexPath)
    }
}

extension DetailAndEpisodesCVC: ActorTvCVCDelegate {
    func showStarringDetail(for cell: ActorTvCVC, at indexPath: IndexPath) {
        delegate?.showActorDetail(for: cell, at: indexPath)
    }
}

extension DetailAndEpisodesCVC: SimilarTvCVCDelegate {
    func seeMoreSimilar() {
        delegate?.showMoreSimilar()
    }
    
    func showMovieDetail(for cell: SimilarTvCVC, at indexPath: IndexPath) {
        delegate?.showTvDetailSimilar(for: cell, at: indexPath)
    }
}
