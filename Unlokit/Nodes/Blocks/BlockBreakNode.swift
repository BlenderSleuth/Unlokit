//
//  BlockBreakNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BlockBreakNode: BlockNode {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.blockBreak
	}
	
	func shatter() {
		// TO DO: add particles and sound
		removeFromParent()
	}
}
