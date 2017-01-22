//
//  KeyNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 22/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class KeyNode: SKSpriteNode {
	var lastTouchPoint = CGPoint.zero
	
	// Weak variable to stop strong reference cycle :/
	// Has to be set from scene
	weak var scn: SKScene!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		// Physicsbody
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.isDynamic = false
		physicsBody?.categoryBitMask = Category.key1
		physicsBody?.contactTestBitMask = Category.controller
		physicsBody?.collisionBitMask = Category.controller
		
		// Allows for touch events
		isUserInteractionEnabled = true
	}
	
	
	//MARK: Touch events
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			lastTouchPoint = touch.location(in: scn)
		}
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let location = touch.location(in: scn)
			self.position = location
		}
	}
}
