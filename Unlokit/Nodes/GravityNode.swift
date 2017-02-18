//
//  GravityNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 26/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class GravityNode: SKSpriteNode {
	
	let radius: CGFloat = 500
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		let gravityWave = SKShapeNode(circleOfRadius: radius)
		gravityWave.strokeColor = .black
		gravityWave.lineWidth = 10
		gravityWave.fillColor = .clear
		gravityWave.alpha = 0
		addChild(gravityWave)
		
		let group1 = SKAction.group([SKAction.scale(to: 1, duration: 0), SKAction.fadeOut(withDuration: 0)])
		let group2 = SKAction.group([SKAction.fadeIn(withDuration: 0.5), SKAction.scale(to: 0.01, duration: 2)])
		let sequence1 = SKAction.sequence([group1, group2])
		let action = SKAction.repeatForever(sequence1)

		let fadeIn = SKAction.fadeIn(withDuration: 0.4)

		let sequence2 = SKAction.group([fadeIn, action])

		gravityWave.run(sequence2)
		
		let fieldRegion = SKRegion(radius: Float(radius))
		
		let field = SKFieldNode.radialGravityField()
		field.region = fieldRegion
		field.strength = 550
		field.falloff = 3
		field.categoryBitMask = Category.fanGravityField
		addChild(field)
		
		// Debug node
		//let debugNode = SKShapeNode(circleOfRadius: size.width * 5)
		//debugNode.strokeColor = .blue
		//debugNode.lineWidth = 5
		//addChild(debugNode)
	}
}
