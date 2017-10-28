//
//  AppDelegate.swift
//  StateArch
//
//  Created by james bouker on 10/22/17.
//  Copyright © 2017 JimmyBouker. All rights reserved.
//

import ReSwift

//var store = Store<GameState>(reducer: gameReducer, state: nil)
var store = Store<GameState>(reducer: gameReducerRecorder, state: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}
