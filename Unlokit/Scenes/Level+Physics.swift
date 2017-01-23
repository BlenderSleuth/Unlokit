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
		case Category.blockBnc | Category.key:
			let key = (contact.bodyA.categoryBitMask == Category.key
				? contact.bodyA.node : contact.bodyB.node) as! KeyNode
			//Increase key velocity
			key.physicsBody?.velocity *= 1.5
		case Category.bounds | Category.key:
			let key = (contact.bodyA.categoryBitMask == Category.key
				? contact.bodyA.node : contact.bodyB.node) as! KeyNode
			
			key.smash()
		default:
			break
		}
	}
}
