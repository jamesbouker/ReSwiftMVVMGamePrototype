//
//  MapLoc.swift
//  StateArch
//
//  Created by james bouker on 10/22/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//
// swiftlint:disable identifier_name
// swiftlint:disable shorthand_operator
// swiftlint:disable operator_whitespace

import SpriteKit

struct MapLoc: Codable {
    var x: Int
    var y: Int
}

extension MapLoc: Equatable {
    static func randomDirection() -> MapLoc {
        let rand = Int.random(min: 0, max: 3)
        switch rand {
        case 0: return MapLoc(x: 1, y: 0)
        case 1: return MapLoc(x: -1, y: 0)
        case 2: return MapLoc(x: 0, y: 1)
        case 3: return MapLoc(x: 0, y: -1)
        default: return MapLoc(x: 0, y: 0)
        }
    }

    static func random(width: Int, height: Int) -> MapLoc {
        let x = Int.random(min: -width / 2, max: width / 2)
        let y = Int.random(min: -height / 2, max: height / 2)
        return MapLoc(x: x, y: y)
    }

    static func ==(lhs: MapLoc, rhs: MapLoc) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    static func +(lhs: MapLoc, rhs: MapLoc) -> MapLoc {
        return MapLoc(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func +=(lhs: inout MapLoc, rhs: MapLoc) {
        lhs = lhs + rhs
    }

    static func -(lhs: MapLoc, rhs: MapLoc) -> MapLoc {
        return MapLoc(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
