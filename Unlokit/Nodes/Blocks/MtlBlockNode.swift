//
//  MtlBlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class MtlBlockNode: BlockNode {

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.mtlBlock
	}
	
	// Create version of self that has kind of bncNode
	func bncVersion(scene: GameScene) -> BncBlockNode {
		// Check if self is breakable
		let bncBlock: BncBlockNode
		if self is Breakable {
			bncBlock = SKNode(fileNamed: "BlockBrkBnc")?.children.first as! BncBlockNode
		} else {
			bncBlock = SKNode(fileNamed: "BncBlock")?.children.first as! BncBlockNode
		}

		bncBlock.removeFromParent()
		bncBlock.position = position
		bncBlock.zPosition = zPosition

		if let beam = beamNode {
			bncBlock.position = beam.convert(position, from: self.parent!)
			self.removeFromParent()
			beam.addChild(bncBlock)
			beam.setup(scene: scene)

			bncBlock.physicsBody?.isDynamic = true
		} else {
			self.parent?.addChild(bncBlock)
			self.removeFromParent()
		}

		return bncBlock
	}
	// Create version of self that has kind of glueNode
	func glueVersion(scene: GameScene) -> GlueBlockNode {
		// Check if self is breakable
		let gluBlock: GlueBlockNode
		if self is Breakable {
			gluBlock = SKNode(fileNamed: "BlockBrkGlu")?.children.first as! GlueBlockNode
		} else {
			gluBlock = SKNode(fileNamed: "BlockGlu")?.children.first as! GlueBlockNode
		}
		
		gluBlock.removeFromParent()
		gluBlock.position = position
		gluBlock.zPosition = zPosition

		if let beam = beamNode {
			gluBlock.position = beam.convert(position, from: self.parent!)
			self.removeFromParent()
			beam.addChild(gluBlock)
			beam.setup(scene: scene)

			gluBlock.physicsBody?.isDynamic = true
		} else {
			self.parent?.addChild(gluBlock)
			self.removeFromParent()
		}

		return gluBlock
	}
}
