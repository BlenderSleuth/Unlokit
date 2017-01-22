//
//  KeyNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 22/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class KeyNode: SKSpriteNode {
	
	var isEngaged: Bool = false {
		didSet {
			if isEngaged {
				constraints = nil
			} else {
				constraints = saveContraint
			}
			
		}
	}
	
	var isEngaging: Bool {
		if (self.action(forKey: "engaging") != nil) || (self.action(forKey: "disengaging") != nil) {
			print("engaging")
			return true
		}
		return false
	}
	
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
		physicsBody?.isDynamic = false
		physicsBody?.categoryBitMask = Category.key1
		physicsBody?.contactTestBitMask = Category.controller
		physicsBody?.collisionBitMask = Category.controller
	}
}
