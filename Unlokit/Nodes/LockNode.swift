//
//  LockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class LockNode: SKSpriteNode, NodeSetup {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setup(scene: GameScene) {
		lightingBitMask = Category.controllerLight | Category.toolLight | Category.lockLight
		
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.isDynamic = false
		physicsBody?.density = 0.01
		physicsBody?.categoryBitMask = Category.lock
		physicsBody?.contactTestBitMask = Category.zero
		physicsBody?.collisionBitMask = Category.blocks | Category.ball | Category.bounds
		getDataFromParent()
	}
	func addLight() {
		let light = SKLightNode()
		light.falloff = 4
		light.categoryBitMask = Category.lockLight
		addChild(light)
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
		if let dynamic = data?["dynamic"] as? Bool {
			physicsBody?.isDynamic = dynamic
			if dynamic, let gravity = data?["gravity"] as? Bool {
				physicsBody?.affectedByGravity = gravity
				if !gravity {
					// To set gravity later
					physicsBody?.contactTestBitMask = Category.tools | Category.ball
				}
			}
		}
		if let attached = data?["attached"] as? Bool, attached {
			physicsBody?.collisionBitMask = Category.ball | Category.bounds
			
			var block: BlockNode?
			
			// Find block
			var tempNode: SKNode = self
			while !(tempNode is SKScene) {
				if let blockNode = tempNode as? BlockNode {
					block = blockNode
					break
				}
				tempNode = tempNode.parent!
			}
			if let blockPhysicsBody = block?.physicsBody, let scene = scene {
				let pin = SKPhysicsJointFixed.joint(withBodyA: blockPhysicsBody, bodyB: self.physicsBody!, anchor: scene.convert(CGPoint.zero, from: self))
				scene.physicsWorld.add(pin)
			}
		}
	}
}
