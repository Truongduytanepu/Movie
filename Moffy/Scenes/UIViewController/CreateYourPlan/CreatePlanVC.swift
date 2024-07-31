//
//  CreatePlanVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 03/03/2024.
//

import UIKit
import AdMobManager

enum CreatePlan: CaseIterable {
    case editCover
    case chooseMovie
}

protocol CreatePlanVCDelegate: AnyObject {
    func didUpdateOrCreatePlan()
}

class CreatePlanVC: BaseViewController {
    @IBOutlet weak var customAdNativeView: CustomNativeAdView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneBtn: UIButton!
    
    var namePlan: String?
    var notePlan: String?
    var image: String?
    var startDate = Date()
    var endDate = Date()
    var plan: PlanObject?
    var check = MovieTopRateManager.shared.checkEditOrCreatePlan
    weak var delegate: CreatePlanVCDelegate?
    
    override func binding() {
        MovieTopRateManager.shared.$movieDefaultRealm
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        MovieTopRateManager.shared.$movieChooseArray
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMovieToDefaultRealm()
        if let planMovies = plan?.movies {
            MovieTopRateManager.shared.movieChooseArray += planMovies
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: ChooseMovieCVC.self)
        collectionView.registerNib(ofType: ChooseMovieBotCVC.self)
        
        if AdMobManager.shared.state == .allow {
            addAds(name: "SeeAll_Native")
        } else {
            customAdNativeView.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveMovie), name: Notification.Name("DidRemoveMovie"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: Notification.Name("ReloadCollectionViewNotification"), object: nil)
    }
    
    @objc func didRemoveMovie() {
        collectionView.reloadData()
    }
    
    @objc func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setColor() {
        gradiant(button: doneBtn)
    }
    
    private func clearTextField() {
        MovieTopRateManager.shared.movieChooseArray.removeAll()
        MovieTopRateManager.shared.movieDefaultRealm.removeAll()
        MovieTopRateManager.shared.cacheMoviesPlan.removeAll()
        MovieTopRateManager.shared.cacheCoverPlan = ""
        PlanManager.shared.startDate = nil
        PlanManager.shared.endDate = nil
    }
    
    private func addMovieToDefaultRealm() {
        if let planMovies = plan?.movies {
            let existingMovieIDs = Set(MovieTopRateManager.shared.movieDefaultRealm.map { $0.id })
            for movie in planMovies {
                if !existingMovieIDs.contains(movie.id) {
                    MovieTopRateManager.shared.movieDefaultRealm.append(movie)
                }
            }
        }
    }
    
    private func addAds(name: String) {
        if AdMobManager.shared.status(type: .onceUsed(.native), name: name) == true {
            customAdNativeView.setupAds(name: name, didError: { [weak self] in
                guard let self else { return }
                customAdNativeView.isHidden = true
            })
        } else {
            customAdNativeView.isHidden = true
        }
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        if MovieTopRateManager.shared.checkEditOrCreatePlan == 0 {
            let note = (collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ChooseMovieCVC)?.notePlanTV.text ?? ""
            let startDate = PlanManager.shared.startDate
            let endDate = PlanManager.shared.endDate
            let existingPlan = RealmService.shared.fetch(ofType: PlanObject.self).filter { $0.id == plan?.id }.first
            
            guard let namePlan = self.namePlan, !namePlan.isEmpty else {
                showToast(message: "Please enter your plan's name")
                return
            }
            
            guard !MovieTopRateManager.shared.movieDefaultRealm.isEmpty else {
                showToast(message: "Please select at least one Movie/TV Show")
                return
            }
            
            if existingPlan != nil {
                print("Can't create plan")
            } else {
                PlanManager.shared.createYourPlan(namePlan: namePlan, startDate: startDate, endDate: endDate, note: note)
            }
            
            delegate?.didUpdateOrCreatePlan()
            clearTextField()
            pop(animated: true)
        } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 1 {
            guard let namePlan = self.namePlan, !namePlan.isEmpty else {
                showToast(message: "Please enter your plan's name")
                return
            }
            
            guard !MovieTopRateManager.shared.movieDefaultRealm.isEmpty else {
                showToast(message: "Please select at least one Movie/TV Show")
                return
            }
            
            let note = (collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ChooseMovieCVC)?.notePlanTV.text ?? ""
            let startDate = PlanManager.shared.startDate ?? plan?.startDate
            let endDate = PlanManager.shared.endDate ?? plan?.endDate
            let imageCover = MovieTopRateManager.shared.cacheCoverPlan
            if imageCover.isEmpty {
                image = plan?.image
            }
            
            PlanManager.shared.updateYourPlan(plan: plan, image: imageCover, namePlan: namePlan, startDate: startDate, endDate: endDate, note: note, movies: MovieTopRateManager.shared.movieDefaultRealm)
            delegate?.didUpdateOrCreatePlan()
            pop(animated: true)
            clearTextField()
        } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 2 {
            guard let namePlan = self.namePlan, !namePlan.isEmpty else {
                showToast(message: "Please enter your plan's name")
                return
            }
            
            guard !MovieTopRateManager.shared.movieDefaultRealm.isEmpty else {
                showToast(message: "Please select at least one Movie/TV Show")
                return
            }
            
            let note = (collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ChooseMovieCVC)?.notePlanTV.text ?? ""
            let startDate = PlanManager.shared.startDate ?? plan?.startDate
            let endDate = PlanManager.shared.endDate ?? plan?.endDate
            let imageCover = MovieTopRateManager.shared.cacheCoverPlan
            if imageCover.isEmpty {
                image = plan?.image
            }
            
            PlanManager.shared.updateYourPlan(plan: plan, image: imageCover, namePlan: namePlan, startDate: startDate, endDate: endDate, note: note, movies: MovieTopRateManager.shared.movieDefaultRealm)
            
            delegate?.didUpdateOrCreatePlan()
            pop(animated: true)
            clearTextField()
        }
        
    }
}

extension CreatePlanVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch CreatePlan.allCases[section] {
        case .editCover:
            return 1
        case .chooseMovie:
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CreatePlan.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch CreatePlan.allCases[indexPath.section] {
        case .editCover:
            if MovieTopRateManager.shared.checkEditOrCreatePlan == 0 {
                let cell = collectionView.dequeueCell(ofType: ChooseMovieCVC.self, indexPath: indexPath)
                if !MovieTopRateManager.shared.cacheCoverPlan.isEmpty {
                    cell.setUpCover(MovieTopRateManager.shared.cacheCoverPlan)
                } else {
                    cell.setUpNoCover()
                }
                cell.setUpTextField(startDate: startDate, endDate: endDate)
                cell.delegate = self
                return cell
            } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 1 {
                let cell = collectionView.dequeueCell(ofType: ChooseMovieCVC.self, indexPath: indexPath)
                if !MovieTopRateManager.shared.cacheCoverPlan.isEmpty {
                    cell.setUpCover(MovieTopRateManager.shared.cacheCoverPlan)
                } else if ((plan?.image) != ""){
                    cell.setUpCover(plan?.image ?? "")
                } else {
                    cell.setUpNoCover()
                }
                cell.showDataMovieEdit(plan!)
                cell.delegate = self
                return cell
            } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 2 {
                let cell = collectionView.dequeueCell(ofType: ChooseMovieCVC.self, indexPath: indexPath)
                if !MovieTopRateManager.shared.cacheCoverPlan.isEmpty {
                    cell.setUpCover(MovieTopRateManager.shared.cacheCoverPlan)
                } else if ((plan?.image) != ""){
                    cell.setUpCover(plan?.image ?? "")
                } else {
                    cell.setUpNoCover()
                }
                cell.showDataMovieEdit(plan!)
                cell.delegate = self
                return cell
            }
        case .chooseMovie:
            let cell = collectionView.dequeueCell(ofType: ChooseMovieBotCVC.self, indexPath: indexPath)
            // tạo mới
            if MovieTopRateManager.shared.checkEditOrCreatePlan == 0 {
                let movie = MovieTopRateManager.shared.movieDefaultRealm
                cell.setUpCell(dataMovie: movie, vc: self)
            } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 1 {
                // Sửa Plan
                cell.setUpCell(dataMovie: MovieTopRateManager.shared.movieDefaultRealm, vc: self)
                cell.planReceiveCreatePlan = self.plan
            } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 2 {
                // Detail
                cell.setUpCell(dataMovie: MovieTopRateManager.shared.movieDefaultRealm, vc: self)
                cell.planReceiveCreatePlan = plan
            }
            return cell
        }
        return UICollectionViewCell()
    }
}


extension CreatePlanVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 228
        
        switch CreatePlan.allCases[indexPath.section] {
        case .editCover:
            return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height / 1.36)
            
        case .chooseMovie:
            if MovieTopRateManager.shared.checkEditOrCreatePlan == 0 {
                let numberOfRow = ceil(CGFloat(MovieTopRateManager.shared.movieDefaultRealm.count) / 3)
                var minimumLineSpacing: CGFloat = 0
                
                if numberOfRow > 0 {
                    minimumLineSpacing = CGFloat((numberOfRow - 1) * 10)
                }
                
                let totalHeight = numberOfRow * height + minimumLineSpacing + 130
                return CGSize(width: collectionView.frame.width, height: totalHeight)
            } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 1 {
                let numberOfRow = ceil(CGFloat(MovieTopRateManager.shared.movieDefaultRealm.count) / 3)
                var minimumLineSpacing: CGFloat = 0
                
                if numberOfRow > 0 {
                    minimumLineSpacing = CGFloat((numberOfRow - 1) * 10)
                }
                
                let totalHeight = numberOfRow * height + minimumLineSpacing + 130
                return CGSize(width: collectionView.frame.width, height: totalHeight)
            } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 2 {
                let numberOfRow = ceil(CGFloat(MovieTopRateManager.shared.movieDefaultRealm.count) / 3)
                var minimumLineSpacing: CGFloat = 0
                
                if numberOfRow > 0 {
                    minimumLineSpacing = CGFloat((numberOfRow - 1) * 10)
                }
                
                let totalHeight = numberOfRow * height + minimumLineSpacing + 130
                return CGSize(width: collectionView.frame.width, height: totalHeight)
            }
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch CreatePlan.allCases[section] {
        case .editCover:
            return UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        case .chooseMovie:
            return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        }
    }
}

extension CreatePlanVC: ChooseMovieCVCDelegate {
    func showNamePlan(_ namePlan: String) {
        self.namePlan = namePlan
    }
    
    func didCreatePlan() {
        collectionView.reloadData()
    }
    
    func chooseBack() {
        clearTextField()
        pop(animated: true)
    }
    
    func chooseStartDate() {
        let vc = CalendarVC()
        vc.delegate = self
        vc.checkStartOrEndDateButton = true
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func chooseEndDate() {
        let vc = CalendarVC()
        vc.delegate = self
        vc.checkStartOrEndDateButton = false
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func chooseCover() {
        let vc = SuggestChooseVC()
        push(to: vc, animated: true)
        vc.screenHome = .chooseCover
        vc.planReceiveChooseMovieBot = self.plan
    }
}

extension CreatePlanVC: CalendarVCDelegate {
    func didSelectDate(_ date: Date) {
        collectionView.reloadData()
    }
    
    func reloadColectionViewCreatePlan() {
        collectionView.reloadData()
    }
}
