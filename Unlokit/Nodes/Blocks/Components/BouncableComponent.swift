//
//  BouncableComponent.swift
//  Unlokit
//
//  Created by Ben Sutherland on 27/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit
import GameplayKit

class BouncableComponent: GKComponent {
	var spriteComponent: GKSKNodeComponent!
	
	override init() {
		super.init()
		
		spriteComponent = entity?.component(ofType: GKSKNodeComponent.self)!
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		
	}
	
	// Create version of self that has kind of bncNode
	func bncVersion() -> SKSpriteNode {
		let spriteComponent = entity?.component(ofType: GKSKNodeComponent.self)!
		
		let blockBnc = (GKScene(fileNamed: "BlockBnc")?.rootNode as! SKScene).children.first as! SKSpriteNode
		blockBnc.removeFromParent()
		blockBnc.position = spriteComponent!.node.position
		blockBnc.zPosition = spriteComponent!.node.zPosition
		return blockBnc
	}
	
	func bounce(side: Side) {
		let bounce: SKAction
		
		switch side{
		case .up:
			bounce = SKAction.sequence([SKAction.moveBy(x: 0, y: -30, duration: 0.1), SKAction.moveBy(x: 0, y: 30, duration: 0.1)])
			bounce.timingMode = .easeInEaseOut
		case .down:
			bounce = SKAction.sequence([SKAction.moveBy(x: 0, y: 30, duration: 0.1), SKAction.moveBy(x: 0, y: -30, duration: 0.1)])
			bounce.timingMode = .easeInEaseOut
		case .left:
			bounce = SKAction.sequence([SKAction.moveBy(x: -30, y: 0, duration: 0.1), SKAction.moveBy(x: 30, y: 0, duration: 0.1)])
			bounce.timingMode = .easeInEaseOut
		case .right:
			bounce = SKAction.sequence([SKAction.moveBy(x: 30, y: 0, duration: 0.1), SKAction.moveBy(x: -30, y: 0, duration: 0.1)])
			bounce.timingMode = .easeInEaseOut
		}
		spriteComponent.node.run(bounce)
	}
}
