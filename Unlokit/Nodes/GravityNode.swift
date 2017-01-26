//
//  GravityNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 26/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class GravityNode: SKSpriteNode {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		let gravityWave = SKShapeNode(circleOfRadius: size.width / 2)
		gravityWave.strokeColor = .black
		gravityWave.fillColor = .clear
		addChild(gravityWave)
		
		let group1 = SKAction.group([SKAction.scale(to: 10, duration: 0), SKAction.fadeOut(withDuration: 0)])
		let group2 = SKAction.group([SKAction.fadeIn(withDuration: 0.5), SKAction.scale(to: 1, duration: 1.3)])
		let sequence = SKAction.sequence([group1, group2])
		let action = SKAction.repeatForever(sequence)
		
		gravityWave.run(action)
		
		let fieldRegion = SKRegion(radius: Float(size.width * 5))
		
		let field = SKFieldNode.radialGravityField()
		field.region = fieldRegion
		field.strength = 750
		field.categoryBitMask = Category.gravityField
		addChild(field)
		
		// Debug node
		//let debugNode = SKShapeNode(circleOfRadius: size.width * 5)
		//debugNode.strokeColor = .blue
		//debugNode.lineWidth = 5
		//addChild(debugNode)
	}
}
