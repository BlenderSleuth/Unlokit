//
//  ToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 13/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

enum ToolType {
	case spring
	case glue
	case fan
	case gravity
    case time
}

// Only use this for subclassing...
class ToolNode: SKSpriteNode {
    
    var type: ToolType!
	
	// If icon or movable
	var movable = false {
		didSet {
			if movable == true && savedConstraints != nil{
				self.constraints = savedConstraints
			}
		}
	}
	
	var savedConstraints: [SKConstraint]!
	
	private var label: SKLabelNode!
	var number = 0 {
		didSet{
			label.text = "\(number)"
			print(number)
		}
	}
	/*
	override func copy(with zone: NSZone? = nil) -> Any {
		
		let copy = ToolNode(coder: )!
		copy.type = type
		copy.setupPhysics()
		return copy
	}*/
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		
		// Set label
		label = childNode(withName: "label") as! SKLabelNode
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
