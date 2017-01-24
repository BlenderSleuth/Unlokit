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
class ToolNode: SKSpriteNode {
    
    var type: ToolType!
	
	var savedConstraints: [SKConstraint]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
	
	func setupPhysics() {
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.isDynamic = false
		// Override in subclasses
		physicsBody?.categoryBitMask = Category.zero
		physicsBody?.contactTestBitMask = Category.zero
		physicsBody?.collisionBitMask = Category.zero
	}
    
}
