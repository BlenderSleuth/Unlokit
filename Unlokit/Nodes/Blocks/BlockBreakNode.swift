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
	var glueBlock: BlockGlueNode? { get set }
	var side: Side? { get set }

	func removeFromParent()
}
extension Breakable {
	func shatter() {
		// Remove from blocks 'connected' array
		if let side = side, let block = glueBlock {
			block.remove(for: side)
		}

		removeFromParent()
	}
}

class BlockBreakNode: BlockMtlNode, Breakable {

	var side: Side?
	var glueBlock: BlockGlueNode?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.blockBreak
	}
}
