//
//  GameSceneLayout.swift
//  StateArch
//
//  Created by james bouker on 10/25/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//
// swiftlint:disable identifier_name

import SpriteKit

extension GameView {
    func layout(_ s: GameState) {
        removeAllActions()
        removeAllChildren()

        // Add Wall sprites
        _ = s.walls.map { addChild(RenderItem(color: .white, loc: $0)) }

        // Add Monster sprites
        monsters = s.monsters.map {
            let monster = RenderItem(color: .red, loc: $0.loc)
            monster.alpha = $0.health > 0 ? 1 : 0
            self.addChild(monster)
            return monster
        }

        // Add Player sprite
        player = RenderItem(color: .green, loc: s.player.loc)
        player.alpha = s.player.health > 0 ? 1 : 0
        addChild(player)
    }
}
