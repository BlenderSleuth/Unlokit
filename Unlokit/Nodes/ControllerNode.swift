//
//  ControllerNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 22/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class ControllerNode: SKSpriteNode, NodeSetup {
	var region: SKRegion!
	
	var isOccupied = false
	
	var scenePosition: CGPoint!

	var isShadowed = false
	
	var angle: Int = 90 {
		didSet {
			// Rotate controller
			zRotation = CGFloat(angle).degreesToRadians() - CGFloat(90).degreesToRadians()
			// Update angle
			angleLabel.text = "\(angle)°"
		}
	}
	
	private var angleLabel: SKLabelNode!

	func setup(scene: GameScene) {
		setupRegion(scene: scene)
	}
	
	private func setupRegion(scene: GameScene) {
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
	}

	func addLight() {
		let light = SKLightNode()
		light.falloff = 1.2
		light.categoryBitMask = Category.controllerLight
		addChild(light)

		isShadowed = true
	}
}
