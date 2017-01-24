//
//  GravityToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 24/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class GravityToolNode: ToolNode {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		type = .spring
	}
	
	override func setupPhysics() {
		super.setupPhysics()
		
		physicsBody?.categoryBitMask = Category.springTool
	}
}
