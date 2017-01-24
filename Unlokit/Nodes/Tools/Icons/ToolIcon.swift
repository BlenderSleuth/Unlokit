//
//  ToolIcon.swift
//  Unlokit
//
//  Created by Ben Sutherland on 13/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

// Only use this for subclassing...
class ToolIcon: SKSpriteNode {
    
    var type: ToolType!
	
	private var label: SKLabelNode!
	var number = 0 {
		didSet{
			label?.text = "\(number)"
		}
	}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		
		// Set label, if there is one
		label = childNode(withName: "label") as! SKLabelNode
    }
}
