//
//  ActorDetailVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 28/03/2024.
//

import UIKit

class ActorDetailVC: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var heightBio: CGFloat = 100
    private var filmorgraphyOrPhoto: FilmographyOrPhotoCVC.filmographyOrPhoto?
    
    var actorID: Int?
    
    enum ActorDetailScreen: CaseIterable {
        case informationActor
        case biography
        case filmographyActor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ActorDetailManager.shared.fetch(actorID ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: InformationActorCVC.self)
        collectionView.registerNib(ofType: BiographyCVC.self)
        collectionView.registerNib(ofType: FilmographyOrPhotoCVC.self)
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override func binding() {
        ActorDetailManager.shared.$actorDetail
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    private func addActorToFavorite(_ actor: ActorDetail, _ actorObject: ActorFavoriteObject) {
        if let existingActor = RealmService.shared.getById(ofType: ActorFavoriteObject.self, id: actor.id ?? 0) {
            RealmService.shared.delete(existingActor)
        } else {
            RealmService.shared.add(actorObject)
        }
    }
    
    @IBAction func backNavigationBtnTapped(_ sender: Any) {
        FavoriteMovieManager.shared.tabSelected = .actor
        pop(animated: true)
    }
}

extension ActorDetailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ActorDetailScreen.allCases.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch ActorDetailScreen.allCases[section] {
        case .informationActor:
            return 1
        case .biography:
            if ActorDetailManager.shared.actorDetail?.biography != "" {
                return 1
            } else {
                return 0
            }
        case .filmographyActor:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch ActorDetailScreen.allCases[indexPath.section] {
        case .informationActor:
            let cell = collectionView.dequeueCell(ofType: InformationActorCVC.self, indexPath: indexPath)
            if let actor = ActorDetailManager.shared.actorDetail {
                cell.configDataActor(actor)
                cell.delegate = self
            }
            return cell
        case .biography:
            let cell = collectionView.dequeueCell(ofType: BiographyCVC.self, indexPath: indexPath)
            if let actorDetail = ActorDetailManager.shared.actorDetail {
                cell.actorDetail = actorDetail
                cell.configDataActor(actorDetail)
                cell.checkLineText(actorDetail)
                cell.delegate = self
            }
            return cell
        case .filmographyActor:
            let cell = collectionView.dequeueCell(ofType: FilmographyOrPhotoCVC.self, indexPath: indexPath)
            cell.delegate = self
            if let photo = ActorDetailManager.shared.actorDetail?.listImage?.profiles {
                cell.setUpCellPhoto(photo)
            }
            if let filmography = ActorDetailManager.shared.actorDetail?.movieCredits?.cast {
                cell.setUpCellFilmography(filmography)
            }
            return cell
        }
    }
}

extension ActorDetailVC: UICollectionViewDelegate {
    
}

extension ActorDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let a: CGFloat = 13
        let width = (collectionView.frame.width - a - 32) / 2
        let height = width * 1.3
        var minimumLineSpacing: CGFloat = 0
        
        switch ActorDetailScreen.allCases[indexPath.section] {
        case .informationActor:
            let heightImage = collectionView.frame.height / 2
            return CGSize(width: collectionView.frame.width, height: heightImage)
        case .biography:
            return CGSize(width: collectionView.frame.width, height: heightBio)
        case .filmographyActor:
            switch filmorgraphyOrPhoto {
            case .filmography:
                let numberOfRow = ceil(CGFloat(ActorDetailManager.shared.actorDetail?.movieCredits?.cast.count ?? 0) / 2)
                if numberOfRow > 0 {
                    minimumLineSpacing = CGFloat((numberOfRow - 1) * 10)
                }
                let totalHeight = numberOfRow * height + minimumLineSpacing + 82
                return CGSize(width: collectionView.frame.width, height: totalHeight)
            case .photo:
                let numberOfRow = ceil(CGFloat(ActorDetailManager.shared.actorDetail?.listImage?.profiles.count ?? 0) / 2)
                if numberOfRow > 0 {
                    minimumLineSpacing = CGFloat((numberOfRow - 1) * 10)
                }
                let totalHeight = numberOfRow * height + minimumLineSpacing + 82
                return CGSize(width: collectionView.frame.width, height: totalHeight)
            case .none:
                let numberOfRow = ceil(CGFloat(ActorDetailManager.shared.actorDetail?.movieCredits?.cast.count ?? 0) / 2)
                if numberOfRow > 0 {
                    minimumLineSpacing = CGFloat((numberOfRow - 1) * 10)
                }
                let totalHeight = numberOfRow * height + minimumLineSpacing + 82
                return CGSize(width: collectionView.frame.width, height: totalHeight)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch ActorDetailScreen.allCases[section] {
        case .informationActor:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .biography:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .filmographyActor:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension ActorDetailVC: FilmographyOrPhotoCVCDelegate {
    func showAlert() {
        showAlert(title: "No Internet", message: "Please connect to the internet")
    }
    
    func filmorOrPhoto(_ switchFilmoOrPhoto: FilmographyOrPhotoCVC.filmographyOrPhoto) {
        self.filmorgraphyOrPhoto = switchFilmoOrPhoto
        self.collectionView.reloadData()
    }
}

extension ActorDetailVC: BiographyCVCDelegate {
    func setBioHeight(_ height: CGFloat) {
        self.heightBio = height + 50
        self.collectionView.reloadData()
    }
}

extension ActorDetailVC: InformationActorCVCDelegate {
    func addActorFavorite() {
        if let actor = ActorDetailManager.shared.actorDetail {
            let actorObject = ActorFavoriteObject(actor)
            addActorToFavorite(actor, actorObject)
            print(RealmService.shared.fetch(ofType: ActorFavoriteObject.self))
            collectionView.reloadData()
        }
    }
}
