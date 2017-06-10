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

	var delegate: LevelSelectDelegate?

	var currentLevelView: LevelView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.isNavigationBarHidden = true
            
		#if DEBUG
			// DEBUG if this is the initial view controller
			//let stage = 2
			//let level = 10
			
			//self.level = Stages.sharedInstance.stages[stage-1].levels[level-1]
			//startNewGame(levelname: "Level1_S")
			//startTutorial()
			startNewGame()
		#else
			startNewGame()
		#endif
    }
	
	//MARK: - Starting a game
    func startNewGame(levelname: String) {
		// Put this all on seperate thread for loading
		DispatchQueue.global(qos: .userInitiated).async {
			// Transition
			let transition = SKTransition.crossFade(withDuration: 0.5)
			
			// Check for skView,             load scene from file
			if let skView = self.view as? SKView, let loading = SKScene(fileNamed: "LoadingScreen") {
				loading.scaleMode = .aspectFill
				skView.presentScene(loading, transition: transition)
				
				skView.ignoresSiblingOrder = true
				
				#if DEBUG
					// Set debug options
					skView.showsFPS = true
					//skView.showsNodeCount = true
					//skView.showsDrawCount = true
					//skView.showsPhysics = true
					//skView.showsFields = true
				#endif
				
				// For tutorial scen
                let fileName: String
				
                // If this is the tutorial, run it
                if self.level.isTutorial {
                    fileName = "LevelTutorial"
					doneTutorial = true
                } else {
                    fileName = levelname
                }
				
				if let scene = GameScene(fileNamed: fileName) {
					scene.levelController = self
					scene.level = self.level
					
					scene.setupNodes(delegate: self)
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
		// Reload current level
        startNewGame(levelname: "Level\(self.level.stageNumber)_\(self.level.number)")
	}
	
	//MARK: - Levels
	func finishedLevel() {
		level.isCompleted = true
		level.isSecret = false
		returnToLevelSelect()
	}
	func endSecret() {
		// Achievement reporting
		let achievement: Achievement
		switch level.stageNumber {
		case 1:
			achievement = .stage1Secret
		case 2:
			achievement = .stage2Secret
		default:
			achievement = .stage1Secret
		}
		
		report(achievement: achievement)
		
		level.isSecret = false
		startNewGame()
	}
	
	func saveLevels() {
		delegate?.saveLevels()
	}
	func toNextLevel() {
		// Because of reference we can set this in here
		level.isCompleted = true
		
		// Get next level
		var nextLevelNumber = level.number + 1
		var stageNumber = level.stageNumber

		// Check if level exceeded stage number
		if nextLevelNumber > Stages.sharedInstance.stages[stageNumber - 1].levels.count {
			nextLevelNumber = 1
			stageNumber += 1
		}

		// Setup new level views
		level = Stages.sharedInstance.stages[stageNumber - 1].levels[nextLevelNumber-1]
		currentLevelView = delegate?.levelViews[stageNumber]?[level.number - 1]

		if let view = currentLevelView {
			delegate?.setNextLevelView(from: view)
		}

		currentLevelView?.makeAvailable()
		
		saveLevels()

		// Ask for a review
		checkForReview()
		
		startNewGame()
	}
	
	// For use with back button and finished screen
	func returnToLevelSelect() {
		// Animate with cross dissolve
		let transition = CATransition()
		transition.duration = 0.5
		navigationController?.view.layer.add(transition, forKey: nil)
		
		let _ = navigationController?.popViewController(animated: false)
		if level.isCompleted {
			delegate?.completeLevel()
		}
	}
	
	//MARK: - Ratings
	let minSessions = 6
	let tryAgainSessions = 6
	
	func checkForReview() {
		let defaults = UserDefaults.standard
		// Current values
		let neverRate = defaults.bool(forKey: "neverRate")
		var numLaunches = defaults.integer(forKey: "numLaunches") + 1
		
		// Check if neverRate, or
		if !neverRate && (numLaunches == minSessions || numLaunches >= (minSessions + tryAgainSessions + 1)) {
			askForReview()
			// Reset launches
			numLaunches = minSessions + 1
		}
		defaults.set(numLaunches, forKey: "numLaunches")
	}
	func askForReview() {
		// Create the alert
		let alert = UIAlertController(title: "Rate Unlokit", message: "Thank you for using Unlokit", preferredStyle: UIAlertControllerStyle.alert)
		// Add the actions
		alert.addAction(UIAlertAction(title: "Rate", style: UIAlertActionStyle.default, handler: { alertAction in
			let url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")!
			UIApplication.shared.openURL(url)
			alert.dismiss(animated: true, completion: nil)
		}))
		alert.addAction(UIAlertAction(title: "Write a review", style: UIAlertActionStyle.default, handler: { alertAction in
			let url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&action=write-review")!
			UIApplication.shared.openURL(url)
			alert.dismiss(animated: true, completion: nil)
		}))
		alert.addAction(UIAlertAction(title: "Maybe later", style: UIAlertActionStyle.default, handler: { alertAction in
			alert.dismiss(animated: true, completion: nil)
		}))
		alert.addAction(UIAlertAction(title: "No thanks", style: UIAlertActionStyle.default, handler: { alertAction in
			UserDefaults.standard.set(true, forKey: "neverRate")
			alert.dismiss(animated: true, completion: nil)
		}))
		// Present the alert
		self.present(alert, animated: true, completion: nil)
	}
	
	//MARK: - Clean up
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if let skView = self.view as? SKView {
			skView.scene?.removeFromParent()
			skView.presentScene(nil)
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}
