//
//  BlockMtlNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BlockMtlNode: SKSpriteNode {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		physicsBody?.categoryBitMask = Category.blockMtl
	}
	
	// Create version of self that has kind of bncNode
	func bncVersion() -> BlockBncNode {
		let blockBnc = SKNode(fileNamed: "BlockBnc")?.children.first as! BlockBncNode
		blockBnc.removeFromParent()
		blockBnc.position = position
		blockBnc.zPosition = zPosition
		return blockBnc
	}
	func glueVersion() -> BlockGlueNode {
		let blockGlue = SKNode(fileNamed: "BlockGlue")?.children.first as! BlockGlueNode
		blockGlue.removeFromParent()
		blockGlue.position = position
		blockGlue.zPosition = zPosition
		return blockGlue
	}
}


