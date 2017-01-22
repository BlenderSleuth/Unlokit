//
//  FireButtonNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 11/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

protocol ButtonDelegate {
    func pressed()
}

class FireButtonNode: SKSpriteNode {
	
	//MARK: Variable
	// Initialised as implicitly-unwrapped optionals for file compatability
    var label: SKLabelNode!
    var redCircle: SKShapeNode!
    var blueCircle: SKShapeNode!
    
    var pressed = false
	
    var angle: Float = Float(π/2)
    
    //used for initialising from file
    required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		//
		redCircle = SKShapeNode(circleOfRadius: size.width / 2)
		redCircle.fillColor = .red
		redCircle.strokeColor = .red
		
		blueCircle = SKShapeNode(circleOfRadius: size.width / 2)
		blueCircle.fillColor = .blue
		blueCircle.strokeColor = .blue
		blueCircle.isHidden = true
		
		label = SKLabelNode(text: "Fire!")
		label.position = CGPoint(x: 0, y: -30)
		label.fontName = "Helvetica Neue Thin"
		label.fontSize = 100
		label.zPosition = 10
		
		self.position = position
		
		addChild(redCircle)
		addChild(blueCircle)
		addChild(label)
		
		isUserInteractionEnabled = true
    }
	
    private func press() {
        pressed = !pressed
        redCircle.isHidden = pressed
        blueCircle.isHidden = !pressed
    }
    
	private func fire(radians angle: Float, object: SKSpriteNode) {
        // Speed of firing
        let speed: CGFloat = 750
		
        object.zRotation = CGFloat(angle)
		
		// Get vector to fire to
        let dx = CGFloat(cosf(angle)) * speed
        let dy = CGFloat(sinf(angle)) * speed
        
        scene?.addChild(object)
		
		// Apply impulse based on angle
        object.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
        //fire(radians: angle)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
}
