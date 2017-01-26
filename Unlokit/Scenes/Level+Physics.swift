//
//  Level+Physics.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit
import GameplayKit

//Separate file for physics contact, its gonna get heavy...
extension Level: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {
		// Find collision
		let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		switch collision {
		default:
			// Custom checks, more efficient
			if collision == Category.blockMtl | Category.springTool {
				let spring = getNode(for: Category.springTool, type: SpringToolNode.self, contact: contact)
				let block = getNode(for: Category.blockMtl, type: SKSpriteNode.self, contact: contact)
				
				if spring.used {
					return
				}
				spring.used = true
				
				print(block.entity ?? "nil")
				
				let blockBnc = block.entity!.component(ofType: BouncableComponent.self)!.bncVersion()
				block.parent?.addChild(blockBnc)
				block.removeFromParent()
				spring.removeFromParent()
				
				
				//let side = blockBnc.getSide(contact: contact)
				//blockBnc.bounce(side: side)
			}
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
