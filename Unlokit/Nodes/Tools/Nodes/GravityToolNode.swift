//
//  GravityToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 24/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class GravityToolNode: ToolNode {
	required init(texture: SKTexture?, color: UIColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		type = .gravity
	}
	
	override func setupPhysics() {
		super.setupPhysics()
		
		physicsBody?.categoryBitMask = Category.gravityTool
		physicsBody?.contactTestBitMask = Category.bounds | Category.blockMtl | Category.blockGlue
		physicsBody?.collisionBitMask = Category.all ^ Category.speed // All except speed
	}
}
