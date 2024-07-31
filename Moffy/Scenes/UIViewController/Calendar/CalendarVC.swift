//
//  CalendarVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 05/03/2024.
//

import UIKit
import FSCalendar
import CustomBlurEffectView

protocol CalendarVCDelegate: AnyObject {
    func reloadColectionViewCreatePlan()
}

class CalendarVC: BaseViewController {
    
    @IBOutlet weak var viewMonth: UIView!
    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var yearBtnViewMonth: UIButton!
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var collectionViewMonth: UICollectionView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var cancleBtn: UIButton!
    
    private var currentPage: Date?
    private var firstYear: Int?
    private var endyear: Int?
    private var selectedIndexPath: IndexPath?
    private var monthArr: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    private var yearArr: [String] = []
    private var yearOrMonth: [String] = []
    private let selectedColor = UIColor(red: 128 / 255.0, green: 229 / 255.0, blue: 224 / 255.0, alpha: 1)
    private var monthSelected = 1
    private var checkMonthOrYear: Bool = true
    private var rightMonth = 0
    private var leftMonth = 0
    private var month: Int?
    private var yearSelected: Int?
    private var startDateSelected: Date?
    private var endDateSelected: Date?
    
    var checkStartOrEndDateButton: Bool?
    var delegate: CalendarVCDelegate?
    
    private lazy var today: Date = {
        return Date()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalender()
        updateMonthAndYear()
        setUpCollectionView()
        viewMonth.isHidden = true
        viewMonth.layer.cornerRadius = 23
        setUpBlur()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateYearViewMonth()
        self.month = self.currentPage?.getMonth()
    }
    
    private func setUpCollectionView(){
        collectionViewMonth.delegate = self
        collectionViewMonth.dataSource = self
        collectionViewMonth.registerNib(ofType: MonthCVC.self)
    }
    
    private func moveCurrentPageMonth(moveUp: Bool) {
        let calendarView = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1
        self.currentPage = calendarView.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        calendar.setCurrentPage(self.currentPage!, animated: true)
        self.updateMonthAndYear()
    }
    
    private func moveCurrentPageYear(moveUp: Bool) {
        let calendarView = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = moveUp ? 1 : -1
        self.currentPage = calendarView.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        calendar.setCurrentPage(self.currentPage!, animated: true)
        self.updateYearViewMonth()
        self.updateMonthAndYear()
    }
    
    private func setUpBlur() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            let customBlurEffectView = CustomBlurEffectView(
                radius: 20,
                color: UIColor.black
            )
            customBlurEffectView.frame = self.view.bounds
            self.view.insertSubview(customBlurEffectView, at: 0)
            customBlurEffectView.alpha = 0.9
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
            customBlurEffectView.addGestureRecognizer(tapgesture)
        }
    }
    
    private func setUpCalender() {
        calendar.delegate = self
        calendar.firstWeekday = 2
        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.weekdayTextColor = UIColor.black
        calendar.appearance.selectionColor = selectedColor
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.borderRadius = 0.4
        calendar.appearance.todayColor = UIColor.white
        calendar.headerHeight = 0
        month = self.currentPage?.getMonth()
        self.viewMain.layer.cornerRadius = 23
        cancleBtn.contentMode = .scaleToFill
    }
    
    private func updateYearViewMonth() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYear = dateFormatter.string(from: self.currentPage ?? Date())
        
        yearBtnViewMonth.setTitle(currentYear, for: .normal)
    }
    
    private func updateMonth(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        
        dateFormatter.dateFormat = "MMMM"
        let monthString = dateFormatter.string(from: self.currentPage ?? Date())
        monthBtn.setTitle(monthString, for: .normal)
    }
    
    private func updateMonthAndYear() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        
        dateFormatter.dateFormat = "MMMM"
        let monthString = dateFormatter.string(from: self.currentPage ?? Date())
        
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: self.currentPage ?? Date())
        
        monthBtn.setTitle(monthString, for: .normal)
        yearBtn.setTitle(yearString, for: .normal)
    }
    
    @objc func viewTapped(_ gesture: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func leftBtn(_ sender: Any) {
        self.moveCurrentPageMonth(moveUp: false)
    }
    
    @IBAction func rightBtn(_ sender: Any) {
        self.moveCurrentPageMonth(moveUp: true)
    }
    
    @IBAction func monthChoose(_ sender: Any) {
        self.viewMonth.isHidden = false
        self.yearOrMonth = monthArr
        self.doneBtn.setBackgroundImage(UIImage(named: "Frame 2610278"), for: .normal)
        self.collectionViewMonth.reloadData()
    }
    
    @IBAction func leffBtnViewMonth(_ sender: Any) {
        if yearOrMonth == monthArr{
            self.moveCurrentPageYear(moveUp: false)
        }else{
            firstYear = (firstYear ?? 2000) - 12
            endyear = (endyear ?? 2000) - 12
            yearBtnViewMonth.setTitle("\(firstYear ?? 2000) - \(endyear ?? 2011)", for: .normal)
        }
    }
    
    @IBAction func rightBtnViewMonth(_ sender: Any) {
        if yearOrMonth == monthArr{
            self.moveCurrentPageYear(moveUp: true)
        }else{
            firstYear = (firstYear ?? 2000) + 12
            endyear = (endyear ?? 2000) + 12
            yearBtnViewMonth.setTitle("\(firstYear ?? 2000) - \(endyear ?? 2011)", for: .normal)
        }
        
    }
    
    @IBAction func doneHandle(_ sender: Any) {
        let vc = CreatePlanVC()
        if let startDate = startDateSelected {
            vc.startDate = startDate
            PlanManager.shared.startDate = startDateSelected
        }
        
        if let endDate = endDateSelected {
            vc.endDate = endDate
            PlanManager.shared.endDate = endDateSelected
        }
        
        delegate?.reloadColectionViewCreatePlan()
        push(to: vc, animated: true)
    }
    
    @IBAction func canleHandle(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func yearBtnHandle(_ sender: Any) {
        self.viewMonth.isHidden = false
        self.checkMonthOrYear = false
        self.doneBtn.setBackgroundImage(UIImage(named: "Frame 2610278"), for: .normal)
        
        for i in 2000...2100 {
            yearArr.append("\(i)")
        }
        
        self.yearOrMonth = yearArr
        
        firstYear = 2000
        endyear = 2011
        
        yearBtnViewMonth.setTitle("\(firstYear ?? 2000) - \(endyear ?? 2011)", for: .normal)
        
        self.collectionViewMonth.reloadData()
    }
}


extension CalendarVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        collectionViewMonth.reloadData()
        if checkStartOrEndDateButton ?? true{
            if let endDate = PlanManager.shared.endDate {
                if date > endDate  {
                    showToast(message: "Please select a date less than the end plan")
                    self.doneBtn.setBackgroundImage(UIImage(named: "doneDefault"), for: .normal)
                } else {
                    startDateSelected = date
                    self.doneBtn.setBackgroundImage(UIImage(named: "doneClick"), for: .normal)
                }
            } else {
                startDateSelected = date
                self.doneBtn.setBackgroundImage(UIImage(named: "doneClick"), for: .normal)
            }
        } else {
            if let startDate = PlanManager.shared.startDate {
                if date < startDate  {
                    showToast(message: "Please select a date greater than the start plan")
                    self.doneBtn.setBackgroundImage(UIImage(named: "doneDefault"), for: .normal)
                } else {
                    endDateSelected = date
                    self.doneBtn.setBackgroundImage(UIImage(named: "doneClick"), for: .normal)
                }
            } else {
                endDateSelected = date
                self.doneBtn.setBackgroundImage(UIImage(named: "doneClick"), for: .normal)
            }
        }
        
    }
}

extension CalendarVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yearOrMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: MonthCVC.self, indexPath: indexPath)
        let month = yearOrMonth[indexPath.row]
        cell.monthLbl.text = month
        cell.viewMonth.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CalendarVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 66.75, height: 72)
    }
}

extension CalendarVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MonthCVC else {
            return
        }
        
        cell.viewMonth.backgroundColor = selectedColor
        cell.monthLbl.textColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.viewMonth.isHidden = true
            cell.viewMonth.backgroundColor = .white
            cell.monthLbl.textColor = .black
        }
        
        month = self.currentPage?.getMonth() ?? self.today.getMonth()
        
        if checkMonthOrYear {
            if month! > indexPath.row + 1{
                let calendarView = Calendar.current
                var dateComponents = DateComponents()
                leftMonth = -(month! - indexPath.row - 1)
                dateComponents.month = leftMonth
                self.currentPage = calendarView.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
                calendar.setCurrentPage(self.currentPage!, animated: true)
                self.updateMonthAndYear()
                self.updateYearViewMonth()
                leftMonth = 0
            }
            if month! < indexPath.row + 1{
                let calendarView = Calendar.current
                var dateComponents = DateComponents()
                rightMonth = indexPath.row + 1 - month!
                dateComponents.month = rightMonth
                self.currentPage = calendarView.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
                calendar.setCurrentPage(self.currentPage!, animated: true)
                self.updateMonthAndYear()
                self.updateYearViewMonth()
                
                rightMonth = 0
            }
        }else{
            let calendarView = Calendar.current
            var dateComponents = DateComponents()
            let yearAfter = Int(yearOrMonth[indexPath.item])! - (currentPage?.getYear() ?? today.getYear())
            dateComponents.year = yearAfter
            self.currentPage = calendarView.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
            calendar.setCurrentPage(self.currentPage!, animated: true)
            self.updateMonthAndYear()
            self.updateYearViewMonth()
            checkMonthOrYear = true
        }
    }
}

