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
	
	var occupied = false
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		// Small region in centre of controller for allowing touch through
		let middleRect = CGRect(origin: frame.origin + 300, size: frame.size - 600)
		let middlePath = CGPath(ellipseIn: middleRect, transform: nil)
		let middleRegion = SKRegion(path: middlePath)
		
		// Create path for an SKRegion to detect touches in circle, rather than square
		let regionRect = CGRect(origin: frame.origin, size: frame.size)
		
		let path = CGPath(ellipseIn: regionRect, transform: nil)
		let fullRegion = SKRegion(path: path)
		
		region = fullRegion.byDifference(from: middleRegion)
		
		// Show region with SKShapenode
		let regionRectDebug = CGRect(origin: CGPoint(x: -frame.width / 2, y: -frame.height / 2),
		                             size: frame.size)
		let debugPath = CGPath(ellipseIn: regionRectDebug, transform: nil)
		let debugNode = SKShapeNode(path: debugPath)
		debugNode.strokeColor = .blue
		debugNode.lineWidth = 5
		addChild(debugNode)
	}
}
