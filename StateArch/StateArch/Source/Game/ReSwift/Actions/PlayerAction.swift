//
//  PlayerAction.swift
//  StateArch
//
//  Created by james bouker on 10/24/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//

import ReSwift

enum PlayerAction: String, Action {
    case pressed
    case swipedUp
    case swipedDown
    case swipedRight
    case swipedLeft
}

struct PlayerActionCodable: Codable {
    var actionString: String

    init(_ action: PlayerAction) {
        actionString = action.rawValue
    }

    var action: PlayerAction {
        return PlayerAction(rawValue: actionString)!
    }
}
