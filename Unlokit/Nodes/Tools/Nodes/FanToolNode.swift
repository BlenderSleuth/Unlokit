//
//  FanToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 24/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class FanToolNode: ToolNode {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		type = .fan
	}

	override func setupPhysics(shadowed isShadowed: Bool) {
		super.setupPhysics(shadowed: isShadowed)


		physicsBody?.categoryBitMask = Category.fanTool
		physicsBody?.contactTestBitMask = Category.bounds | Category.blockMtl | Category.blockGlue
		physicsBody?.collisionBitMask = Category.all ^ Category.speed // All except speed
	}
}
