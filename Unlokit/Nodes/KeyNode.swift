//
//  KeyNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 22/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class KeyNode: SKSpriteNode, CanBeFired {
	
	var isEngaged: Bool = false {
		didSet {
			if isEngaged {
				constraints = nil
			} else {
				constraints = saveContraint
			}
			
		}
	}
	
	// Check if key is animating
	var isEngaging: Bool {
		if self.action(forKey: "engaging") != nil {
			return true
		}
		return false
	}
	
	var isDisengaging: Bool {
		if self.action(forKey: "disengaging") != nil {
			return true
		}
		return false
	}
	
	var inside = false
	
	var isFired = false
	
	// To save constraints when not using them
	var saveContraint = [SKConstraint]()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		// Allows for touch events
		//isUserInteractionEnabled = true
		
		// TO DO: Make this work internally...
		//setupPhysics()
		
		
	}
	
	func saveContraints() {
		if let c = constraints {
			saveContraint = c
		}
	}
	
	func engage(location: CGPoint, controller: ControllerNode) {
		guard !isEngaging else {
			return
		}
		
		if !isEngaged {
			position = location
			
			// Check if user touched centre of controller
			if controller.middleRegion.contains(location) {
				// Animate to centre
				run(SKAction.move(to: controller.position, duration: 1), withKey: "engaging")
				isEngaged = true
			}
		} else {
			// Check if user touched outside of controller
			if !controller.region.contains(location) {
				// Animate outside
				run(SKAction.move(to: location, duration: 1), withKey: "disengaging")
				isEngaged = false
			}
		}
		
	}
	
	func setupPhysics() {
		// Physicsbody
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.allowsRotation = false
		physicsBody?.isDynamic = false
		physicsBody?.density = 0.1
		physicsBody?.categoryBitMask = Category.key1
		physicsBody?.contactTestBitMask = Category.lock1
		physicsBody?.collisionBitMask = Category.all ^ Category.controller //All except controller
	}
	
	func prepareForFiring() {
		// Cleans up before firing
		physicsBody?.isDynamic = true
		isEngaged = false
		constraints = nil
		isFired = true
	}
	
	func lock(_ lock: LockNode) {
		physicsBody = nil
		
		let move = SKAction.move(to: lock.position, duration: 0.2)
		let action = SKAction.sequence([move,SKAction.customAction(withDuration: 0, actionBlock: {_,_ in self.removeAllActions()})])
		run(action) {
			lock.removeFromParent()
		}
	}
}
