//
//  GameViewController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, start {

    var skScene: SKScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
	
	func startNewGame() {
		
		/*
		// Load 'GameScene.sks' as a GKScene. This provides gameplay related content
		// including entities and graphs.
		if let scene = GKScene(fileNamed: "GameScene") {
		
		// Get the SKScene from the loaded GKScene
		if let sceneNode = scene.rootNode as! GameScene? {
		
		// Copy gameplay related content over to the scene
		sceneNode.entities = scene.entities
		sceneNode.graphs = scene.graphs
		
		// Set the scale mode to scale to fit the window
		sceneNode.scaleMode = .aspectFill
		
		// Present the scene
		if let view = self.view as! SKView? {
		view.presentScene(sceneNode)
		
		view.ignoresSiblingOrder = true
		
		view.showsFPS = true
		view.showsNodeCount = true
		}
		}
		}
		*/
		
		if let gkScene = GKScene(fileNamed: "Level1") {
			if let skScene = gkScene.rootNode as? Level {
				skScene.entities = gkScene.entities
				
				skScene.start = self
				
				// Scale scene to fill
				skScene.scaleMode = .aspectFill
				
				if let view = self.view as? SKView {
					// Transistion
					let transition = SKTransition.crossFade(withDuration: 0.5)
					
					// Present Scene
					view.presentScene(skScene, transition: transition)
					
					view.ignoresSiblingOrder = true
					
					// Set options
					view.showsFPS = true
					view.showsNodeCount = true
					
					// Causes memory leak...
					//skView.showsPhysics = true
				}
			}
		}
	}
	
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

