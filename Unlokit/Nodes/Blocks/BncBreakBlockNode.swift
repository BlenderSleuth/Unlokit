//
//  BncBreakBlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 28/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BncBreakBlockNode: BncBlockNode, Breakable {
	var side: Side?
	var glueBlock: GlueBlockNode?
	
	var particleTexture: SKTexture?
	var particleColour: SKColor?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.bncBlock | Category.breakBlock
	}
}
