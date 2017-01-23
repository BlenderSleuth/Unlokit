//
//  ReplayButton.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

protocol Reload {
	func reload()
}

class ReplayButtonNode: SKSpriteNode {
	
	var pressed = false
	
	var reloadable: Reload!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		// Allow touch events
		isUserInteractionEnabled = true
	}
	
	func press() {
		pressed = !pressed
		if pressed {
			removeAllActions()
			let color = SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0.2)
			let wiggle = SKAction(named: "Wiggle")!
			
			let action = SKAction.sequence([color, wiggle])
			run(action)
		} else {
			removeAllActions()
			let action = SKAction.group([SKAction(named: "StopWiggle")!,
			                             SKAction.colorize(with: .red, colorBlendFactor: 0, duration: 0.2)])
			run(action)
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		press()
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			press()
			let location = touch.location(in: parent!)
			if frame.contains(location) {
				if reloadable != nil {
					reloadable.reload()
				}
			}
		}
	}
}
