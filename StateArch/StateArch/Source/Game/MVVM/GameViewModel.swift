//
//  GameSceneViewModel.swift
//  StateArch
//
//  Created by james bouker on 10/28/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//

import ReSwift
import SpriteKit

import Bond

class GameViewModel: StoreSubscriber {

    // MARK: - Variables
    weak var scene: GameView?
    var playerAction: PlayerAction = .pressed {
        didSet {
            actionQueue.append(playerAction)
            if actionQueue.count == 1 && !isAnimating {
                executeFirstAction()
            }
        }
    }

    private var actionQueue = [PlayerAction]()
    private var isAnimating = false


    // MVVM
    var action = Observable<SKAction?>(nil)

    // MARK: - Init!
    init(_ scene: GameView) {
        self.scene = scene
        store.subscribe(self)
    }

    private func executeFirstAction() {
        isAnimating = true
        let action = actionQueue.removeFirst()
        store.dispatch(action)
    }

    func completedTransition() {
        self.isAnimating = false

        if self.actionQueue.count > 0 {
            self.executeFirstAction()
        }
    }

    // MARK: - Store Subscriber
    func newState(state: GameState) {
        guard let scene = self.scene else {
            return
        }

        if scene.player != nil {
            self.action.value = diff(to: state)
        } else {
            scene.layout(state)
            self.completedTransition()
        }
    }
}
