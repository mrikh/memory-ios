//
//  ProfilePhotoViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 07/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import CropViewController
import FontAwesome_swift
import UIKit

class ProfilePhotoViewController: BaseViewController, ImagePickerProtocol{

    @IBOutlet weak var storyboardProgressView: StoryboardProgressView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var doneButton: MRAnimatingButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var topColorView: UIView!
    @IBOutlet weak var semiCircleView: UIView!

    let viewModel = ProfilePhotoViewModel()
    private var semiPath : UIBezierPath{
        let path = UIBezierPath()
        let radius = semiCircleView.bounds.height * 2.5
        let centerPoint = CGPoint(x : semiCircleView.center.x, y: radius)

        path.addArc(withCenter: centerPoint, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: false)
        return path
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        let layer = semiCircleView.layer.sublayers?.first(where: { (sub) -> Bool in
            if let value = sub.value(forKey: "bgColor") as? Int, value == 1005{
                return true
            }else{
                return false
            }
        })

        (layer as? CAShapeLayer)?.path = semiPath.cgPath
        doneButton.layer.cornerRadius = doneButton.bounds.height/2.0
        imageView.layer.cornerRadius = imageView.bounds.width/2.0
        imageContainerView.layer.cornerRadius = imageContainerView.bounds.width/2.0
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    //MARK:- IBAction
    @IBAction func uploadAction(_ sender: UIButton) {

        if let _ = imageView.image{
            startImagePick(showFront: true) { [weak self] in
                self?.imageView.image = nil
                self?.uploadButton.setTitle(String.fontAwesomeIcon(name: FontAwesome.cameraRetro), for: .normal)
            }
        }else{
            startImagePick(showFront: true, removalClosure: nil)
        }
    }
    
    @IBAction func skipAction(_ sender: UIButton) {

        //upload blank string to check email verified status
        viewModel.uploadToOurServer(photoUrlString: "")
    }

    @IBAction func doneAction(_ sender: UIButton) {

        guard let image = imageView.image else {return}
        storyboardProgressView.isHidden = false
        viewModel.startUpload(image: image)
        doneButton.startAnimating()
    }

    //MARK:- Private
    private func initialSetup(){

        infoLabel.textColor = Colors.black
        infoLabel.font = CustomFonts.avenirMedium.withSize(15.0)
        infoLabel.text = StringConstants.upload_photo.localized

        topColorView.backgroundColor = Colors.bgColor
        semiCircleView.backgroundColor = Colors.clear

        let layer = CAShapeLayer()
        layer.shouldRasterize = true
        layer.fillColor = Colors.white.cgColor
        layer.setValue(1005, forKey: "bgColor")
        layer.path = semiPath.cgPath
        semiCircleView.layer.addSublayer(layer)

        doneButton.setTitle(StringConstants.done.localized, for: .normal)
        doneButton.disableButton()

        skipButton.setAttributedTitle(NSAttributedString(string : StringConstants.skip.localized, attributes : [.font : CustomFonts.avenirHeavy.withSize(12.0), .foregroundColor : Colors.bgColor, .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        imageContainerView.layer.borderColor = Colors.white.withAlphaComponent(0.3).cgColor
        imageContainerView.layer.borderWidth = 2.0
        imageContainerView.backgroundColor = Colors.bgColor

        imageContainerView.addShadow(3.0)

        uploadButton.configureFontAwesome(name: FontAwesome.cameraRetro, titleColor: Colors.white, size: 42.0, style: FontAwesomeStyle.solid)

        viewModel.delegate = self
        storyboardProgressView.isHidden = true
    }
}

extension ProfilePhotoViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.originalImage] as? UIImage else { return }

        let cropViewController = CropViewController(croppingStyle: .circular, image: image)
        cropViewController.delegate = self
        picker.present(cropViewController, animated: false, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }
}

extension ProfilePhotoViewController : CropViewControllerDelegate{

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {

        imageView.image = image

        doneButton.enableButton()
        uploadButton.setTitle(nil, for: .normal)

        dismiss(animated: true, completion: nil)
    }

    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {

        dismiss(animated: true, completion: nil)
    }
}

extension ProfilePhotoViewController : ProfilePhotoViewModelDelegate{

    func pendingVerification(string: String) {

        showAlert(StringConstants.success.localized, withMessage: string) { [weak self] in
            let viewController = LoginViewController.instantiate(fromAppStoryboard: .PreLogin)
            self?.navigationController?.setViewControllers([viewController], animated: true)
        }
    }

    func updateProgress(progress: Double) {
        storyboardProgressView.update(progress: progress)
    }

    func imageUploadSuccess() {

        storyboardProgressView.isHidden = true
    }

    func updatedInfo() {
        
        doneButton.stopAnimating()
        FlowManager.gotToLandingScreen()
    }

    func errorOccurred(errorString: String?) {

        storyboardProgressView.isHidden = true
        doneButton.stopAnimating()
        showAlert(StringConstants.oops.localized, withMessage: errorString, withCompletion: nil)
    }
}
