//
//  BlockGlueNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BlockGlueNode: BlockNode {
	
	// Nodes that are connected
	var connected = [Side: SKSpriteNode]()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.blockGlue
	}
	
	// Add a node, based on side
	func add(node: SKSpriteNode, to side: Side) {
		// Make sure there isn't already one on that side
		guard connected[side] == nil else {
			return
		}
		
		let position: CGPoint
		let zRotation: CGFloat
		switch side {
		case .up:
			position = up
			zRotation = CGFloat(0).degreesToRadians()
		case .down:
			position = down
			zRotation = CGFloat(180).degreesToRadians()
		case .left:
			position = left
			zRotation = CGFloat(90).degreesToRadians()
		case .right:
			position = right
			zRotation = CGFloat(270).degreesToRadians()
		}
		
		connected[side] = node
		
		
		node.physicsBody?.isDynamic = false
		
		if node.parent == nil {
			node.position = position
			node.zRotation = zRotation
			addChild(node)
		} else {
			node.move(toParent: self)
			node.run(SKAction.group([SKAction.move(to: position, duration: 0.1), SKAction.rotate(toAngle: zRotation, duration: 0.1)]))
		}
	}
}
