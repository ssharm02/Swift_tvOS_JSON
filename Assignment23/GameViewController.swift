//
//  GameViewController.swift
//  Assignment23
//
//  Created by Xcode User on 2018-11-27.
//  Copyright © 2018 Xcode User. All rights reserved.

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var skView: SKView?
    var gameScene: GameScene?
    @IBOutlet weak var PlayDaGame: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        skView = self.view as? SKView
        skView?.showsFPS = true
        skView?.showsNodeCount = false
        skView?.ignoresSiblingOrder = true
        startGame()
    }
    func startGame() {
        gameScene = GameScene(size: self.view.frame.size)
        gameScene?.scaleMode = .aspectFill
        skView?.presentScene(gameScene)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }


}
