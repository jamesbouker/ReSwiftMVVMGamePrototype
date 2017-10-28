//
//  GameScene.swift
//  StateArch
//
//  Created by james bouker on 10/22/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//

import ReSwift
import SpriteKit
import ReactiveKit

class GameView: SKScene {

    // MARK: - MVVM
    var viewModel: GameViewModel!
    var trash: Disposable?

    // MARK: - Render Items
    var player: RenderItem!
    var monsters: [RenderItem]!

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        viewModel = GameViewModel(self)

        _ = #imageLiteral(resourceName: "allTheThings")
        trash = viewModel.action.observeNext { [weak self] action in
            guard let action = action else { return }
            self?.run(action)
        }
    }
}
