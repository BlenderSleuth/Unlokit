//
//  GameViewController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, start {
	
	var stage = 1
	var level = 1
	
    override func viewDidLoad() {
        super.viewDidLoad()
		weak var weakSelf = self
		DispatchQueue.global(qos: .userInitiated).async {
			weakSelf?.startNewGame()
		}
    }
	
	func startNewGame() {
		// Check for skView,             load scene from file
		if let skView = view as? SKView, let loading = SKScene(fileNamed: "LoadingScreen") {
			loading.scaleMode = .aspectFill
			skView.presentScene(loading)
			
			if let scene = Stage1(fileNamed: "Level\(level)") {
				scene.start = self
				scene.levelNumber = level
				
				DispatchQueue.global(qos: .userInitiated).async {
					scene.setupNodes()
					scene.setupCamera()
					scene.setupTools()
					scene.setupTextures()
					scene.setupBlocks()
					scene.physicsWorld.contactDelegate = scene
					scene.soundFX.playBackgroundMusic(filename: "background.mp3")

					// Bounce back to the main thread to update the UI
					DispatchQueue.main.async {
						// Scale scene to fill
						scene.scaleMode = .aspectFill
						
						// Transistion
						let transition = SKTransition.crossFade(withDuration: 0.5)
						
						// Present Scene
						skView.presentScene(scene, transition: transition)
						
						//TO DO:
						skView.ignoresSiblingOrder = true
						
						// Set options
						skView.showsFPS = true
						skView.showsNodeCount = true
						skView.showsDrawCount = true
						//skView.showsPhysics = true
						//skView.showsFields = true
					}
				}

			}
		}
	}
	
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

