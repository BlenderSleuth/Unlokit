//
//  SecretTeleportNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 28/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class SecretTeleportNode: SKSpriteNode {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		physicsBody = SKPhysicsBody(edgeFrom: CGPoint.zero, to: CGPoint(x: frame.height, y: 0))
		physicsBody?.categoryBitMask = Category.secretTeleport
		physicsBody?.contactTestBitMask = Category.key
		physicsBody?.collisionBitMask = Category.zero
	}
}
