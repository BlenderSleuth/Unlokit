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
	
	var isEngaged: Bool = false {
		didSet {
			if isEngaged {
				constraints = nil
			} else {
				constraints = saveContraint
			}
			
		}
	}

	var isFired = false
	
	var startPosition: CGPoint! // Initial key position
	
	// To save constraints when not using them
	var saveContraint = [SKConstraint]()
	
	var animating = false
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		// Set position to start
		startPosition = position
		
		// TO DO: Make this work internally...
		//setupPhysics()
	}
	func setupPhysics() {
		// Physicsbody
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.allowsRotation = false
		physicsBody?.isDynamic = false
		physicsBody?.density = 0.3
		physicsBody?.categoryBitMask = Category.key
		physicsBody?.contactTestBitMask = Category.lock | Category.blocks | Category.bounds | Category.controller
		physicsBody?.collisionBitMask = Category.all ^ (Category.controller | Category.lock) //All except controller and lock
	}
	
	func saveContraints() {
		if let c = constraints {
			saveContraint = c
		}
	}
	
	func engage(_ controller: ControllerNode) {
		// Make sure controller isn't occupied
		if controller.occupied == false {
			controller.occupied = true
			isEngaged = true
			animating = true
			run(SKAction.move(to: controller.position, duration: 0.2)) {
				self.animating = false
			}
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

	func prepareForFiring() {
		// Cleans up before firing
		physicsBody?.isDynamic = true
		isEngaged = false
		constraints = nil
		isFired = true
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
			lock.removeFromParent()
			SKTAudio.sharedInstance().playSoundEffect(filename: "Lock.caf")
			
		}
	}
}
