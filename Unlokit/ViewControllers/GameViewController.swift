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

	var delegate: LevelSelectDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.isNavigationBarHidden = true
		// DEBUG if this is the initial view controller
		//let stage = 1
		//let level = 9
		
		//self.level = Stages.sharedInstance.stages[stage-1].levels[level-1]
		startNewGame()
	}
	
	func startNewGame(levelname: String) {
		// Put all this on seperate thread or loading
		DispatchQueue.global(qos: .userInitiated).async {
			// Transistion
			let transition = SKTransition.crossFade(withDuration: 0.5)
			
			// Check for skView,             load scene from file
			if let skView = self.view as? SKView, let loading = SKScene(fileNamed: "LoadingScreen") {
				loading.scaleMode = .aspectFill
				skView.presentScene(loading, transition: transition)
				
				skView.ignoresSiblingOrder = true
				
				// Set debug options
				//skView.showsFPS = true
				//skView.showsNodeCount = true
				//skView.showsDrawCount = true
				//skView.showsPhysics = true
				//skView.showsFields = true
				
				if let scene = GameScene(fileNamed: levelname) {
					//weak var weakScene: GameScene! = scene
					scene.levelController = self
					scene.level = self.level
					
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
			} else {
				fatalError("View is not SKView!!")
			}
		}
	}
	func startNewGame() {
		startNewGame(levelname: "Level\(self.level.stageNumber)_\(self.level.number)")
	}
	
	func endGame() {
		level.completed = true
		completed = true
		returnToLevelSelect()
	}
	func endSecret() {
		startNewGame()
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

		let _ = navigationController?.popViewController(animated: false)
		delegate?.completed(completed)
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}
