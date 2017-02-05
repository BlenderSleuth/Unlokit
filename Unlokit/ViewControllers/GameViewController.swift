//
//  GameViewController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, LevelController {
	
	var level: Level!
	
	var completed = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		startNewGame()
	}
	
	func startNewGame() {
		DispatchQueue.global(qos: .userInitiated).async {
			// Check for skView,             load scene from file
			if let skView = self.view as? SKView, let loading = SKScene(fileNamed: "LoadingScreen") {
				loading.scaleMode = .aspectFill
				skView.presentScene(loading)
				
				skView.ignoresSiblingOrder = true
				
				// Set options
				skView.showsFPS = true
				skView.showsNodeCount = true
				skView.showsDrawCount = true
				//skView.showsPhysics = true
				//skView.showsFields = true
				
				if let scene = Stage1(fileNamed: "Level\(self.level.number)") {
					weak var weakScene: Stage1! = scene
					weakScene.levelController = self
					weakScene.levelNumber = self.level.number
					
					weakScene.setupNodes(delegate: self)
					weakScene.setupCamera()
					weakScene.setupTools()
					weakScene.setupTextures()
					weakScene.setupBlocks()
					weakScene.physicsWorld.contactDelegate = weakScene
					
					// If background music was paused, resume
					if !weakScene.soundFX.resumeBackgroundMusic() {
						// Otherwise, play
						weakScene.soundFX.playBackgroundMusic(filename: "background.mp3")
					}
					
					// Scale scene to fill
					weakScene.scaleMode = .aspectFill
					
					// Transistion
					let transition = SKTransition.crossFade(withDuration: 0.5)
					
					// Bounce back to the main thread to update the UI
					DispatchQueue.main.async {
						// Present Scene
						skView.presentScene(weakScene, transition: transition)
					}
				}
			}
		}
	}
	
	func endGame() {
		level.completed = true
		completed = true
		returnToLevelSelect()
	}
	
	// Clean up
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if let skView = self.view as? SKView {
			skView.scene?.removeFromParent()
			skView.presentScene(nil)
		}
	}
	
	func returnToLevelSelect() {
		performSegue(withIdentifier: "toLevelSelect", sender: nil)
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}
