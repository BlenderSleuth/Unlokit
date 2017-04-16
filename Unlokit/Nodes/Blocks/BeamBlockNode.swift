//
//  BeamBlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 12/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BeamBlockNode: BlockNode {
	var pinnedBlock: BlockNode?

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		physicsBody?.categoryBitMask = Category.beamBlock
		physicsBody?.contactTestBitMask = Category.zero
		physicsBody?.collisionBitMask = Category.all
	}

	func setup(scene: GameScene) {
		// Create array of blocks
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
		// Blocks are sorted by their position in the children array
		// blocks.sort {}

		var lastBlock: BlockNode?
		for block in blocks {
			// Remove existing joints
			/*
			if !block.physicsBody!.joints.isEmpty, let joint = block.physicsBody?.joints[0] {
				if !(block is GlueBlockNode) {
					scene.physicsWorld.remove(joint)
				}
			}
			*/
			if block.physicsBody!.pinned {
				pinnedBlock = block
			}

			block.physicsBody?.isDynamic = true
			block.beamNode = self

			if lastBlock == nil {
				lastBlock = block
			} else {
				let anchor = scene.convert(block.position, from: block.parent!)

				let physicsJoint = SKPhysicsJointPin.joint(withBodyA: block.physicsBody!,
				                                           bodyB: lastBlock!.physicsBody!,
				                                           anchor: anchor)
				physicsJoint.shouldEnableLimits = true

				scene.physicsWorld.add(physicsJoint)

				lastBlock = block
			}
		}

		lastBlock = nil
		getDataFromParent()
	}

	private func getDataFromParent() {
		var data: NSDictionary?

		// Find user data from parents
		var tempNode: SKNode = self
		while !(tempNode is SKScene) {
			if let userData = tempNode.userData {
				data = userData
			}
			tempNode = tempNode.parent!
		}

		// Set instance properties
		if let torque = data?["torque"] as? CGFloat {
			pinnedBlock?.physicsBody?.applyAngularImpulse(torque)
		}
	}
}
