//
//  MRCustomBlur.swift
//  Memory
//
//  Created by Mayank Rikh on 27/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import UIKit

class MRCustomBlur: UIVisualEffectView {

    private var animator: UIViewPropertyAnimator!

    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
        animator.fractionComplete = intensity
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
