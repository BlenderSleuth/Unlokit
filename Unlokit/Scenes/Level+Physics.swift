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
			let key = (contact.bodyA.categoryBitMask == Category.key
				? contact.bodyA.node : contact.bodyB.node) as! KeyNode
			let lock = (contact.bodyA.categoryBitMask == Category.lock
				? contact.bodyA.node : contact.bodyB.node) as! LockNode
			
				key.lock(lock)
		case Category.blockMtl | Category.key:
			let key = (contact.bodyA.categoryBitMask == Category.key
				? contact.bodyA.node : contact.bodyB.node) as! KeyNode
			key.smash()
		case Category.blockBnc | Category.all:
			//let block = (contact.bodyA.categoryBitMask == Category.blockBnc
			//	? contact.bodyA.node : contact.bodyB.node) as! BlockBncNode
			//let sprite = (contact.bodyB.node == block
			//	? contact.bodyA.node : contact.bodyB.node) as! SKSpriteNode
			
			// TO DO: animate block
			break
		case Category.bounds | Category.key:
			let key = (contact.bodyA.categoryBitMask == Category.key
				? contact.bodyA.node : contact.bodyB.node) as! KeyNode
			
			key.smash()
		case Category.springTool | Category.blockMtl:
			let spring = (contact.bodyA.categoryBitMask == Category.springTool
				? contact.bodyA.node : contact.bodyB.node) as! SpringToolNode
			let block = (contact.bodyA.categoryBitMask == Category.blockMtl
				? contact.bodyA.node : contact.bodyB.node) as! BlockMtlNode
			
			let blockBnc = block.bncVersion()
			block.parent?.addChild(blockBnc)
			block.removeFromParent()
			
			spring.removeFromParent()
		default:
			break
		}
	}
}
