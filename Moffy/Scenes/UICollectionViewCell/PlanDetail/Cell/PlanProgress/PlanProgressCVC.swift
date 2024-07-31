//
//  PlanProgressCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 07/03/2024.
//

import UIKit

protocol PlanProgressCVCDelegate: AnyObject {
    func  showPlan(_ plan: PlanObject)
    func didSelectedProgress()
}

class PlanProgressCVC: BaseCollectionViewCell {
    
    @IBOutlet weak var viewTextView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var notePlanTV: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var totalMovieLbl: UILabel!
    @IBOutlet weak var totalDoneMovieLbl: UILabel!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var namePlan: UILabel!
    
    enum SectionType: Int, CaseIterable {
        case first
        case second
        case third
        case fourth
    }
    
    var twoDimensionalArray: [[MovieObject]] = []
    var dataMovies: [MovieObject] = []
    var plan: PlanObject?
    let sectionHeight: CGFloat = 80
    weak var delegate: PlanProgressCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveMovie), name: Notification.Name("DidRemoveMovie"), object: nil)
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: ProgressCell.self)
        heightCollectionView.constant = collectionViewHeight()
        progressView.cornerRadius = 4
        notePlanTV.isEditable = false
    }
    
    @objc func didRemoveMovie() {
        collectionView.reloadData()
    }
    
    
    func splitArrayIntoChunks(_ array: [MovieObject]) -> [[MovieObject]] {
        var chunks: [[MovieObject]] = []
        var chunk: [MovieObject] = []
        
        for (index, movie) in array.enumerated() {
            chunk.append(movie)
            
            if chunk.count == 5 || index == array.count - 1 {
                if chunks.count % 2 == 1 {
                    chunk.reverse()
                }
                chunks.append(chunk)
                chunk = []
            }
        }
        
        return chunks
    }
    
    private func setUpDataMovie(dataMovies: [MovieObject]) {
        self.dataMovies = dataMovies
        twoDimensionalArray = splitArrayIntoChunks(dataMovies)
        heightCollectionView.constant = collectionViewHeight()
        collectionView.reloadData()
    }
    
    func configDataPlan(_ plan: PlanObject) {
        namePlan.text = plan.namePlan
        totalTimeLbl.text = "6h45m"
        totalMovieLbl.text = "\(plan.movies.count)"
        startDateLbl.text = "\(plan.startDate?.asStringDate() ?? "mm/dd")"
        endDateLbl.text = "\(plan.endDate?.asStringDate() ?? "mm/dd")"
        getTotalMovieDone(plan)
        
        let arrayMovies = RealmService.shared.convertToArray(list: plan.movies)
        setUpDataMovie(dataMovies: arrayMovies)
        
        let noteTitleAttributedString = NSMutableAttributedString(string: "Notes: ")
        let noteTitleRange = NSRange(location: 0, length: noteTitleAttributedString.length)
        noteTitleAttributedString.addAttribute(.foregroundColor, value: UIColor(rgb: 0x00C3AC), range: noteTitleRange)
        noteTitleAttributedString.addAttribute(.font, value: AppFont.get(fontName: .manaropeRegular, size: 12), range: noteTitleRange)
        
        let noteContentAttributedString = NSAttributedString(string: "\(plan.note ?? "")", attributes: [.foregroundColor: UIColor.white, .font: AppFont.get(fontName: .manaropeRegular, size: 10)])
        
        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(noteTitleAttributedString)
        combinedAttributedString.append(noteContentAttributedString)
        
        notePlanTV.attributedText = combinedAttributedString
        collectionView.reloadData()
    }
    
    func getTotalMovieDone(_ plan: PlanObject) {
        let doneMovieCount = plan.movies.filter({ $0.isDone == true }).count
        let percentage = Float(doneMovieCount) / Float(plan.movies.count)
        progressView.progress = percentage
        if plan.movies.count == 0 {
            progressView.progress = 0
        }
        totalDoneMovieLbl.text = "\(doneMovieCount)/"
        collectionView.reloadData()
    }
    
    func collectionViewHeight() -> CGFloat {
        let totalHeight = sectionHeight * CGFloat(twoDimensionalArray.count)
        return totalHeight
    }
    
}
extension PlanProgressCVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return twoDimensionalArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsInSection = twoDimensionalArray[section].count
        return itemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section < twoDimensionalArray.count else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueCell(ofType: ProgressCell.self, indexPath: indexPath)
        cell.delegate = self
        let movie = twoDimensionalArray[indexPath.section][indexPath.item]
        cell.configProgress(movie)
        //cell.showMovieDone(movie)
        
        let numberOfSection = numberOfSections(in: self.collectionView)
        
        switch indexPath.section {
        case 0:
            let lastIndex = collectionView.numberOfItems(inSection: 0) - 1
            if lastIndex == 0 {
                cell.hideLineBot()
                cell.hideLineTop()
                cell.hideLineLeft()
                cell.hideLineRight()
            }else if numberOfSection < 2 {
                if indexPath.row == lastIndex {
                    cell.hideLineBot()
                    cell.hideLineTop()
                    cell.hideLineRight()
                } else if indexPath.row == 0 {
                    cell.hideLineTop()
                    cell.hideLineBot()
                    cell.hideLineLeft()
                } else {
                    cell.hideLineBot()
                    cell.hideLineTop()
                }
            } else {
                if indexPath.row == lastIndex {
                    cell.hideLineTop()
                    cell.hideLineRight()
                } else if indexPath.row == 0 {
                    cell.hideLineTop()
                    cell.hideLineBot()
                    cell.hideLineLeft()
                } else {
                    cell.hideLineBot()
                    cell.hideLineTop()
                }
            }
            
        case 1:
            let lastIndex = collectionView.numberOfItems(inSection: 1) - 1
            if lastIndex == 0 {
                cell.hideLineLeft()
                cell.hideLineBot()
                cell.hideLineRight()
            } else if numberOfSection < 3 {
                if indexPath.row == lastIndex {
                    cell.hideLineBot()
                    cell.hideLineRight()
                } else if indexPath.row == 0 {
                    cell.hideLineTop()
                    cell.hideLineBot()
                    cell.hideLineLeft()
                } else {
                    cell.hideLineBot()
                    cell.hideLineTop()
                }
            } else {
                if indexPath.row == lastIndex {
                    cell.hideLineBot()
                    cell.hideLineRight()
                } else if indexPath.row == 0 {
                    cell.hideLineTop()
                    cell.hideLineLeft()
                } else {
                    cell.hideLineBot()
                    cell.hideLineTop()
                }
            }
            
        case 2:
            let lastIndex = collectionView.numberOfItems(inSection: 2) - 1
            if lastIndex == 0 {
                cell.hideLineBot()
                cell.hideLineLeft()
                cell.hideLineRight()
            } else if numberOfSection < 4 {
                if indexPath.row == lastIndex {
                    cell.hideLineBot()
                    cell.hideLineTop()
                    cell.hideLineRight()
                } else if indexPath.row == 0 {
                    cell.hideLineBot()
                    cell.hideLineLeft()
                } else {
                    cell.hideLineBot()
                    cell.hideLineTop()
                }
            } else {
                if indexPath.row == lastIndex {
                    cell.hideLineTop()
                    cell.hideLineRight()
                } else if indexPath.row == 0 {
                    cell.hideLineBot()
                    cell.hideLineLeft()
                } else {
                    cell.hideLineBot()
                    cell.hideLineTop()
                }
            }
        case 3:
            let lastIndex = collectionView.numberOfItems(inSection: 3) - 1
            if lastIndex == 0 {
                cell.hideLineRight()
                cell.hideLineBot()
                cell.hideLineLeft()
            } else if numberOfSection < 3 {
                if indexPath.row == lastIndex {
                    cell.hideLineBot()
                    cell.hideLineRight()
                } else if indexPath.row == 0 {
                    cell.hideLineTop()
                    cell.hideLineBot()
                    cell.hideLineLeft()
                } else {
                    cell.hideLineBot()
                    cell.hideLineTop()
                }
            } else {
                if indexPath.row == lastIndex {
                    cell.hideLineBot()
                    cell.hideLineRight()
                } else if indexPath.row == 0 {
                    cell.hideLineTop()
                    cell.hideLineLeft()
                    cell.hideLineBot()
                } else {
                    cell.hideLineBot()
                    cell.hideLineTop()
                }
            }
        default:
            break
        }
        if movie.isDone {
            cell.lineTopDone()
            cell.lineBotDone()
            cell.lineLeftDone()
            cell.lineRightDone()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5 - 0.1, height: 80)
    }
}

extension PlanProgressCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section % 2 == 0  {
            return .zero
        } else {
            let widthItem = (self.collectionView.frame.width) / 5
            let left = widthItem * CGFloat((5 - self.twoDimensionalArray[section].count))
            return UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension PlanProgressCVC: ProgressCellDelegate {
    func didSetDoneMovie(_ movie: MovieObject) {
        guard let plan = plan else {
            return
        }
        PlanManager.shared.setDoneMovie(with: movie, plan: plan)
        delegate?.didSelectedProgress()
    }

}
