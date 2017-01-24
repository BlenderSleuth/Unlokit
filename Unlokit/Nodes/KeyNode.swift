//
//  KeyNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 22/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class KeyNode: SKSpriteNode, CanBeFired {
	
	var reloadable: Reload!
	
	// Status flags
	var isEngaged = false
	var isFired = false
	var animating = false
	private var isGreyed = false
	
	// Initial key position, to return to
	var startPosition: CGPoint!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		// Set position to start
		startPosition = position
	}
	
	func engage(_ controller: ControllerNode) {
		controller.occupied = true
		isEngaged = true
		animating = true
		run(SKAction.move(to: controller.position, duration: 0.2)) {
			self.animating = false
		}
		
	}
	func disengage(_ controller: ControllerNode) {
		animating = true
		run(SKAction.move(to: startPosition, duration: 0.2)) {
			self.animating = false
		}
		controller.occupied = false
		isEngaged = false
	}

	func prepareForFiring(_ controller: ControllerNode) {
		// Sets up before firing
		setupPhysics()
		isEngaged = false
		isFired = true
		controller.occupied = false
	}
	private func setupPhysics() {
		// Physicsbody
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.allowsRotation = false
		physicsBody?.isDynamic = true
		physicsBody?.categoryBitMask = Category.key
		physicsBody?.contactTestBitMask = Category.lock | Category.blocks | Category.bounds | Category.controller
		physicsBody?.collisionBitMask = Category.all ^ (Category.controller | Category.lock) //All except controller and lock
	}
	
	func smash() {
		removeFromParent()
		
		// TO DO: smash key
		SKTAudio.sharedInstance().playSoundEffect(filename: "Smash.caf")
		
		// Reload scene
		if reloadable != nil {
			reloadable.reload()
		}
		
	}
	
	func lock(_ lock: LockNode) {
		physicsBody = nil
		
		let move = SKAction.move(to: lock.position, duration: 0.2)
		run(move) {
			self.removeAllActions()
			//lock.removeFromParent()
			SKTAudio.sharedInstance().playSoundEffect(filename: "Lock.caf")
			
		}
	}
	
	func greyOut() {
		if isGreyed {														// Same value
			run(SKAction.colorize(withColorBlendFactor: 0, duration: 0.2), withKey: "colorise")
		} else {
			run(SKAction.colorize(withColorBlendFactor: 0.6, duration: 0.2), withKey: "colorise")
		}
		isGreyed = !isGreyed
	}
}
