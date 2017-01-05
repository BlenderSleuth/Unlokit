//
//  ViewController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check for skView,             load scene from file
        if let skView = view as? SKView, let scene = SKScene(fileNamed: "GameScene") as? GameScene {
            self.scene = scene
            // Scale scene to fill
            scene.scaleMode = .aspectFill
            
            // Present Scene
            skView.presentScene(scene)
            
            // Set options
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            // Causes memory leak...
            //skView.showsPhysics = true
        }
    }
}

