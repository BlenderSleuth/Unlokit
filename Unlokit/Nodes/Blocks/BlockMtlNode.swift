//
//  BlockMtlNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BlockMtlNode: BlockNode {
	var blockBnc: BlockBncNode!
	var blockGlue: BlockGlueNode!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		physicsBody?.categoryBitMask = Category.blockMtl
		
		blockBnc = SKNode(fileNamed: "BlockBnc")?.children.first as! BlockBncNode
		blockGlue = SKNode(fileNamed: "BlockGlu")?.children.first as! BlockGlueNode
	}
	// Create version of self that has kind of bncNode
	func bncVersion() -> BlockBncNode {
		
		blockBnc.removeFromParent()
		blockBnc.position = position
		blockBnc.zPosition = zPosition
		return blockBnc
	}
	func glueVersion() -> BlockGlueNode {
		
		
		blockGlue.removeFromParent()
		blockGlue.position = position
		blockGlue.zPosition = zPosition
		return blockGlue
	}

}


