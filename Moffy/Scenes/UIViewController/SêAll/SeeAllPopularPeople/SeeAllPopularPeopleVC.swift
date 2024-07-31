//
//  SeeAllPopularPeopleVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 26/03/2024.
//

import UIKit
import PullToRefreshKit

class SeeAllPopularPeopleVC: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var footer = DefaultRefreshFooter()
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActorPopularManager.shared.fetch(currentPage, isLoadMore: false)
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actor = ActorPopularManager.shared.actorPopular[indexPath.item]
        let vc = ActorDetailVC()
        push(to: vc, animated: true)
        vc.actor = actor
    }
}

extension SeeAllPopularPeopleVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 1.14, height: 89)
    }
}

extension SeeAllPopularPeopleVC: UICollectionViewDelegate {
    
}


