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
	
	var isOccupied = false
	
	var scenePosition: CGPoint!
	
	private var angleLabel: SKLabelNode!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setupRegion(scene: SKScene) {
		scenePosition = scene.convert(position, from: self)
		let sceneOrigin = CGPoint(x: scenePosition.x - frame.width / 2, y: scenePosition.y - frame.height / 2)
		
		// Small region in centre of controller for allowing touch through
		let middleRect = CGRect(origin: sceneOrigin + 300, size: frame.size - 600)
		let middlePath = CGPath(ellipseIn: middleRect, transform: nil)
		let middleRegion = SKRegion(path: middlePath)
		
		// Create path for an SKRegion to detect touches in circle, rather than square
		let regionRect = CGRect(origin: sceneOrigin - 50, size: frame.size + 100)
		
		let path = CGPath(ellipseIn: regionRect, transform: nil)
		let fullRegion = SKRegion(path: path)
		
		region = fullRegion.byDifference(from: middleRegion)
		
		angleLabel = childNode(withName: "angle") as! SKLabelNode
		
		// Show region with SKShapenode
		let regionRectDebug = regionRect
		let debugPath = CGPath(ellipseIn: regionRectDebug, transform: nil)
		let debugNode = SKShapeNode(path: debugPath)
		debugNode.strokeColor = .blue
		debugNode.lineWidth = 5
		scene.addChild(debugNode)
	}
	
	func updateAngle() {
		let angle = Int(zRotation.radiansToDegrees() + 0.5) + 90
		angleLabel.text = "\(angle)"
	}
}
