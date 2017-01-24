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
	
	private var isGreyed = false
	
	// Grey out icon if number is 0
	var enabled: Bool = false {
		didSet {
			if enabled {
				colorBlendFactor = 0.0
			} else {
				
				color = .darkGray
				run(SKAction.colorize(with: .darkGray, colorBlendFactor: 0.9, duration: 0.5))
			}
		}
	}
	
	private var label: SKLabelNode!
	var number = 0 {
		didSet{
			label?.text = "\(number)"
			if number > 0 {
				enabled = true
			} else {
				enabled = false
			}
		}
	}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		
		// Set label, if there is one
		label = childNode(withName: "label") as! SKLabelNode
    }
	
	func greyOut() {
		guard enabled == true else {
			return
		}
		if isGreyed {
			run(SKAction.colorize(with: .red, colorBlendFactor: 0, duration: 0.2), withKey: "colorise")
		} else {
			run(SKAction.colorize(with: .red, colorBlendFactor: 0.6, duration: 0.2), withKey: "colorise")
		}
		isGreyed = !isGreyed
	}
}
