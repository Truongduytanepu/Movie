//
//  CameraVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 18/04/2024.
//

import UIKit
import Combine
import CameraManager
import SnapKit
import Photos

class CameraVC: BaseViewController {
    static var isFlashOff = PassthroughSubject<Bool, Never>()
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var changeCameraBtn: UIButton!
    @IBOutlet weak var chooseFrameBtn: UIButton!
    @IBOutlet weak var noteBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var frameView: FrameView!
    @IBOutlet weak var flashBtn: UIButton!
    
    private lazy var cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var isFirstAppearance = false
    private var imageBorder: Bool = false
    private var textBorder: Bool = false
    private var isTextShadow: Bool = false
    private var borderTextFrame2: Bool = false
    private var imageReceiveCameraFilter: UIImage?
    private let listFrame: [BaseFrame] = [Frame1(), Frame2(), Frame3(), Frame4(), Frame5()]
    private var indexPathSelected: Int?
    var movieSelected: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addComponents()
        self.setConstraints()
        self.setProperties()
        self.frameView.changeTitle(self.movieSelected?.title,
                                   isBoderText: textBorder,
                                   isTextShadow: isTextShadow)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CameraManager.shared.flashState = false
        if CameraManager.shared.flashState == false {
            self.flashBtn.setImage(UIImage(named: "FlashOff"), for: .normal)
        }
        CameraManager.shared.start()
        DispatchQueue.main.async {
            self.changeFrame(self.listFrame[self.indexPathSelected ?? 0])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIScreen.main.brightness = 0.5
        self.changeFrame(self.listFrame[indexPathSelected ?? 0])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CameraManager.shared.stopCamera()
    }
    
    override func addComponents() {
        self.containerView.insertSubview(self.cameraImageView, belowSubview: self.frameView)
        self.containerView.insertSubview(self.frameView.posterImageView, belowSubview: self.frameView)
    }
    
    override func setProperties() {
    }
    
    override func binding() {
        CameraVC.isFlashOff
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFlashOff in
                guard let self else {
                    return
                }
                if isFlashOff {
                    self.flashBtn.setImage(UIImage(named: "FlashOff"), for: .normal)
                    UIScreen.main.brightness = 0.5
                }
            }.store(in: &subscriptions)
        
        CameraManager.shared.$captureImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] captureImage in
                guard let self else {
                    return
                }
                cameraImageView.image = captureImage
            }.store(in: &subscriptions)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        FavoriteMovieManager.shared.address = ""
        pop(animated: true)
    }
    
    @IBAction func flashBtnTapped(_ sender: Any) {
        CameraManager.shared.switchFlash()
        DispatchQueue.main.async {
            switch CameraManager.shared.flashState {
            case true:
                self.flashBtn.setImage(UIImage(named: "Flash"), for: .normal)
            case false:
                self.flashBtn.setImage(UIImage(named: "FlashOff"), for: .normal)
            }
        }
    }
    
    @IBAction func chooseFrameBtnTapped(_ sender: Any) {
        let vc = CameraFilterVC()
        vc.selectedIndexPath = { [weak self] selectedIndex in
            DispatchQueue.main.async {
                self?.indexPathSelected = selectedIndex
                switch selectedIndex {
                case 0:
                    self?.textBorder = false
                    self?.imageBorder = false
                    self?.isTextShadow = false
                case 1:
                    self?.imageBorder = true
                    self?.textBorder = true
                    self?.isTextShadow = false
                case 2:
                    self?.isTextShadow = true
                    self?.imageBorder = false
                    self?.textBorder = false
                case 4:
                    self?.imageBorder = false
                    self?.textBorder = true
                    self?.isTextShadow = false
                default:
                    self?.textBorder = false
                    self?.imageBorder = false
                    self?.isTextShadow = false
                }
            }
        }
        push(to: vc, animated: true)
    }
    
    @IBAction func popUpAdressBtnTapped(_ sender: Any) {
        let childVC = AddressVC()
        childVC.didSetAddress = { [weak self] _ in
            self?.frameView.changeAddress(FavoriteMovieManager.shared.address, isBorder: self?.textBorder ?? false)
        }
        self.addSubViewController(childVC)
    }
    
    @IBAction func takePhotoBtnTapped(_ sender: Any) {
        backBtn.isEnabled = false
        flashBtn.isEnabled = false
        chooseFrameBtn.isEnabled = false
        noteBtn.isEnabled = false
        changeCameraBtn.isEnabled = false
        takePhotoBtn.isEnabled = false
        
        self.creatMergeImage()
        
        DispatchQueue.main.async {
            self.backBtn.isEnabled = true
            self.flashBtn.isEnabled = true
            self.chooseFrameBtn.isEnabled = true
            self.noteBtn.isEnabled = true
            self.changeCameraBtn.isEnabled = true
            self.takePhotoBtn.isEnabled = true
        }
    }
    
    @IBAction func chaneCameraBtnTapped(_ sender: Any) {
        CameraManager.shared.switchPosition()
    }
}

extension CameraVC {
    func changeFrame(_ newFrame: BaseFrame) {
        self.frameView.changeFrame(newFrame)
        
        if self.imageBorder {
            self.frameView.changePoster(self.movieSelected?.posterPath ?? "", isBorder: true)
        } else {
            self.frameView.changePoster(self.movieSelected?.posterPath ?? "", isBorder: false)
        }
        
        if textBorder {
            self.frameView.changeTitle(self.movieSelected?.title,
                                       isBoderText: true,
                                       isTextShadow: false)
        } else if isTextShadow {
            self.frameView.changeTitle(self.movieSelected?.title,
                                       isBoderText: false,
                                       isTextShadow: true)
        } else {
            self.frameView.changeTitle(self.movieSelected?.title,
                                       isBoderText: false,
                                       isTextShadow: false)
        }
        
        self.changeLocation(self.cameraImageView, newLocation: newFrame.camera)
    }
    
    func creatMergeImage() {
        DispatchQueue.main.async {
            let image = self.containerView.takeScreenshot()
            let vc = ShareImageCameraVC()
            vc.imageReceiveCameraVC = image
            self.push(to: vc, animated: true)
        }
    }
    
    func saveToLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            return
        }
    }
}

