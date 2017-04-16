//
//  BncBlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BncBlockNode: BlockNode {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		physicsBody?.restitution = 0.8

		physicsBody?.categoryBitMask = Category.bncBlock
		physicsBody?.contactTestBitMask = Category.zero
	}
	
	override func bounce(side: Side) {
		super.bounce(side: side)
		// Play random bounce sound effect
		let random = arc4random_uniform(4)+1
		run(SoundFX.sharedInstance["bounce\(random)"]!)
	}
}
