//
//  LockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class LockNode: SKSpriteNode {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setupPhysics() {
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.isDynamic = false
		physicsBody?.density = 0.01
		physicsBody?.categoryBitMask = Category.lock
		physicsBody?.contactTestBitMask = Category.zero
		physicsBody?.collisionBitMask = Category.blocks | Category.balls | Category.bounds
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
		if let dynamic = data?["dynamic"] as? Bool {
			physicsBody?.isDynamic = dynamic
		}
	}
}
