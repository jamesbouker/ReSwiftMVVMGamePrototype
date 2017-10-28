//
//  RenderItem.swift
//  StateArch
//
//  Created by james bouker on 10/22/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//

import SpriteKit

class RenderItem: SKSpriteNode {

    required init?(coder _: NSCoder) { fatalError("Not implemented") }

    init(color: UIColor, loc: MapLoc) {
        super.init(texture: nil, color: color, size: CGSize(width: tileSize, height: tileSize))
        setLocation(loc)
    }

    func setLocation(_ loc: MapLoc) {
        position = loc.renderLocation
    }
}

extension MapLoc {
    var renderLocation: CGPoint {
        return CGPoint(x: x * tileSize, y: y * tileSize)
    }
}
