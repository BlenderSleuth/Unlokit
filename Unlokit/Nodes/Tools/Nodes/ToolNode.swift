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
	
	var isFired = false
	
	var isEngaged = false
	var animating = false
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
	
	func engage(_ controller: ControllerNode, icon: ToolIcon) {
		// Make sure controller isn't occupied
		if controller.occupied == false {
			isEngaged = true
			animating = true
			controller.occupied = true
			run(SKAction.move(to: controller.position, duration: 0.2)) {
				self.animating = false
			}
			icon.number -= 1
		}
	}
	func disengage(to icon: ToolIcon, controller: ControllerNode) {
		animating = true
		// Convert icon positino to scene coordinates
		let position = scene!.convert(icon.position, from: icon.parent!)
		run(SKAction.move(to: position, duration: 0.2)) {
			self.animating = false
			icon.number += 1
			self.removeFromParent()
		}
		isEngaged = false
		controller.occupied = false
	}
	
	func prepareForFiring(_ controller: ControllerNode) {
		setupPhysics()
		isEngaged = false
		isFired = true
		controller.occupied = false
	}
	func setupPhysics() {
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.isDynamic = true
		// Override in subclasses
		physicsBody?.categoryBitMask = Category.zero
		physicsBody?.contactTestBitMask = Category.zero
		physicsBody?.collisionBitMask = Category.all
	}

}
