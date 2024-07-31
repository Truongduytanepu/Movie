//
//  SeeAllPopularPeopleVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 26/03/2024.
//

import UIKit
import PullToRefreshKit
import AdMobManager

class SeeAllPopularPeopleVC: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var customNativeAdView: CustomNativeAdView!
    
    private var footer = DefaultRefreshFooter()
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActorPopularManager.shared.fetch(currentPage, isLoadMore: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    override func binding() {
        ActorPopularManager.shared.$actorPopular
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: SeeAllPopularPeopleCVC.self)
        footer.setText("", mode: .refreshing)
        footer.setText("", mode: .pullToRefresh)
        footer.setText("", mode: .scrollAndTapToRefresh)
        footer.setText("", mode: .tapToRefresh)
        footer.tintColor = .white
        
        self.collectionView.configRefreshFooter(with: footer,container: self) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.collectionView.switchRefreshFooter(to: .normal)
                self.currentPage += 1
                ActorPopularManager.shared.fetch(self.currentPage, isLoadMore: true)
            }
        }
        
        if AdMobManager.shared.state == .allow {
            addAds(name: "SeeAll_Native")
        } else {
            customNativeAdView.isHidden = true
        }
    }
    
    private func addAds(name: String) {
        if AdMobManager.shared.status(type: .onceUsed(.native), name: name) == true {
          customNativeAdView.setupAds(name: name, didError: { [weak self] in
            guard let self else { return }
              customNativeAdView.isHidden = true
          })
        } else {
            customNativeAdView.isHidden = true
        }
      }
    
    private func addActorToFavorite(_ actor: ActorDetail, _ actorObject: ActorFavoriteObject) {
        if let existingActor = RealmService.shared.getById(ofType: ActorFavoriteObject.self, id: actor.id ?? 0) {
            RealmService.shared.delete(existingActor)
        } else {
            RealmService.shared.add(actorObject)
        }
        self.collectionView.reloadData()
    }
    
    @IBAction func backNavigationBtnTapped(_ sender: Any) {
        pop(animated: true)
    }
}

extension SeeAllPopularPeopleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ActorPopularManager.shared.actorPopular.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: SeeAllPopularPeopleCVC.self, indexPath: indexPath)
        let actor = ActorPopularManager.shared.actorPopular
        cell.configDataActor(actor[indexPath.item])
        cell.indexPathReceiveVC = indexPath
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actor = ActorPopularManager.shared.actorPopular[indexPath.item]
        let vc = ActorDetailVC()
        push(to: vc, animated: true)
        vc.actorID = actor.id
    }
}

extension SeeAllPopularPeopleVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 89)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension SeeAllPopularPeopleVC: UICollectionViewDelegate {
   
}

extension SeeAllPopularPeopleVC: SeeAllPopularPeopleCVCDelegate {
    func addActorToFavotite(at indexPath: IndexPath) {
        let actor = ActorPopularManager.shared.actorPopular[indexPath.item]
        let actorDetail = convertToActorDetail(actor)
        let actorObject = ActorFavoriteObject(actorDetail)
        addActorToFavorite(actorDetail, actorObject)
        print(RealmService.shared.fetch(ofType: ActorFavoriteObject.self))
    }
    
    func convertToActorDetail(_ result: Result) -> ActorDetail {
        return ActorDetail(
            adult: result.adult ?? false,
            alsoKnownAs: [],
            biography: nil,
            birthday: nil,
            deathday: nil,
            id: result.id ?? 0,
            knownForDepartment: result.knownForDepartment ?? "",
            name: result.name ?? "",
            placeOfBirth: nil,
            profilePath: result.profilePath ?? "",
            movieCredits: nil,
            listImage: nil
        )
    }
}
