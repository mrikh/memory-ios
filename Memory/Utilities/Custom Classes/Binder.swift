//
//  Binder.swift
//  Memory
//
//  Created by Mayank Rikh on 07/11/18.
//  Copyright © 2018 Memory. All rights reserved.
//

import Foundation

class Binder<T>{

    typealias Listener = (T) -> Void

    var listener : Listener?

    var value : T{
        didSet{
            listener?(value)
        }
    }

    init(_ value : T){
        self.value = value
    }

    func bind(listener : Listener?){
        self.listener = listener
        listener?(value)
    }
}
