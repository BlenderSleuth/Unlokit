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
		case Category.springTool | Category.blockMtl:
			let spring = getNode(for: Category.springTool, type: SpringToolNode.self, contact: contact)
			let block = getNode(for: Category.blockMtl, type: BlockMtlNode.self, contact: contact)
			
			if spring.used {
				return
			}
			spring.used = true
			
			let blockBnc = block.bncVersion()
			block.parent?.addChild(blockBnc)
			block.removeFromParent()
			
			spring.removeFromParent()
			
			blockBnc.bounce(side: blockBnc.getSide(contact: contact))
		case Category.glueTool | Category.blockMtl:
			let glue = getNode(for: Category.glueTool, type: GlueToolNode.self, contact: contact)
			let block = getNode(for: Category.blockMtl, type: BlockMtlNode.self, contact: contact)
			
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
			
		case Category.blockGlue | Category.key:
			let key = getNode(for: Category.key, type: KeyNode.self, contact: contact)
			let block = getNode(for: Category.blockGlue, type: BlockGlueNode.self, contact: contact)
			let side = block.getSide(contact: contact)
			
			block.add(node: key, to: side)
			
		case Category.fanTool | Category.blockGlue:
			let fanTool = getNode(for: Category.fanTool, type: FanToolNode.self, contact: contact)
			let block = getNode(for: Category.blockGlue, type: BlockGlueNode.self, contact: contact)
			
			fanTool.removeFromParent()
			
			if fanTool.used {
				return
			}
			fanTool.used = true
			
			// Setup fan node
			let fanNode = SKNode(fileNamed: "FanRef")?.children.first as! FanNode
			fanNode.removeFromParent()
			
			fanNode.animate(framesAtlas: fanFrames)
			fanNode.setupParticles(scene: self)
			
			let side = block.getSide(contact: contact)
			block.add(node: fanNode, to: side)
		case Category.gravityTool | Category.blockGlue:
			let gravityTool = getNode(for: Category.gravityTool, type: GravityToolNode.self, contact: contact)
			let block = getNode(for: Category.blockGlue, type: BlockGlueNode.self, contact: contact)
			
			let gravityNode = SKNode(fileNamed: "GravityRef")?.children.first as! GravityNode
			block.add(gravityNode: gravityNode)
			
			gravityTool.removeFromParent()
			
		case Category.fanTool | Category.blockMtl:
			let fanTool = getNode(for: Category.fanTool, type: FanToolNode.self, contact: contact)
			fanTool.smash()
		default:
			// Custom checks, more efficient
			if Category.tools & collision != 0 && collision & Category.bounds != 0 {
				let bounds = getNode(for: Category.bounds, type: SKSpriteNode.self, contact: contact)
				let tool = getOtherNode(for: bounds, type: ToolNode.self, contact: contact)
				
				tool.smash()
				// Every tool except fan tool and gravity tool										and if it collides with block glue
			} else if (Category.tools ^ (Category.fanTool | Category.gravityTool)) & collision != 0 && collision & Category.blockGlue != 0{
				let block = getNode(for: Category.blockGlue, type: BlockGlueNode.self, contact: contact)
				let tool = getOtherNode(for:block, type: ToolNode.self, contact: contact)
				
				if tool.used {
					return
				}
				tool.used = true
				
				let side = block.getSide(contact: contact)
				block.add(node: tool, to: side)
			// Bounce block when hit
			} else if Category.blockBnc & collision != 0 {
				let block = getNode(for: Category.blockBnc, type: BlockNode.self, contact: contact)
				block.bounce(side: block.getSide(contact: contact))
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
