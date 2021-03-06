//
//  SpeedNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 27/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class SpeedNode: SKSpriteNode {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		physicsBody?.categoryBitMask = Category.speed
		physicsBody?.contactTestBitMask = Category.tools | Category.key
		physicsBody?.collisionBitMask = Category.zero
	}
}
