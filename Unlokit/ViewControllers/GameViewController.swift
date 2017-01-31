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
        startNewGame()
    }
	
	func startNewGame() {
		// Check for skView,             load scene from file
		if let skView = view as? SKView, let scene = Stage1(fileNamed: "Level\(level)") {
			scene.start = self
			
			scene.levelNumber = level
			
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
	
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

