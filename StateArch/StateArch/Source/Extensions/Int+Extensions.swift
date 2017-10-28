//
//  Int+Extensions.swift
//  StateArch
//
//  Created by james bouker on 10/23/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//

import Foundation

extension Int {
    static func random(min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max + 1 - min))) + min
    }
}
