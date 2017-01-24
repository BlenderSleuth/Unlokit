//
//  TimeToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 13/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class TimeToolNode: ToolNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        type = .time
    }
	override func setupPhysics() {
		super.setupPhysics()
		
		physicsBody?.categoryBitMask = Category.springTool
	}
}
