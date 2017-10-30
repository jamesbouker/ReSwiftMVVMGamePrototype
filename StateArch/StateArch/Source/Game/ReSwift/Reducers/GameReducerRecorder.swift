//
//  GameReducerRecorder.swift
//  StateArch
//
//  Created by james bouker on 10/27/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//

import ReSwift

let statesFilename = "GameStateStorage.json"
let lastActionFilename = "LastAction.json"
var storedStates = Storage.saved(statesFilename, as: [GameState].self) ?? [GameState]()
let loadedStates = storedStates
var lastAction = Storage.saved(lastActionFilename, as: PlayerActionCodable.self)?.action

#if REPLAY
var replayIndex = 0
#endif

func gameReducerRecorder(action: Action, state: GameState?) -> GameState {
    #if REPLAY
        if replayIndex < loadedStates.count {
            let state = loadedStates[replayIndex]
            replayIndex += 1
            return state
        }
    #endif

    let state = state ?? loadedStates.last
    let nextState = gameReducer(action: action, state: state)

    // If a player action
    if let action = action as? PlayerAction {

        // Add state to list & record action
        storedStates.append(nextState)
        BuddyBuildSDK.setMetadataObject(storedStates, forKey: "LOL")
        Storage.save(PlayerActionCodable.init(action), filename: lastActionFilename)
    } else if action is ReSwiftInit, storedStates.count == 0 {
        storedStates.append(nextState)
    }
    Storage.save(storedStates, filename: statesFilename)

    return nextState
}
