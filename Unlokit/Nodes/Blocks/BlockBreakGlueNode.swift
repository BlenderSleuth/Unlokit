//
//  BlockBreakGlueNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 28/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BlockBreakGlueNode: BlockGlueNode, Breakable {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.blockGlue
	}
	
	func shatter() {
		// TODO: add particles and sound
		removeFromParent()
	}
}
