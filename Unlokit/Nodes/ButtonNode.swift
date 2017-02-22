//
//  ButtonNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 22/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class LevelButtonNode: SKSpriteNode {
    var pressedButton: SKTexture!
    var nonPressedButton: SKTexture!
    
    var pressed = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        pressedButton = SKTexture(imageNamed: "LevelButtonPressed")
        nonPressedButton = texture!
        
        self.position = position
        
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
        
    }
    func toNextLevel() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if frame.contains(location) {
                
            }
        }
    }
}

class NextLevelButtonNode: SKSpriteNode {
    var pressedButton: SKTexture!
    var nonPressedButton: SKTexture!
    
    var pressed = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        pressedButton = SKTexture(imageNamed: "LevelButtonPressed")
        nonPressedButton = texture!
        
        self.position = position
        
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
        
    }
    func toNextLevel() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if frame.contains(location) {
                
            }
        }
    }
}
