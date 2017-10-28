//
//  AnimationController.swift
//  StateArch
//
//  Created by james bouker on 10/23/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//
// swiftlint:disable identifier_name

import SpriteKit

extension GameViewModel {

    func diff(to: GameState) -> SKAction {
        guard let scene = self.scene else {
            return SKAction()
        }

        let anim = SKAction.run {

            // Player SKAction
            if let hitDirection = to.player.hitDirection {
                let hitAnim = self.bump(hitDirection: hitDirection)
                scene.player.run(hitAnim)
            } else if to.player.health == 0 {
                scene.player.run(.fadeOut(withDuration: gameTime))
            } else {
                scene.player.run(.move(to: to.player.loc.renderLocation, duration: gameTime))
            }

            // All Monster SKAction
            for pair in zip(scene.monsters, to.monsters) {
                if let hitDirection = pair.1.hitDirection {
                    let hitAnim = self.bump(hitDirection: hitDirection)
                    pair.0.run(hitAnim)
                } else if pair.1.health == 0 {
                    let anim = SKAction.fadeOut(withDuration: gameTime)
                    pair.0.run(anim)
                } else {
                    let anim = SKAction.move(to: pair.1.loc.renderLocation, duration: gameTime)
                    pair.0.run(anim)
                }
            }
        }
        return .sequence([anim, .wait(forDuration: gameTime), .run {
            self.completedTransition()
        }])
    }
}

fileprivate extension GameViewModel {
    func bump(hitDirection: MapLoc) -> SKAction {
        let bump1 = CGVector(dx: hitDirection.x * tileSize/2, dy: hitDirection.y * tileSize/2)
        let bump2 = CGVector(dx: -hitDirection.x * tileSize/2, dy: -hitDirection.y * tileSize/2)
        return .sequence([.move(by: bump1, duration: gameTime / 2.0),
                          .move(by: bump2, duration: gameTime / 2.0)])
    }
}
