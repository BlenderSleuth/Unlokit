//
//  BlockBreakNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

protocol Breakable {
	func shatter()
}

class BlockBreakNode: BlockMtlNode, Breakable {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.blockBreak
	}
	
	func shatter() {
		// TODO: add particles and sound
		removeFromParent()
	}
}
