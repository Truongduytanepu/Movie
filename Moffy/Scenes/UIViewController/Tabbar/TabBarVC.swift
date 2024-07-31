

import UIKit

enum TabBar: Int, CaseIterable {
    case First
    case Second
    case Thirde
    case Fourth
    case Fifth
    
    func image() -> UIImage? {
        switch self {
        case .First:
            return UIImage(named: "HomeChoose")
        case .Second:
            return UIImage(named: "Movie")
        case .Thirde:
            return UIImage()
        case .Fourth:
            return UIImage(named: "TVShow")
        case .Fifth:
            return UIImage(named: "Selfie")
        }
    }
}

class TabBarVC: BaseViewController {
    @IBOutlet private weak var viewFirstItem: UIView!
    @IBOutlet private weak var viewSecondItem: UIView!
    @IBOutlet private weak var viewThirdeItem: UIView!
    @IBOutlet private weak var viewFourthItem: UIView!
    @IBOutlet private weak var viewFifthItem: UIView!
    
    @IBOutlet private weak var imageFirstItem: UIImageView!
    @IBOutlet private weak var imageSecondItem: UIImageView!
    @IBOutlet private weak var imageThirdeItem: UIImageView!
    @IBOutlet private weak var imageFourthItem: UIImageView!
    @IBOutlet private weak var imageFifthItem: UIImageView!
    
    @IBOutlet private weak var labelFirstItem: UILabel!
    @IBOutlet private weak var labelSecondItem: UILabel!
    @IBOutlet private weak var labelThirdeItem: UILabel!
    @IBOutlet private weak var labelFourthItem: UILabel!
    @IBOutlet private weak var labelFifthItem: UILabel!
    @IBOutlet weak var customTabBar: UIView!
    
    private let homeViewController = SuggestPlanVC()
    private let movieController = MovieVC()
    private let tvShowViewController = TvShowVC()
    private let selfieViewController = SelfieSearchVC()
    private var isShowArlert = false
    private let homeImageChoose = UIImage(named: "HomeChoose")
    private let homeImage = UIImage(named: "Home")
    private let movieImageChoose = UIImage(named: "MovieChoose")
    private let movieImage = UIImage(named: "Movie")
    private let tvImageChoose = UIImage(named: "TVShowChoose")
    private let tvImage = UIImage(named: "TVShow")
    private let selfieImageChoose = UIImage(named: "SelfieChoose")
    private let selfieImage = UIImage(named: "Selfie")
    private let buttonCamera : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        btn.setTitle("", for: .normal)
        btn.backgroundColor = .clear
        btn.layer.shadowOpacity = 0.12
        btn.layer.shadowOffset = CGSize(width: 1, height: -2)
        btn.setBackgroundImage(UIImage(named: "AddButtoon"), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.buttonCamera.frame = CGRect(x: Int(self.customTabBar.bounds.width)/2 - 30,
                                             y: -Int(self.customTabBar.bounds.height)/2 , width: 60, height: 60)
            self.customTabBar.addSubview(self.buttonCamera)
            self.buttonCamera.addTarget(self, action: #selector(self.buttonCameraTapped), for: .touchUpInside)
            //            self.view.backgroundColor = .clear
        }
        setItemTabBar()
        
        let sender = UIButton()
        sender.tag = 0
        tabButtonTapped(sender)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCustomTabBar()
    }
    
    func setItemTabBar() {
        let items = TabBar.allCases
        for (index, item) in items.enumerated() {
            
            if let image = view.viewWithTag(index+6) as? UIImageView {
                image.image = item.image()
            }
        }
    }
    
    @IBAction private func tabButtonTapped(_ sender: UIButton) {
        let handleTabCase: (UIViewController?, UIImage?, UIImage?, UIImage?, UIImage?) -> Void = { [weak self] viewController, firstImage, secondImage, fourthImage, fifthImage in
            if self?.isNetworkConnected == true {
                self?.showTab(viewController ?? UIViewController())
                self?.imageFirstItem.image = firstImage
                self?.imageSecondItem.image = secondImage
                self?.imageFourthItem.image = fourthImage
                self?.imageFifthItem.image = fifthImage
            } else {
                self?.showAlert(title: "No Internet", message: "Please connect inernet")
            }
        }
        
        switch TabBar.allCases[sender.tag] {
        case .First:
            handleTabCase(homeViewController, homeImageChoose, movieImage, tvImage, selfieImage)
        case .Second:
            handleTabCase(movieController, homeImage, movieImageChoose, tvImage, selfieImage)
        case .Thirde:
            break
        case .Fourth:
            handleTabCase(tvShowViewController, homeImage, movieImage, tvImageChoose, selfieImage)
        case .Fifth:
            handleTabCase(selfieViewController, homeImage, movieImage, tvImage, selfieImageChoose)
        }
    }
    
    // Hàm hiển thị tab được chọn
    func showTab(_ viewController: UIViewController) {
        let bottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? .zero
        for childViewController in children {
            childViewController.view.removeFromSuperview()
            childViewController.removeFromParent()
        }
        
        addChild(viewController)
        let heightVC = view.bounds.height - customTabBar.bounds.height + 15
        viewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: heightVC)
        
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        view.bringSubviewToFront(customTabBar)
    }
    
    private func setupCustomTabBar() {
        let path : UIBezierPath = getPathForTabBar()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 1
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.black.cgColor
        customTabBar.layer.insertSublayer(shape, at: 0)
        customTabBar.backgroundColor = UIColor.clear
    }
    
    private func getPathForTabBar() -> UIBezierPath {
        // Kích thước của tab bar
        let frameWidth = customTabBar.bounds.width
        let frameHeight = customTabBar.bounds.height
        
        let cornerRadius: CGFloat = 25
        
        // Tạo đường path
        let path : UIBezierPath = UIBezierPath()
        
        // Start Point
        path.move(to: CGPoint(x: 30, y: 0))
        
        // cornerRadius top Right
        path.addLine(to: CGPoint(x: frameWidth - cornerRadius, y: 0))
        path.addArc(withCenter: CGPoint(x: frameWidth - cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: -CGFloat.pi/2,
                    endAngle: 0,
                    clockwise: true)
        // point bottom right
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight))
        
        // point bottom left
        path.addLine(to: CGPoint(x: 0, y: frameHeight))
        
        // cornerRadius top left
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: CGFloat.pi,
                    endAngle: -CGFloat.pi/2,
                    clockwise: true)
        path.close()
        
        return path
    }
    
    @objc private func buttonCameraTapped() {
        if isNetworkConnected {
            let createPlan = CreatePlanVC()
            push(to: createPlan, animated: true)
            MovieTopRateManager.shared.checkEditOrCreatePlan = 0
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
}
