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
    
    private var tutorial = false
	
	var level: Level!

	var delegate: LevelSelectDelegate?

	var currentLevelView: LevelView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.isNavigationBarHidden = true
        
        //if isAppFirstLaunch {
            // For first time
            //startTutorial()
        //} else {
            
            #if DEBUG
                // DEBUG if this is the initial view controller
                //let stage = 2
                //let level = 10
                
                //self.level = Stages.sharedInstance.stages[stage-1].levels[level-1]
                //startNewGame(levelname: "Level1_S")
                startNewGame()
            #else
                startNewGame()
            #endif
        //}
    }
    
    func startTutorial() {
        tutorial = true
        level = Stages.sharedInstance.stages[0].levels[0]
        startNewGame()
    }
	
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
				
				// For tutorial scene
				
                //let fileName: String
				
                // To Fix
                //if isGameFirstLaunch {
					//print("tutorial")
                    //fileName = "LevelTutorial"
                //} else {
                    //fileName = levelname
                //}
				
				if let scene = GameScene(fileNamed: levelname) {
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
	
	// Clean up
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
