//
//  Level+Physics.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

//Separate file for physics contact, its gonna get heavy...
extension Level: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {
		// Find collision
		let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		switch collision {
		case Category.key | Category.lock:
			let key = getNode(for: Category.key, type: KeyNode.self, contact: contact)
			let lock = getNode(for: Category.lock, type: LockNode.self, contact: contact)
			
			key.lock(lock)
		case Category.blockMtl | Category.key, Category.bounds | Category.key:
			let key = getNode(for: Category.key, type: KeyNode.self, contact: contact)
			
			key.smash()
		case Category.blockBnc | Category.all:
			//let block = (contact.bodyA.categoryBitMask == Category.blockBnc
			//	? contact.bodyA.node : contact.bodyB.node) as! BlockBncNode
			//let sprite = (contact.bodyB.node == block
			//	? contact.bodyA.node : contact.bodyB.node) as! SKSpriteNode
			
			// TO DO: animate block
			break
		case Category.springTool | Category.blockMtl:
			let spring = getNode(for: Category.springTool, type: SpringToolNode.self, contact: contact)
			let block = getNode(for: Category.blockMtl, type: BlockMtlNode.self, contact: contact)
			
			let blockBnc = block.bncVersion()
			block.parent?.addChild(blockBnc)
			block.removeFromParent()
			
			spring.removeFromParent()
		case Category.glueTool | Category.blockMtl:
			let glue = getNode(for: Category.glueTool, type: GlueToolNode.self, contact: contact)
			let block = getNode(for: Category.blockMtl, type: BlockMtlNode.self, contact: contact)
			
			let blockGlue = block.glueVersion()
			block.parent?.addChild(blockGlue)
			block.removeFromParent()
			
			glue.removeFromParent()
		case Category.blockGlue | Category.key:
			let key = getNode(for: Category.key, type: KeyNode.self, contact: contact)
			let block = getNode(for: Category.blockGlue, type: BlockGlueNode.self, contact: contact)
			
			key.physicsBody?.velocity = CGVector.zero
			
			let joint = SKPhysicsJointPin.joint(withBodyA: key.physicsBody!, bodyB: block.physicsBody!, anchor: convert(key.position, from: key.parent!))
			physicsWorld.add(joint)
		case Category.fanTool | Category.blockGlue:
			break
		case Category.springTool | Category.bounds, Category.glueTool | Category.bounds, Category.fanTool | Category.bounds:
			let bounds = getNode(for: Category.bounds, type: SKSpriteNode.self, contact: contact)
			let tool = getOtherNode(for: bounds, type: ToolNode.self, contact: contact)
			
			tool.smash()
		default:
			break
		}
	}
	
	// Return the node from a category and type
	func getNode<T: SKNode>(for category: UInt32, type: T.Type, contact: SKPhysicsContact) -> T {
		return (contact.bodyA.categoryBitMask == category ? contact.bodyA.node : contact.bodyB.node) as! T
	}
	// Finds other node based on physics contact
	func getOtherNode<T: SKNode>(for node: SKNode, type: T.Type, contact: SKPhysicsContact) -> T {
		return (contact.bodyB.node == node ? contact.bodyA.node : contact.bodyB.node) as! T
	}
}
