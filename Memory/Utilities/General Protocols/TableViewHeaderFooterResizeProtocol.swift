//
//  TableViewHeaderFooterResizeProtocol.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewHeaderFooterResizeProtocol {
    
    /// This method will resize the view passed and return it resized by forcing layout by assuming minimalistic constraints
    ///
    /// - Parameter view: View to resize
    /// - Returns: View after resizing
    func resizeView(_ view : UIView) -> UIView?
}

extension TableViewHeaderFooterResizeProtocol{
    
    func resizeView(_ view : UIView) -> UIView?{
        
        let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = view.frame
        
        if height != view.frame.size.height{
            frame.size.height = height
            view.frame = frame
            return view
        }
        
        return nil
    }
}
