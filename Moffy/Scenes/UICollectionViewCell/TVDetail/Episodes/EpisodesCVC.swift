//
//  EpisodesCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 08/04/2024.
//

import UIKit

protocol EpisodesCVCDelegate: AnyObject {
    func showSeason(for cell: EpisodesCVC, at indexpath: IndexPath)
}

class EpisodesCVC: BaseCollectionViewCell {
    @IBOutlet weak var collectionViewEpisodes: UICollectionView!
    @IBOutlet weak var collectionViewSeason: UICollectionView!
    
    weak var delegate: EpisodesCVCDelegate?
    var dataSeason: [Season]?
    var dataEposides: [Episode]?
    var selectedSeason: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setProperties() {
        collectionViewSeason.delegate = self
        collectionViewSeason.dataSource = self
        collectionViewEpisodes.dataSource = self
        collectionViewEpisodes.delegate = self
        collectionViewSeason.registerNib(ofType: SeasonCVC.self)
        collectionViewEpisodes.registerNib(ofType: SeasonDetailCVC.self)
    }
    
    func setUpCellSeason(_ dataSeason: [Season]?) {
        if let newdataSeason = dataSeason {
            self.dataSeason = newdataSeason
        }
       filterSpecialsSeason()
    }
    
    func setUpCellEposides(_ dataEposides: [Episode]?) {
        if let newDataEposides = dataEposides {
            self.dataEposides = newDataEposides
        }
        self.collectionViewEpisodes.reloadData()
    }
    
    func filterSpecialsSeason() {
        dataSeason = dataSeason?.filter { $0.name != "Specials" }
        collectionViewSeason.reloadData()
    }
}

extension EpisodesCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewSeason:
            return dataSeason?.count ?? 0
        case collectionViewEpisodes:
            return min(5, dataEposides?.count ?? 0)
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionViewSeason:
            let cell = collectionView.dequeueCell(ofType: SeasonCVC.self, indexPath: indexPath)
            if let newDataSeason = dataSeason {
                cell.configSeason(newDataSeason[indexPath.item])
                
                if selectedSeason == "" {
                    selectedSeason = newDataSeason[indexPath.item].name ?? ""
                }
                
                if newDataSeason[indexPath.item].name == selectedSeason {
                    cell.selectedSeason()
                }
            }
            
            return cell
        case collectionViewEpisodes:
            let cell = collectionView.dequeueCell(ofType: SeasonDetailCVC.self, indexPath: indexPath)
            if let newDataEposides = dataEposides {
                cell.configEposide(newDataEposides[indexPath.item])
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionViewSeason:
            if let newDataSeason = dataSeason {
                self.selectedSeason = newDataSeason[indexPath.item].name ?? newDataSeason[0].name ?? ""
            }
            delegate?.showSeason(for: self, at: indexPath)
        case collectionViewEpisodes:
            break
        default:
            break
        }
    }
}

extension EpisodesCVC: UICollectionViewDelegate {
    
}

extension EpisodesCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collectionViewSeason:
            return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height + 20)
        case collectionViewEpisodes:
            guard let episode = dataEposides?[indexPath.item] else {
                return CGSize(width: collectionViewEpisodes.frame.width, height: 0)
            }
            
            let episodeText = "\(episode.overview ?? "")"
            let width = collectionViewEpisodes.frame.width
            let height = episodeText.heightForView(font: AppFont.get(fontName: .manaropeSemibold, size: 12), width: width)
            
            return CGSize(width: width, height: height + 50 + UIScreen.main.bounds.height / 4.4)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
