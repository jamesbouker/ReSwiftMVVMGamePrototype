//
//  CGPoint+Extensions.swift
//  StateArch
//
//  Created by james bouker on 10/23/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//
// swiftlint:disable operator_whitespace

import UIKit

extension CGPoint {
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
