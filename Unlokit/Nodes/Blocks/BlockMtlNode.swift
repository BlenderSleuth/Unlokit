//
//  BlockMtlNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BlockMtlNode: BlockNode {

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		physicsBody?.categoryBitMask = Category.blockMtl
	}
	// Create version of self that has kind of bncNode
	func bncVersion(scene: SKScene) -> BlockBncNode {
		// Check if self is breakable
		let blockBnc: BlockBncNode
		if self is Breakable {
			blockBnc = SKNode(fileNamed: "BlockBrkBnc")?.children.first as! BlockBncNode
		} else {
			blockBnc = SKNode(fileNamed: "BlockBnc")?.children.first as! BlockBncNode
		}

		blockBnc.removeFromParent()
		blockBnc.position = position
		blockBnc.zPosition = zPosition

		if let beam = beamNode {
			blockBnc.position = beam.convert(position, from: self.parent!)
			self.removeFromParent()
			beam.addChild(blockBnc)
			beam.setup(physicsWorld: scene.physicsWorld)

			blockBnc.physicsBody?.isDynamic = true
		} else {
			self.parent?.addChild(blockBnc)
			self.removeFromParent()
		}

		return blockBnc
	}
	// Create version of self that has kind of glueNode
	func glueVersion(scene: SKScene) -> BlockGlueNode {
		// Check if self is breakable
		let blockGlue: BlockGlueNode
		if self is Breakable {
			blockGlue = SKNode(fileNamed: "BlockBrkGlu")?.children.first as! BlockGlueNode
		} else {
			blockGlue = SKNode(fileNamed: "BlockGlu")?.children.first as! BlockGlueNode
		}
		
		blockGlue.removeFromParent()
		blockGlue.position = position
		blockGlue.zPosition = zPosition

		if let beam = beamNode {
			blockGlue.position = beam.convert(position, from: self.parent!)
			self.removeFromParent()
			beam.addChild(blockGlue)
			beam.setup(physicsWorld: scene.physicsWorld)

			blockGlue.physicsBody?.isDynamic = true
		} else {
			self.parent?.addChild(blockGlue)
			self.removeFromParent()
		}

		return blockGlue
	}
}


