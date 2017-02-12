//
//  GlueToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 13/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class GlueToolNode: ToolNode {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        type = .glue
    }
	
	override func setupPhysics(shadowed isShadowed: Bool) {
		super.setupPhysics(shadowed: isShadowed)

		physicsBody?.categoryBitMask = Category.glueTool
		physicsBody?.contactTestBitMask = Category.bounds | Category.blockMtl | Category.blockBreak
		physicsBody?.collisionBitMask = Category.all ^ Category.speed // All except speed
	}
}
