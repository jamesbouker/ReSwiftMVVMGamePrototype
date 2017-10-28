//
//  GameState.swift
//  StateArch
//
//  Created by james bouker on 10/23/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//

import ReSwift

struct Playable: Codable {
    var loc: MapLoc
    var health: Int

    var hitDirection: MapLoc?

    init(loc: MapLoc, hitDirection: MapLoc? = nil) {
        self.loc = loc
        self.hitDirection = hitDirection
        health = 1
    }
}

struct GameState: StateType, Codable {
    var commit: Int
    var player: Playable
    var monsters: [Playable]
    var walls: [MapLoc]
}

extension GameState {
    static func random() -> GameState {
        let player = MapLoc.random(width: columnCount-1, height: rowCount-1)
        let monsters = Array(0 ... 5).map { _ in
            MapLoc.random(width: columnCount-1, height: rowCount-1)
            }.map { Playable(loc: $0) }
        var walls = Array(0 ... 5).map { _ in MapLoc.random(width: columnCount-1, height: rowCount-1) }
        walls.append(contentsOf: Array(0 ... rowCount).map { MapLoc(x: -columnCount/2, y: $0 - rowCount/2) })
        walls.append(contentsOf: Array(0 ... rowCount).map { MapLoc(x: columnCount/2, y: $0 - rowCount/2) })
        walls.append(contentsOf: Array(0 ... columnCount).map { MapLoc(x: $0 - columnCount/2, y: rowCount/2) })
        walls.append(contentsOf: Array(0 ... columnCount).map { MapLoc(x: $0 - columnCount/2, y: -rowCount/2) })
        return GameState(commit: 1,
                         player: Playable(loc: player),
                         monsters: monsters,
                         walls: walls)
    }
}
