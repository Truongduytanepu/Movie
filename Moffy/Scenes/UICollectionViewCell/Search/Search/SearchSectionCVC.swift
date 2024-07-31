//
//  SearchSectionCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 23/02/2024.
//

import UIKit

protocol SearchSectionCVCDelegate: AnyObject {
    func showTVDetail(_ result: Result)
    func showMovieDetail(_ result: Result)
    func showActorDetail(_ result: Result)
}

class SearchSectionCVC: BaseCollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private var viewEntiry: SearchEntity = SearchEntity()
    private var currentSearch: SearchEntity.TypeView = .noSearch
    weak var delegate: SearchSectionCVCDelegate?
    var dataMovie: [Result]?
    var dataTvShow: [Result]?
    var dataActor: [Result]?
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: NoSearchCVC.self)
    }
    
    func setupCell(dataMovie: [Result]?, dataTvShow: [Result]?, dataActor: [Result]?, title: String) {
        titleLbl.text = title
        self.dataMovie = dataMovie
        self.dataTvShow = dataTvShow
        self.dataActor = dataActor
        collectionView.reloadData()
    }
    
}
extension SearchSectionCVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataMovie != nil {
            dataMovie?.count ?? 1
        } else if dataTvShow != nil{
            dataTvShow?.count ?? 1
        } else {
            dataActor?.count ?? 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: NoSearchCVC.self, indexPath: indexPath)
        if dataMovie != nil {
            if let data = dataMovie {
                cell.configTitle(data[indexPath.item])
            }
        }
        
        if dataTvShow != nil{
            if let data = dataTvShow {
                cell.configTitleTvShow(data[indexPath.item])
            }
        }
        
        if dataActor != nil{
            if let data = dataActor {
                cell.configActor(data[indexPath.item])
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if dataMovie != nil {
            if let data = dataMovie {
                let movie = data[indexPath.item]
                delegate?.showMovieDetail(movie)
            }
        }
        
        if dataTvShow != nil{
            if let data = dataTvShow {
                let tv = data[indexPath.item]
                delegate?.showTVDetail(tv)
            }
        }
        
        if dataActor != nil{
            if let data = dataActor {
                let actor = data[indexPath.item]
                delegate?.showActorDetail(actor)
            }
        }
    }
}

extension SearchSectionCVC: UICollectionViewDelegateFlowLayout{
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
        let height = collectionView.frame.height
        
        return CGSize(width: height / 1.36 , height: height)
    }
}
