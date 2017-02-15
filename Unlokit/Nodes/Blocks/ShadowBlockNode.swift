//
//  ShadowBlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 12/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class ShadowBlockNode: BlockMtlNode {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		physicsBody?.categoryBitMask = Category.blockShadow
		physicsBody?.contactTestBitMask = Category.zero
		physicsBody?.collisionBitMask = Category.all

		lightingBitMask = Category.controllerLight
		shadowCastBitMask = Category.controllerLight

	}
}
