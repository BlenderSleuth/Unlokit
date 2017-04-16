//
//  GameScene+Physics.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

#if DEBUG
	let cheat = false
#endif
	
// Separate file for physics contact, its gonna get heavy...
extension GameScene: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {
		// Find collision
		let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

		//* Determine if collided between multiple category bit masks
		func collided(with firstCategory: UInt32, and secondCategory: UInt32) -> Bool {
			return (firstCategory & collision != 0) && (secondCategory & collision != 0)
		}
		//* Return the node from a category and type
		func getNode<T: Any>(for category: UInt32, type: T.Type) -> T {
			return (contact.bodyA.categoryBitMask & category != 0 ? contact.bodyA.node : contact.bodyB.node) as! T
		}
		//* Return the node from a category and type optional
		func getNodeIf<T: Any>(for category: UInt32, type: T.Type) -> T? {
			return (contact.bodyA.categoryBitMask & category != 0 ? contact.bodyA.node : contact.bodyB.node) as? T
		}
		//* Finds other node based on physics contact
		func getOtherNode<T: Any>(for node: SKNode, type: T.Type) -> T {
			return (contact.bodyB.node == node ? contact.bodyA.node : contact.bodyB.node) as! T
		}
		//* Finds other node based on physics contact optional
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
		// Blow up conditions **************
		else if collided(with: Category.breakBlock | Category.fan, and: Category.bombTool) {
			let bombTool = getNode(for: Category.bombTool, type: BombToolNode.self)

			if bombTool.used {
				return
			}
			bombTool.used = true

			bombTool.explode(scene: self, at: contact.contactPoint)
		}
		else if collided(with: Category.bncBlock, and: Category.tools | Category.key) {
			let block = getNode(for: Category.bncBlock, type: BlockNode.self)

			let canBeFired = getOtherNode(for: block, type: CanBeFired.self)
			// Start timer to smash so that it's not stuck forever
			canBeFired.startTimer()

			// Bounce animation
			block.bounce(side: block.getSide(contact: contact))
		}
		else if collided(with: Category.mtlBlock | Category.breakBlock, and: Category.fanTool | Category.gravityTool) {
			let tool = getNode(for: Category.tools, type: ToolNode.self)
			tool.smash(scene: self)
		}
		// Secret level ********************
		else if collided(with: Category.secretTeleport , and: Category.key) {
			levelController.startNewGame(levelname: "Level\(level.stageNumber)_S")
			levelController.level.isSecret = true
		}
		// Stick to a glue block
		else if collided(with: Category.gluBlock, and: Category.tools | Category.key) {
			let block = getNode(for: Category.gluBlock, type: GlueBlockNode.self)

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
		// Create spring block *************
		else if collided(with: Category.mtlBlock | Category.breakBlock, and: Category.springTool) {
			let spring = getNode(for: Category.springTool, type: SpringToolNode.self)
			if let block = getOtherNodeIf(for: spring, type: MtlBlockNode.self) {
				if spring.used {
					return
				}
				spring.used = true

				let bncBlock = block.bncVersion(scene: self)
				block.parent?.addChild(bncBlock)

				block.removeFromParent()
				spring.removeFromParent()

				let side = bncBlock.getSide(contact: contact)
				bncBlock.bounce(side: side)
			} else {
				let block = getOtherNode(for: spring, type: BncBlockNode.self)
				block.bounce(side: block.getSide(contact: contact))
			}
		}
		else if collided(with: Category.mtlBlock | Category.breakBlock, and: Category.glueTool) {
			let glue = getNode(for: Category.glueTool, type: GlueToolNode.self)
			let block = getOtherNode(for: glue, type: MtlBlockNode.self)

			if glue.used {
				return
			}
			glue.used = true

			let gluBlock = block.glueVersion(scene: self)
			block.parent?.addChild(gluBlock)

			block.removeFromParent()
			glue.remove()

			let side = gluBlock.getSide(contact: contact)
			gluBlock.bounce(side: side)
			gluBlock.checkConnected(scene: self)
		}
		else if collided(with: Category.bombTool, and: Category.tools) {
			let bomb = getNode(for: Category.bombTool, type: BombToolNode.self)
			bomb.explode(scene: self)
		}
		// Speed node collision ************
		/* Not Needed anymore
		else if collided(with: Category.speed, and: Category.tools | Category.key) {
			let speed = getNode(for: Category.speed, type: SpeedNode.self)
			let tool = getOtherNode(for: speed, type: SKSpriteNode.self)

			//Add particles and sound

			// Make tool go higher
			tool.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
		}
		*/
			
		// Smash conditions ****************
		else if collided(with: Category.mtlBlock, and: Category.key) ||
				collided(with: Category.breakBlock, and: Category.key) ||
				collided(with: Category.bounds, and: Category.key) {
			let key = getNode(for: Category.key, type: KeyNode.self)
			key.smash(scene: self)
		}
	}
}
