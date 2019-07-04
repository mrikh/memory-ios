//
//  UIImageView + Download.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SDWebImage
import Foundation

extension UIImageView{
    
    /// Custom set image so that incase we change SDWebImage library we don't have to change in multiple places
    ///
    /// - Parameters:
    ///   - urlString: url to load image from
    ///   - placeholder: placeholder to use while image is downloading
    func setImageWithCompletion(_ urlString : String, placeholder : UIImage?, showLoader : Bool = true, completion: (()->())?){

        sd_imageIndicator = showLoader ? SDWebImageActivityIndicator.white : nil
        sd_setImage(with: URL(string : urlString), placeholderImage: placeholder, options: .init(rawValue : 0)) { (image, error, cache, url) in
            completion?()
        }
    }
}
