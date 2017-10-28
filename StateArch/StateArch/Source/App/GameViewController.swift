//
//  GameViewController.swift
//  StateArch
//
//  Created by james bouker on 10/22/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//
// swiftlint:disable force_cast

import ReSwift
import SpriteKit

class GameViewController: UIViewController {

    var touchDownLocation: CGPoint?
    var touchDownTime: Date?
    var scene: GameView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = self.view as! SKView
        scene = GameView(fileNamed: "GameView")!
        scene.scaleMode = .aspectFill

        view.presentScene(scene)
        view.ignoresSiblingOrder = true

        // DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if REPLAY
            for _ in 0..<storedStates.count-1 {
                scene.viewModel.playerAction = .pressed
            }
        #endif
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let location = touches.first?.location(in: nil) else { return }
        touchDownLocation = location
        touchDownTime = Date()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touchDown = touchDownTime else { return }
        guard let to = touches.first?.location(in: nil) else { return }
        guard let from = touchDownLocation else { return }
        let time = Date().timeIntervalSince(touchDown)
        let delta: CGFloat = CGFloat(tileSize) / 2
        let deltaX = (to - from).x
        let deltaY = (to - from).y

        let kill: () -> Void = {
            self.touchDownLocation = nil
            self.touchDownTime = nil
        }

        guard abs(deltaX) > delta || abs(deltaY) > delta else {
            if time > 0.3 {
                kill()
                scene.viewModel.playerAction = .pressed
            }
            return
        }

        if abs(deltaX) > abs(deltaY) {
            if deltaX > delta {
                kill()
                scene.viewModel.playerAction = .swipedRight
            } else if deltaX < -delta {
                kill()
                scene.viewModel.playerAction = .swipedLeft
            }
        } else {
            if deltaY > delta {
                kill()
                scene.viewModel.playerAction = .swipedDown
            } else if deltaY < -delta {
                kill()
                scene.viewModel.playerAction = .swipedUp
            }
        }
    }
}
