//
//  BombToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 13/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BombToolNode: ToolNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        type = .bomb
    }
	override func setupPhysics() {
		super.setupPhysics()
		
		physicsBody?.categoryBitMask = Category.bombTool
		physicsBody?.contactTestBitMask = Category.bounds | Category.blockMtl | Category.blockGlue
	}
}
