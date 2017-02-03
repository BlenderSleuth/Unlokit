//
//  Stage1+Physics.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

//Separate file for physics contact, its gonna get heavy...
extension Stage1: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {
		// Find collision
		let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		// Determine if collided between multiple category bit masks
		func collided(with firstCategory: UInt32, and secondCategory: UInt32) -> Bool {
			return (firstCategory & collision != 0) && (secondCategory & collision != 0)
		}
		// Return the node from a category and type
		func getNode<T: Any>(for category: UInt32, type: T.Type) -> T {
			return (contact.bodyA.categoryBitMask & category != 0 ? contact.bodyA.node : contact.bodyB.node) as! T
		}
		// Finds other node based on physics contact
		func getOtherNode<T: Any>(for node: SKNode, type: T.Type) -> T {
			return (contact.bodyB.node == node ? contact.bodyA.node : contact.bodyB.node) as! T
		}
		
		// TODO: Make this neater...
		
		if collided(with: Category.key, and: Category.lock) {
			let key = getNode(for: Category.key, type: KeyNode.self)
			let lock = getNode(for: Category.lock, type: LockNode.self)
			
			key.lock(lock)
		}
		else if collided(with: Category.blockMtl, and: Category.key) ||
				collided(with: Category.bounds, and: Category.key){
			let key = getNode(for: Category.key, type: KeyNode.self)
			
			key.smash()
		}
		else if collided(with: Category.blockBreak, and: Category.key) {
			let key = getNode(for: Category.key, type: KeyNode.self)
			let block = getNode(for: Category.blockBreak, type: BlockNode.self)
			
			if block is BlockBreakBncNode {
				return
			} else if let blockGlue = block as? BlockBreakGlueNode {
				let side = blockGlue.getSide(contact: contact)
				blockGlue.add(node: key, to: side)
				return
			}
			
			key.smash()
		}
		else if collided(with: Category.springTool, and: Category.blockMtl) {
			let spring = getNode(for: Category.springTool, type: SpringToolNode.self)
			let block = getNode(for: Category.blockMtl, type: BlockMtlNode.self)
			
			if spring.used {
				return
			}
			spring.used = true
			
			let blockBnc = block.bncVersion()
			block.parent?.addChild(blockBnc)
			block.removeFromParent()
			
			spring.removeFromParent()
			
			blockBnc.bounce(side: blockBnc.getSide(contact: contact))
		}
		else if collided(with: Category.fanTool, and: Category.blockGlue) {
			let fanTool = getNode(for: Category.fanTool, type: FanToolNode.self)
			let block = getNode(for: Category.blockGlue, type: BlockGlueNode.self)
			
			fanTool.removeFromParent()
			
			if fanTool.used {
				return
			}
			fanTool.used = true
			
			let side = block.getSide(contact: contact)
			
			// Check if side is connected or not
			if block.connected[side] == nil {
				let fanNode = SKNode(fileNamed: "FanRef")?.children.first as! FanNode
				fanNode.removeFromParent()
				
				// Add to block
				block.add(node: fanNode, to: side)
				
				// Setup fan
				fanNode.setup(level: self, block: block, side: side)
			}
		}
		else if collided(with: Category.gravityTool, and: Category.blockGlue) {
			let gravityTool = getNode(for: Category.gravityTool, type: GravityToolNode.self)
			let block = getNode(for: Category.blockGlue, type: BlockGlueNode.self)
			
			let gravityNode = SKNode(fileNamed: "GravityRef")?.children.first as! GravityNode
			block.add(gravityNode: gravityNode)
			
			gravityTool.removeFromParent()
		}
		else if collided(with: Category.fanTool, and: Category.blockMtl) {
			let fanTool = getNode(for: Category.fanTool, type: FanToolNode.self)
			fanTool.smash(scene: self)
		}
		else if collided(with: Category.fan, and: Category.bombTool) {
			let bomb = getNode(for: Category.bombTool, type: BombToolNode.self)
			bomb.explode(scene: self, at: contact.contactPoint)
		}
		else if collided(with: Category.secretTeleport , and: Category.key) {
			// TO DO: new scene
			
			reload()
		}
		else if collided(with: Category.bounds, and: Category.tools) {
			let bounds = getNode(for: Category.bounds, type: SKSpriteNode.self)
			let tool = getOtherNode(for: bounds, type: ToolNode.self)
			
			tool.smash(scene: self)
			// Every tool except fan tool and gravity tool
		}
		else if collided(with: (Category.tools ^ (Category.fanTool | Category.gravityTool)), and: Category.blockGlue) {
			
			let block = getNode(for: Category.blockGlue, type: BlockGlueNode.self)
			let tool = getOtherNode(for: block, type: ToolNode.self)
			
			if tool.used {
				return
			}
			tool.used = true
			
			let side = block.getSide(contact: contact)
			block.add(node: tool, to: side)
			
			if let bombTool = tool as? BombToolNode {
				bombTool.countDown(scene: self, at: contact.contactPoint, side: side)
			}
		}
		else if collided(with: Category.bombTool, and: Category.blockBreak) {
			let bombTool = getNode(for: Category.bombTool, type: BombToolNode.self)
			let block = getOtherNode(for: bombTool, type: Breakable.self)
			
			if bombTool.used {
				return
			}
			bombTool.used = true
			
			if let glue = block as? BlockBreakGlueNode {
				let side = glue.getSide(contact: contact)
				glue.add(node: bombTool, to: side)
				bombTool.countDown(scene: self, at: contact.contactPoint, side: side)
				//bombTool.explode(scene: self, at: contact.contactPoint)
				return
			}
			
			bombTool.explode(scene: self, at: contact.contactPoint)
			
			// Bounce block when hit
		}
		else if collided(with: Category.blockBnc, and: Category.tools ^ Category.bombTool) {
			let block = getNode(for: Category.blockBnc, type: BlockNode.self)
			
			block.bounce(side: block.getSide(contact: contact))
			
		}
		else if collided(with: (Category.blockMtl | Category.blockBreak), and: Category.glueTool) {
			if collided(with: Category.blockGlue, and: Category.glueTool) {
				return
			}
			let glue = getNode(for: Category.glueTool, type: GlueToolNode.self)
			let block = getOtherNode(for: glue, type: BlockMtlNode.self)
			
			if glue.used {
				return
			}
			glue.used = true
			
			let blockGlue = block.glueVersion()
			block.parent?.addChild(blockGlue)
			block.removeFromParent()
			glue.removeFromParent()
			
			let side = blockGlue.getSide(contact: contact)
			blockGlue.bounce(side: side)
			
		}
		else if collided(with: (Category.blockMtl | Category.blockBreak), and: Category.springTool) {
			let spring = getNode(for: Category.springTool, type: SpringToolNode.self)
			if collided(with: Category.blockGlue, and: Category.springTool) {
				return
			}
			let block = getOtherNode(for: spring, type: BlockMtlNode.self)
			
			if spring.used {
				return
			}
			spring.used = true
			
			let blockGlue = block.bncVersion()
			block.parent?.addChild(blockGlue)
			block.removeFromParent()
			spring.removeFromParent()
			
			let side = blockGlue.getSide(contact: contact)
			blockGlue.bounce(side: side)
			
			// Check for all tools/key and speed node
		}
		else if collided(with: (Category.tools | Category.key), and: Category.speed) {
			let speed = getNode(for: Category.speed, type: SpeedNode.self)
			let tool = getOtherNode(for: speed, type: SKSpriteNode.self)
			
			// TO DO: Add particles
			
			// Make tool go higher
			tool.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
		}
	}
}
