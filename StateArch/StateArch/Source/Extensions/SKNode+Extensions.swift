//
//  SKNode+Extensions.swift
//  StateArch
//
//  Created by james bouker on 10/24/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//

import SpriteKit

extension SKNode {
    func runs(_ actions: [SKAction]) {
        run(.sequence(actions))
    }
}
