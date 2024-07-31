//
//  ProgressCell.swift
//  Moffy
//
//  Created by Trương Duy Tân on 01/03/2024.
//

import UIKit

protocol ProgressCellDelegate: AnyObject {
    func didSetDoneMovie(_ movie: MovieObject)
}

class ProgressCell: BaseCollectionViewCell {
    
    @IBOutlet weak var imageCheckBox: UIImageView!
    @IBOutlet weak var lineLeft: UIImageView!
    @IBOutlet weak var lineRight: UIImageView!
    @IBOutlet weak var lineBot: UIImageView!
    @IBOutlet weak var lineTop: UIImageView!
    @IBOutlet weak var nameMovieLbl: UILabel!
    
    var isLeftLineDone: Bool = false
    var isRightLineDone: Bool = false
    var isTopLineDone: Bool = false
    var isBotLineDone: Bool = false
    private var movie: MovieObject?
    private var plan: PlanObject?
    
    weak var delegate: ProgressCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        self.imageCheckBox.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckBox(_:)))
        self.imageCheckBox.addGestureRecognizer(tapGesture)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showAllLine()
    }
    
    func configProgress(_ movie: MovieObject) {
        if movie.name != nil && movie.title == nil || movie.title == ""{
            nameMovieLbl.text = movie.name
        }
        
        if movie.title != nil && movie.name == nil || movie.name == ""{
            nameMovieLbl.text = movie.title
        }
        self.movie = movie
        
        if movie.isDone {
            lineLeft.image = UIImage(named: "LineDone")
            lineRight.image = UIImage(named: "LineDone")
            imageCheckBox.image = UIImage(named: "CheckBoxDone")
            lineTop.image = UIImage(named: "LineShotDone")
            lineBot.image = UIImage(named: "LineShotDone")
            
        }else {
            imageCheckBox.image = UIImage(named: "UnCheck")
            lineLeft.image = UIImage(named: "LineCell")
            lineRight.image = UIImage(named: "LineCell")
            lineTop.image = UIImage(named: "LineShot")
            lineBot.image = UIImage(named: "LineShot")
           
        }
    }
    
    func setDoneMovie(with plan: PlanObject, movieObject: MovieObject) {
        let planItem = RealmService.shared.getById(ofType: PlanObject.self, id: plan.id)
        RealmService.shared.updatePlan(item: planItem, movieObject: movieObject)
    }
    
    func showMovieDone(_ movie: MovieObject) {
        if movie.isDone {
            imageCheckBox.image = UIImage(named: "CheckBoxDone")
        } else {
            imageCheckBox.image = UIImage(named: "UnCheck")
        }
    }
    
    func showAllLine() {
        lineLeft.isHidden = false
        lineRight.isHidden = false
        lineBot.isHidden = false
        lineTop.isHidden = false
        imageCheckBox.image = UIImage(named: "UnCheck")
    }
    
    func showAllLineDone() {
//        lineLeft.image = UIImage(named: "LineDone")
//        lineRight.image = UIImage(named: "LineDone")
//        lineTop.image = UIImage(named: "LineShotDone")
//        lineBot.image = UIImage(named: "LineShotDone")
    }
    
    func hideLineLeft() {
        lineLeft.isHidden = true
    }
    
    func showLineTop() {
        lineTop.isHidden = false
    }
    
    func showLineBot() {
        lineBot.isHidden = false
    }
    
    func showLineLeft() {
        lineLeft.isHidden = false
        
    }
    
    func showLineRight() {
        lineRight.isHidden = false
        //lineRight.image = UIImage(named: "LineCell")
    }
    
    func hideLineRight() {
        lineRight.isHidden = true
        //lineRight.image = UIImage(named: "LineDone")
    }
    func hideLineBot() {
        lineBot.isHidden = true
    }
    func hideLineTop() {
        lineTop.isHidden = true
    }
    
    func lineLeftDone() {
        isLeftLineDone = true
        //lineLeft.image = UIImage(named: "LineDone")
    }
    
    func lineRightDone() {
        isRightLineDone = true
        //lineRight.image = UIImage(named: "LineDone")
    }
    
    func lineTopDone() {
        isTopLineDone = true
        //lineTop.image = UIImage(named: "LineShotDone")
    }
    
    func lineBotDone() {
        isBotLineDone = true
        //lineBot.image = UIImage(named: "LineShotDone")
    }
    
}


extension ProgressCell {
    @objc private func didTapCheckBox(_ sender: UITapGestureRecognizer) {
        guard let movie = movie else {
            return
        }
        delegate?.didSetDoneMovie(movie)
    }
}
