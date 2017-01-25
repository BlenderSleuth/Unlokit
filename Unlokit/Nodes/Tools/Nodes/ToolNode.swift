//
//  ToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 13/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

enum ToolType: String {
	case spring		= "SpringTool"
	case glue		= "GlueTool"
	case fan		= "FanTool"
	case gravity	= "GravityTool"
    case time		= "TimeTool"
}

// Only use this for subclassing...
class ToolNode: SKSpriteNode, CanBeFired {
    
    var type: ToolType!
	
	var isEngaged = false
	var animating = false
	
	var icon: ToolIcon!
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
	
	func engage(_ controller: ControllerNode) {
		isEngaged = true
		animating = true
		controller.isOccupied = true
		run(SKAction.move(to: controller.scenePosition, duration: 0.2)) {
			self.animating = false
		}
		icon.number -= 1
		
		run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(360).degreesToRadians(), duration: 3)), withKey: "rotate")
	}
	func disengage(_ controller: ControllerNode) {
		animating = true
		// Convert icon position to scene coordinates
		let position = scene!.convert(icon.position, from: icon.parent!)
		run(SKAction.move(to: position, duration: 0.2)) {
			self.animating = false
			self.icon.number += 1
			self.removeFromParent()
		}
		isEngaged = false
		controller.isOccupied = false
	}
	
	func prepareForFiring(_ controller: ControllerNode) {
		setupPhysics()
		isEngaged = false
		controller.isOccupied = false
		removeAction(forKey: "rotate")
	}
	func setupPhysics() {
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.isDynamic = true
		physicsBody?.mass = 0.5
		// Override in subclasses
		physicsBody?.categoryBitMask = Category.zero
		physicsBody?.contactTestBitMask = Category.bounds
		physicsBody?.collisionBitMask = Category.all
	}

	func smash() {
		removeFromParent()
		
		//TO DO: play sound and particle
	}
}
