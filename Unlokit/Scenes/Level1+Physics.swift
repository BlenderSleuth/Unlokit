//
//  GameScene+Physics.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

//Separate file for physics contact, its gonna get heavy...
extension Level1: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {
		let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		switch collision {
		case Category.key1 | Category.lock1:
			let key = (contact.bodyA.categoryBitMask == Category.key1
				? contact.bodyA.node : contact.bodyB.node) as! KeyNode
			let lock = (contact.bodyA.categoryBitMask == Category.lock1
				? contact.bodyA.node : contact.bodyB.node) as! LockNode
			
				key.lock(lock)
	
		default:
			break
		}
	}
}
