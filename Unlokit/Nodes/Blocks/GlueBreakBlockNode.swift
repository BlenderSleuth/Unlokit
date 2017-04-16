//
//  GlueBreakBlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 28/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class GlueBreakBlockNode: GlueBlockNode, Breakable {
	var glueBlock: GlueBlockNode?
	var side: Side?
	
	var particleTexture: SKTexture?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.gluBlock
	}
}
