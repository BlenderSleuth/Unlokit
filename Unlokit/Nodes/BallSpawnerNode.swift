//
//  BallSpawnerNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 5/3/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit
protocol NodeSetup {
	func setup(scene: GameScene)
}

class BallSpawnerNode: SKSpriteNode, NodeSetup {
	func setup(scene: GameScene) {
		self.color = .orange


		if let parent = self.parent as? SKSpriteNode, let parentPhysicsBody = parent.physicsBody {
			physicsBody = SKPhysicsBody(circleOfRadius: 0.1)
			physicsBody?.categoryBitMask = Category.zero
			physicsBody?.collisionBitMask = Category.zero
			physicsBody?.contactTestBitMask = Category.zero

			let joint = SKPhysicsJointFixed.joint(withBodyA: physicsBody!,
			                                      bodyB: parentPhysicsBody,
			                                      anchor: scene.convert(CGPoint.zero, from: self))

			scene.physicsWorld.add(joint)
		}


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
		if let number = data?["number"] as? Int {
			let increment = 100 / CGFloat(number)
			// Iterate
			for index in 1...number {
				// Create ball
				let ball = SKSpriteNode(imageNamed: "Ball")
				ball.size = CGSize(width: 32, height: 32)
				ball.physicsBody = SKPhysicsBody(circleOfRadius: 16)
				ball.physicsBody?.categoryBitMask = Category.ball
				ball.physicsBody?.collisionBitMask = Category.all
				ball.physicsBody?.mass = 0.3

				ball.position = scene.convert(CGPoint(x: increment * CGFloat(index), y:10), from: self)

				ball.alpha = 0

				let wait = SKAction.wait(forDuration: 0.25 *  TimeInterval(index), withRange: 1)
				let add = SKAction.run { scene.addChild(ball)}
				let fade = SKAction.run { ball.run(SKAction.fadeIn(withDuration: 0.5)) }
				scene.run(SKAction.sequence([wait, add, fade]))
			}
		}
	}
}
