//
//  ControllerNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 22/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class ControllerNode: SKSpriteNode {
	var region: SKRegion!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		// Create path for an SKRegion to detect touches in circle, rather than square

		let regionRect = CGRect(origin: frame.origin - 50, size: frame.size + 100)
		
		let path = CGPath(ellipseIn: regionRect, transform: nil)
		region = SKRegion(path: path)
		
		//Show region with SKShapenode
		let regionRectDebug = CGRect(origin: CGPoint(x: -frame.width / 2 - 50, y: -frame.height / 2 - 50),
		                             size: frame.size + 100)
		let debugPath = CGPath(ellipseIn: regionRectDebug, transform: nil)
		let debugNode = SKShapeNode(path: debugPath)
		debugNode.strokeColor = .blue
		debugNode.lineWidth = 5
		addChild(debugNode)
		
		// Physicsbody
		// TO DO: Make this work internally...
		//physics()

	}
	
	func physics() {
		let physicsRect = CGRect(origin: CGPoint(x: -frame.width/2, y: -frame.height/2), size: frame.size)
		let physicsPath = CGPath(ellipseIn: physicsRect, transform: nil)
		
		physicsBody = SKPhysicsBody(edgeLoopFrom: physicsPath)
		physicsBody?.isDynamic = false
		physicsBody?.categoryBitMask = Category.controller
		physicsBody?.contactTestBitMask = Category.key1 | Category.key2 | Category.key3
		physicsBody?.collisionBitMask = Category.key1 | Category.key2 | Category.key3
	}
}
