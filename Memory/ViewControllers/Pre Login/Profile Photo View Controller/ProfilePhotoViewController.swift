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

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
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
        let firstPoint = CGPoint(x: 0.0, y: semiCircleView.bounds.height)
        let secondPoint = CGPoint(x: semiCircleView.bounds.width, y: 0.0)
        let thirdPoint = CGPoint(x: semiCircleView.bounds.width, y: semiCircleView.bounds.height)

        path.move(to: firstPoint)
        path.addLine(to: secondPoint)
        path.addLine(to: thirdPoint)
        path.close()

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
        visualEffectView.layer.cornerRadius = visualEffectView.bounds.height/2.0
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    //MARK:- IBAction
    @IBAction func editAction(_ sender: UIButton) {

        startImagePick(showFront: true) { [weak self] in
            self?.imageView.image = nil
            self?.updateButtons(showEdit: false)
        }
    }

    @IBAction func uploadAction(_ sender: UIButton) {

        startImagePick(showFront: true, removalClosure: nil)
    }
    
    @IBAction func skipAction(_ sender: UIButton) {

        let tab = CustomTabBarController.instantiate(fromAppStoryboard: .Main)
        navigationController?.setViewControllers([tab], animated: true)
    }

    @IBAction func doneAction(_ sender: UIButton) {

        guard let image = imageView.image else {return}
        storyboardProgressView.isHidden = false
        viewModel.startUpload(image: image)
        doneButton.startAnimating()
    }

    //MARK:- Private
    private func updateButtons(showEdit : Bool){

        uploadButton.setTitle(showEdit ? nil : String.fontAwesomeIcon(name: FontAwesome.cameraRetro), for: .normal)
        visualEffectView.isHidden = !showEdit
        showEdit ? doneButton.enableButton() : doneButton.disableButton()
        uploadButton.isHidden = showEdit
    }

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
        semiCircleView.layer.insertSublayer(layer, at: 0)

        doneButton.setTitle(StringConstants.done.localized, for: .normal)
        doneButton.disableButton()

        skipButton.setAttributedTitle(NSAttributedString(string : StringConstants.skip.localized, attributes : [.font : CustomFonts.avenirHeavy.withSize(12.0), .foregroundColor : Colors.bgColor, .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        imageContainerView.backgroundColor = Colors.bgColor

        uploadButton.configureFontAwesome(name: FontAwesome.cameraRetro, titleColor: Colors.white, size: 42.0, style: FontAwesomeStyle.solid)

        viewModel.delegate = self
        storyboardProgressView.isHidden = true
        visualEffectView.isHidden = true

        editButton.configureFontAwesome(name: .cameraRetro, titleColor: .white, size: 22.0, style: .solid)
    }
}

extension ProfilePhotoViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.originalImage] as? UIImage else { return }

        let cropViewController = CropViewController(croppingStyle: .default, image: image)
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
        updateButtons(showEdit: true)

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
