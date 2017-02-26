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

	var isShadowed = false
	
	private var angleLabel: SKLabelNode!
	
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
		angleLabel.zPosition = ZPosition.interface
		
		// Show region with SKShapenode
		let regionRectCircle = regionRect
		let circlePath = CGPath(ellipseIn: regionRectCircle, transform: nil)
		let circleNode = SKShapeNode(path: circlePath)
		circleNode.strokeColor = .blue
		circleNode.lineWidth = 5
		scene.addChild(circleNode)

		setupConstraints()
	}

	private func setupConstraints() {
		let range = SKRange(lowerLimit: CGFloat(-90).degreesToRadians(), upperLimit: CGFloat(90).degreesToRadians())
		let constraint = SKConstraint.zRotation(range)

		constraints = [constraint]
	}

	func addLight() {
		let light = SKLightNode()
		light.categoryBitMask = Category.all
		self.addChild(light)

		isShadowed = true
	}

	func updateAngle() {
		let angle = Int(zRotation.radiansToDegrees()) + 90
		angleLabel.text = "\(angle)°"
	}
}
