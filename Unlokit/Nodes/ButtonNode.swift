//
//  ButtonNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 22/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class LevelSelectButtonNode: SKSpriteNode {
	let nonPressedButton = SKTexture(image: #imageLiteral(resourceName: "LevelButton"))
	let pressedButton = SKTexture(image: #imageLiteral(resourceName: "LevelButtonPressed"))

    var pressed = false

	var delegate: LevelController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
    }
    
    func press() {
        pressed = !pressed
        if pressed {
            self.texture = pressedButton
        } else {
            self.texture = nonPressedButton
        }
        
    }
    func toLevelSelect() {
        delegate?.endGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		press()
		let location = touches.first!.location(in: parent!)
		if frame.contains(location) {
			toLevelSelect()
		}
	}
}

class NextLevelButtonNode: SKSpriteNode {
	let nonPressedButton = SKTexture(image: #imageLiteral(resourceName: "NextButton"))
    let pressedButton = SKTexture(image: #imageLiteral(resourceName: "NextButtonPressed"))
    
    var pressed = false

	var delegate: LevelController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
    }
    
    func press() {
        pressed = !pressed
        if pressed {
            self.texture = pressedButton
        } else {
            self.texture = nonPressedButton
        }
        
    }
    func toNextLevel() {
        delegate?.toNextLevel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		press()
		let location = touches.first!.location(in: parent!)
		if frame.contains(location) {
			toNextLevel()
		}
	}
}
