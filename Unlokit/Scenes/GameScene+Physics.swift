//
//  GameScene+Physics.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

//Separate file for physics contact, its gonna get heavy...
extension GameScene: SKPhysicsContactDelegate {
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
		// Return the node from a category and type optional
		func getNodeIf<T: Any>(for category: UInt32, type: T.Type) -> T? {
			return (contact.bodyA.categoryBitMask & category != 0 ? contact.bodyA.node : contact.bodyB.node) as? T
		}
		// Finds other node based on physics contact
		func getOtherNode<T: Any>(for node: SKNode, type: T.Type) -> T {
			return (contact.bodyB.node == node ? contact.bodyA.node : contact.bodyB.node) as! T
		}
		// Finds other node based on physics contact optional
		func getOtherNodeIf<T: Any>(for node: SKNode, type: T.Type) -> T? {
			return (contact.bodyB.node == node ? contact.bodyA.node : contact.bodyB.node) as? T
		}

		// Lock key ************************
		if collided(with: Category.key, and: Category.lock) {
			let key = getNode(for: Category.key, type: KeyNode.self)
			let lock = getNode(for: Category.lock, type: LockNode.self)

			key.lock(lock)
		}
		else if collided(with: Category.bounds, and: Category.tools) {
			let bounds = getNode(for: Category.bounds, type: SKSpriteNode.self)
			let tool = getOtherNode(for: bounds, type: ToolNode.self)

			tool.smash(scene: self)
		}
		else if collided(with: Category.blockMtl | Category.blockBreak, and: Category.fanTool | Category.gravityTool) {
			let tool = getNode(for: Category.tools, type: ToolNode.self)
			tool.smash(scene: self)
		}
		// Secret level ********************
		else if collided(with: Category.secretTeleport , and: Category.key) {
			levelController.startNewGame(levelname: "Level\(level.stageNumber)_S")
			levelController.level.isSecret = true
		}
		// Blow up conditions **************
		else if collided(with: Category.blockBreak | Category.fan, and: Category.bombTool) {
			let bombTool = getNode(for: Category.bombTool, type: BombToolNode.self)

			if bombTool.used {
				return
			}
			bombTool.used = true

			bombTool.explode(scene: self, at: contact.contactPoint)
		}
		// Stick to a glue block
		else if collided(with: Category.blockGlue, and: Category.tools | Category.key) {
			let block = getNode(for: Category.blockGlue, type: BlockGlueNode.self)

			if let tool = getNodeIf(for: Category.tools, type: ToolNode.self) {
				// This will get an optional side
				if let side = block.getSideIfConnected(contact: contact) {
					// Make sure it hasn't already been used
					if tool.used {
						return
					}
					tool.used = true

					// Check for other tools
					if let bombTool = tool as? BombToolNode {
						if block.add(node: bombTool, to: side) {
							bombTool.countDown(scene: self, at: contact.contactPoint, side: side)
						} else {
							bombTool.startTimer(glueBlock: block, side: side)
						}
					} else if let fanTool = tool as? FanToolNode {
						let fanNode = SKNode(fileNamed: "FanRef")?.children.first as! FanNode
						fanNode.removeFromParent()

						// Add to block
						if block.add(node: fanNode, to: side) {
							// Setup fan
							fanNode.setup(level: self, block: block, side: side)

							fanTool.remove()
						}
					} else if let gravityTool = tool as? GravityToolNode {
						let gravityNode = SKNode(fileNamed: "GravityRef")?.children.first as! GravityNode
						gravityNode.removeFromParent()

						if block.add(gravityNode: gravityNode) {
							gravityTool.remove()
						}
					} else {
						let _ = block.add(node: tool, to: side)
						tool.startTimer(glueBlock: block, side: side)
					}
				}
			} else if let key = getNodeIf(for: Category.key, type: KeyNode.self) {
				if let side = block.getSideIfConnected(contact: contact) {
					let _ = block.add(node: key, to: side)
					key.startTimer(glueBlock: block, side: side)
				}
			}
		}
		else if collided(with: Category.blockMtl | Category.blockBreak, and: Category.glueTool) {
			let glue = getNode(for: Category.glueTool, type: GlueToolNode.self)
			let block = getOtherNode(for: glue, type: BlockMtlNode.self)

			if glue.used {
				return
			}
			glue.used = true

			let blockGlue = block.glueVersion(scene: self)
			block.parent?.addChild(blockGlue)

			block.removeFromParent()
			glue.removeFromParent()

			let side = blockGlue.getSide(contact: contact)
			blockGlue.bounce(side: side)
			
		}
		// Create spring block *************
		else if collided(with: Category.blockMtl | Category.blockBreak, and: Category.springTool) {
			let spring = getNode(for: Category.springTool, type: SpringToolNode.self)
			if let block = getOtherNodeIf(for: spring, type: BlockMtlNode.self) {
				if spring.used {
					return
				}
				spring.used = true

				let blockBnc = block.bncVersion(scene: self)
				block.parent?.addChild(blockBnc)

				block.removeFromParent()
				spring.removeFromParent()

				let side = blockBnc.getSide(contact: contact)
				blockBnc.bounce(side: side)
			} else {
				let block = getOtherNode(for: spring, type: BlockBncNode.self)
				block.bounce(side: block.getSide(contact: contact))
			}
		}
		// Speed node collision ************
		else if collided(with: Category.speed, and: Category.tools | Category.key) {
			let speed = getNode(for: Category.speed, type: SpeedNode.self)
			let tool = getOtherNode(for: speed, type: SKSpriteNode.self)

			// TODO: Add particles

			// Make tool go higher
			tool.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
		}
		// This needs to be at the end so that bombs don't explode on normal bounce
		else if collided(with: Category.blockBnc, and: Category.tools | Category.key) {
			let block = getNode(for: Category.blockBnc, type: BlockNode.self)

			let canBeFired = getOtherNode(for: block, type: CanBeFired.self)
			// Start timer to smash so that it's not stuck forever
			canBeFired.startTimer()

			// Bounce animation
			block.bounce(side: block.getSide(contact: contact))
		} // Smash conditions ****************
		else if collided(with: Category.blockMtl, and: Category.key) ||
			collided(with: Category.blockBreak, and: Category.key) ||
			collided(with: Category.bounds, and: Category.key) {
			let key = getNode(for: Category.key, type: KeyNode.self)
			key.smash(scene: self)
		}
	}
}
