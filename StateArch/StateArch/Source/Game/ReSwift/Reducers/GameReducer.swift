//
//  GameReducer.swift
//  StateArch
//
//  Created by james bouker on 10/24/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//

import ReSwift

// MARK: - Helpers

func kill(_ playable: inout Playable) {
    playable.health = 0
    playable.hitDirection = nil
}

func isMonster(at loc: MapLoc, monsters: [MapLoc]) -> Bool {
    return monsters.contains(loc)
}

func isWall(_ loc: MapLoc, walls: [MapLoc]) -> Bool {
    return walls.contains(loc)
}

func nextPlayerMove(action: PlayerAction, nextState: inout GameState, currentState: GameState) {

    // Find next player location
    var playerLoc = nextState.player.loc
    switch action {
    case .swipedDown: playerLoc.y -= 1
    case .swipedUp: playerLoc.y += 1
    case .swipedLeft: playerLoc.x -= 1
    case .swipedRight: playerLoc.x += 1
    default: break
    }
    if isWall(playerLoc, walls: nextState.walls) {
        playerLoc = nextState.player.loc
    }
    nextState.player.loc = playerLoc

    // Is Player attacking a monster?
    let locations = nextState.monsters.map { $0.health > 0 ? $0.loc : MapLoc(x: .min, y: .min) }
    if let index = locations.index(of: nextState.player.loc) {
        // Set hit direction
        nextState.player.hitDirection = nextState.player.loc - currentState.player.loc

        // Reset player loc
        nextState.player.loc = currentState.player.loc

        // Kill the enemy
        kill(&nextState.monsters[index])
    }
}

// MARK: - Reducer

func gameReducer(action: Action, state: GameState?) -> GameState {
    let currentState = state ?? GameState.random()
    guard let action = action as? PlayerAction else {
        return currentState
    }

    // Copy and reset state
    var nextState = currentState
    nextState.player.hitDirection = nil
    nextState.commit += 1

    // Find next player move
    nextPlayerMove(action: action, nextState: &nextState, currentState: currentState)

    // For all monsters still alive
    for (i, monster) in nextState.monsters.enumerated() where monster.health > 0 {

        // Find next move?
        nextState.monsters[i].loc += .randomDirection()

        // Is it a wall?
        if isWall(nextState.monsters[i].loc, walls: currentState.walls) {
            // Monster does not move!
            nextState.monsters[i].loc = currentState.monsters[i].loc

            // Is it the Player?
        } else if nextState.monsters[i].loc == nextState.player.loc {
            nextState.monsters[i].hitDirection = nextState.player.loc - currentState.monsters[i].loc

            // Kill the Player!
            kill(&nextState.player)
        }
    }

    return nextState
}
