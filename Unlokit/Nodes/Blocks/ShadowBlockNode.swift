//
//  ShadowBlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 12/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class ShadowBlockNode: MtlBlockNode {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func setup(scene: GameScene) {
		super.setup(scene: scene)
		physicsBody?.categoryBitMask = Category.shadowBlock
		physicsBody?.contactTestBitMask = Category.zero
		physicsBody?.collisionBitMask = Category.all
		
		lightingBitMask = Category.controllerLight | Category.lockLight
		shadowCastBitMask = Category.blockLight
	}
}
