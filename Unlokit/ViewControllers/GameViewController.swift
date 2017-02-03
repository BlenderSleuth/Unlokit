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
		DispatchQueue.global(qos: .userInitiated).async {
			self.startNewGame()
		}
    }
	
	func startNewGame() {
		// Check for skView,             load scene from file
		if let skView = view as? SKView, let loading = SKScene(fileNamed: "LoadingScreen") {
			loading.scaleMode = .aspectFill
			skView.presentScene(loading)
			
			if let scene = Stage1(fileNamed: "Level\(level)") {
				weak var weakScene = scene
				weakScene?.start = self
				weakScene?.levelNumber = level
				
				DispatchQueue.global(qos: .userInitiated).async {
					weakScene?.setupNodes(vc: self)
					weakScene?.setupCamera()
					weakScene?.setupTools()
					weakScene?.setupTextures()
					weakScene?.setupBlocks()
					weakScene?.physicsWorld.contactDelegate = weakScene
					weakScene?.soundFX.playBackgroundMusic(filename: "background.mp3")

					// Bounce back to the main thread to update the UI
					DispatchQueue.main.async {
						// Scale scene to fill
						weakScene?.scaleMode = .aspectFill
						
						// Transistion
						let transition = SKTransition.crossFade(withDuration: 0.5)
						// Present Scene
						skView.presentScene(weakScene!, transition: transition)
						
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
	
	func goToLevelSelect() {
		performSegue(withIdentifier: "toLevelSelect", sender: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let skView = self.view as? SKView {
			skView.scene?.removeFromParent()
			skView.presentScene(nil)
		}
	}
	
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

