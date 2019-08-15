//
//  MRRefreshControl.swift
//  Mid West Pilot Cars
//
//  Created by Hmm on 26/05/19.
//  Copyright © 2019 Hmm. All rights reserved.
//

import UIKit

class MRRefreshControl: UIRefreshControl {

    private var refreshBegin : (()->())?

    convenience init(with action : (()->())?) {

        self.init()
        addTarget(self, action: #selector(handleRefreshAction(_:)), for: .valueChanged)
        refreshBegin = action
    }

    @objc func handleRefreshAction(_ control : UIRefreshControl){
        refreshBegin?()
    }
}
