//
//  BeamBlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 12/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BeamBlockNode: BlockNode {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		physicsBody?.categoryBitMask = Category.zero
		physicsBody?.contactTestBitMask = Category.zero
		physicsBody?.collisionBitMask = Category.all// ^ Category.blocks
	}

	func setup(physicsWorld: SKPhysicsWorld) {

		var blocks = [BlockNode]()
		for child in children {
			if let ref = child as? SKReferenceNode {
				if let block = ref.children.first?.children.first as? BlockNode {
					blocks.append(block)
				}
			} else if let block = child as? BlockNode {
				blocks.append(block)
			}
		}
		// Sort them by x position
		blocks.sort {
			$0.position.x > $1.position.x
		}

		var lastBlock: BlockNode?
		for block in blocks {

			block.beamNode = self

			if lastBlock == nil {
				lastBlock = block
			} else {
				let anchor = scene!.convert(block.position, from: block.parent!)

				let physicsJoint = SKPhysicsJointPin.joint(withBodyA: block.physicsBody!,
				                                           bodyB: lastBlock!.physicsBody!,
				                                           anchor: anchor)
				physicsJoint.shouldEnableLimits = true

				physicsWorld.add(physicsJoint)

				lastBlock = block
			}
		}
	}
}
