//
//  SpringToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 24/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class SpringToolNode: ToolNode {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		type = .spring
	}
	
	override func setupPhysics() {
		super.setupPhysics()
		
		physicsBody?.categoryBitMask = Category.springTool
		physicsBody?.contactTestBitMask = Category.bounds | Category.blockMtl
		physicsBody?.collisionBitMask = Category.all
	}
}
