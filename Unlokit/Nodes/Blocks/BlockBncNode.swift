//
//  BlockBncNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BlockBncNode: BlockNode {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		physicsBody?.categoryBitMask = Category.blockBnc
	}
}
