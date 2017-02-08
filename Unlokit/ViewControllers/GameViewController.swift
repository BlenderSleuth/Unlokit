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
			// Transistion
			let transition = SKTransition.crossFade(withDuration: 0.5)
			
			// Check for skView,             load scene from file
			if let skView = self.view as? SKView, let loading = SKScene(fileNamed: "LoadingScreen") {
				loading.scaleMode = .aspectFill
				skView.presentScene(loading, transition: transition)
				
				skView.ignoresSiblingOrder = true
				
				// Set options
				skView.showsFPS = true
				skView.showsNodeCount = true
				skView.showsDrawCount = true
				//skView.showsPhysics = true
				//skView.showsFields = true
				
				if let scene = Stage1(fileNamed: "Level\(self.level.stageNumber)_\(self.level.number)") {
					//weak var weakScene: Stage1! = scene
					scene.levelController = self
					scene.levelNumber = self.level.number
					
					scene.setupNodes(delegate: self)
					scene.setupCamera()
					scene.setupTools()
					scene.setupTextures()
					scene.setupBlocks()
					scene.physicsWorld.contactDelegate = scene
					
					// If background music was paused, resume
					if !scene.soundFX.resumeBackgroundMusic() {
						// Otherwise, play
						scene.soundFX.playBackgroundMusic(filename: "background.mp3")
					}
					
					// Scale scene to fill
					scene.scaleMode = .aspectFill
					
					// Bounce back to the main thread to update the UI
					DispatchQueue.main.async {
						// Present Scene
						skView.presentScene(scene, transition: transition)
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
		// Animate with cross dissolve
		let transition = CATransition()
		transition.duration = 0.5
		navigationController?.view.layer.add(transition, forKey: nil)
		
		performSegue(withIdentifier: "toLevelSelect", sender: nil)
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}
