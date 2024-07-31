//
//  ShareImageCameraVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 24/04/2024.
//

import UIKit

class ShareImageCameraVC: BaseViewController {
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
//    @Published var is
    var imageReceiveCameraVC: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        if let image = imageReceiveCameraVC {
            imageView.image = image
        } else {
            print("Không có ảnh nhận được")
        }
    }
    
    private func setUpButton() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            saveBtn.setBackgroundImage(UIImage(named: "SaveIp"), for: .normal)
            shareBtn.setBackgroundImage(UIImage(named: "ShareIp"), for: .normal)
        } else {
            saveBtn.setBackgroundImage(UIImage(named: "SaveIpad"), for: .normal)
            shareBtn.setBackgroundImage(UIImage(named: "ShareIpad"), for: .normal)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Lỗi khi lưu ảnh: \(error.localizedDescription)")
        } else {
            print("Ảnh đã được lưu thành công")
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        guard let imageToSave = imageReceiveCameraVC else {
            print("Không có ảnh nhận được")
            return
        }
        showToast(message: "Saved")
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.pop(animated: true)
        }
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        guard let imageToShare = imageReceiveCameraVC else {
            print("Không có ảnh nhận được")
            return
        }
 
        let items = [imageToShare]

        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)

        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(activityViewController, animated: true)

        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                print("Chia sẻ thành công")
            } else if let error = error {
                print("Lỗi khi chia sẻ: \(error.localizedDescription)")
            } else {
                print("Chia sẻ bị hủy bỏ")
            }
        }

    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        pop(animated: true)
    }
}
