//
//  BlockBreakBncNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 28/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BlockBreakBncNode: BlockBncNode, Breakable {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.blockBreak | Category.blockBnc
	}
	
	func shatter() {
		// TO DO: add particles and sound
		removeFromParent()
	}
}
