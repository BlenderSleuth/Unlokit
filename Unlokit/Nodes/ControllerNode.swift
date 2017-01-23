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
	var middleRegion: SKRegion!
	var combinedRegion: SKRegion!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		// Small region in centre of controller for detecting touch
		let middleRect = CGRect(origin: frame.origin + 300, size: frame.size - 600)
		let middlePath = CGPath(ellipseIn: middleRect, transform: nil)
		middleRegion = SKRegion(path: middlePath)
		
		// Create path for an SKRegion to detect touches in circle, rather than square
		let regionRect = CGRect(origin: frame.origin - 50, size: frame.size + 100)
		
		let path = CGPath(ellipseIn: regionRect, transform: nil)
		combinedRegion = SKRegion(path: path)
		
		region = combinedRegion.byDifference(from: middleRegion)
		
		// Show region with SKShapenode
		let regionRectDebug = CGRect(origin: CGPoint(x: -frame.width / 2 - 50, y: -frame.height / 2 - 50),
		                             size: frame.size + 100)
		let debugPath = CGPath(ellipseIn: regionRectDebug, transform: nil)
		let debugNode = SKShapeNode(path: debugPath)
		debugNode.strokeColor = .blue
		debugNode.lineWidth = 5
		addChild(debugNode)
		
		// Physicsbody
		// TO DO: Make this work internally...
		//setupPhysics()

	}
	
	func setupPhysics() {
		let physicsRect = CGRect(origin: CGPoint(x: -frame.width/2, y: -frame.height/2), size: frame.size)
		let physicsPath = CGPath(ellipseIn: physicsRect, transform: nil)
		
		physicsBody = SKPhysicsBody(edgeLoopFrom: physicsPath)
		physicsBody?.isDynamic = false
		physicsBody?.categoryBitMask = Category.controller
		physicsBody?.contactTestBitMask = Category.key
		physicsBody?.collisionBitMask = Category.zero
	}
}
