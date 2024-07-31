//
//  RatingVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 16/04/2024.
//

import UIKit

class RatingVC: BaseViewController {
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star1: UIButton!
    
    private var starUnFill = UIImage(named: "StarUnFill")
    private var starFill = UIImage(named: "StarFill")
    private var selectedStar: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        pop(animated: true)
    }
    
    
    @IBAction func star1BtnTapped(_ sender: Any) {
        selectStar(star: 1)
    }
    
    @IBAction func star2BtnTapped(_ sender: Any) {
        selectStar(star: 2)
    }
    
    @IBAction func star3BtnTapped(_ sender: Any) {
        selectStar(star: 3)
    }
    
    @IBAction func star4BtnTapped(_ sender: Any) {
        selectStar(star: 4)
    }
    
    @IBAction func star5BtnTapped(_ sender: Any) {
        selectStar(star: 5)
    }
    
    private func selectStar(star: Int) {
        selectedStar = star
        star1.setBackgroundImage(starUnFill, for: .normal)
        star2.setBackgroundImage(starUnFill, for: .normal)
        star3.setBackgroundImage(starUnFill, for: .normal)
        star4.setBackgroundImage(starUnFill, for: .normal)
        star5.setBackgroundImage(starUnFill, for: .normal)
        switch star {
        case 1:
            star1.setBackgroundImage(starFill, for: .normal)
            star2.setBackgroundImage(starUnFill, for: .normal)
            star3.setBackgroundImage(starUnFill, for: .normal)
            star4.setBackgroundImage(starUnFill, for: .normal)
            star5.setBackgroundImage(starUnFill, for: .normal)
        case 2:
            star1.setBackgroundImage(starFill, for: .normal)
            star2.setBackgroundImage(starFill, for: .normal)
            star3.setBackgroundImage(starUnFill, for: .normal)
            star4.setBackgroundImage(starUnFill, for: .normal)
            star5.setBackgroundImage(starUnFill, for: .normal)
        case 3:
            star1.setBackgroundImage(starFill, for: .normal)
            star2.setBackgroundImage(starFill, for: .normal)
            star3.setBackgroundImage(starFill, for: .normal)
            star4.setBackgroundImage(starUnFill, for: .normal)
            star5.setBackgroundImage(starUnFill, for: .normal)
        case 4:
            star1.setBackgroundImage(starFill, for: .normal)
            star2.setBackgroundImage(starFill, for: .normal)
            star3.setBackgroundImage(starFill, for: .normal)
            star4.setBackgroundImage(starFill, for: .normal)
            star5.setBackgroundImage(starUnFill, for: .normal)
        case 5:
            star1.setBackgroundImage(starFill, for: .normal)
            star2.setBackgroundImage(starFill, for: .normal)
            star3.setBackgroundImage(starFill, for: .normal)
            star4.setBackgroundImage(starFill, for: .normal)
            star5.setBackgroundImage(starFill, for: .normal)
        default:
            break
        }
    }
    
    private func back() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.pop(animated: true)
        }
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        if selectedStar >= 4 {
            if let url = URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID?action=write-review") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            back()
        } else if selectedStar == 0 {
            showToast(message: "Please rate app")
        } else {
            showToast(message: "Thank for rate")
            back()
        }
    }
    
    @IBAction func cancleBtnTapped(_ sender: Any) {
        pop(animated: true)
    }
}
