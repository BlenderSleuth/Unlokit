//
//  FireButtonNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 11/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

protocol CanBeFired {
	func engage(_ controller: ControllerNode)
	func disengage(_ controller: ControllerNode)
	func prepareForFiring(_ controller: ControllerNode)
}

class FireButtonNode: SKSpriteNode {
	
	//MARK: Variable
	// Initialised as implicitly-unwrapped optionals for file archive compatability
    var label: SKLabelNode!
    var redCircle: SKShapeNode!
    var blueCircle: SKShapeNode!
    
    var pressed = false
	var objectToFire: CanBeFired?
	
	// Must be initalised from scene
	var controller: ControllerNode!
	var canon: SKSpriteNode!
	
    // Used for initialising from file
    required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		redCircle = SKShapeNode(circleOfRadius: size.width / 2)
		redCircle.fillColor = .red
		redCircle.strokeColor = .red
		redCircle.alpha = 0.8
		
		blueCircle = SKShapeNode(circleOfRadius: size.width / 2)
		blueCircle.fillColor = .blue
		blueCircle.strokeColor = .blue
		blueCircle.isHidden = true
		
		label = SKLabelNode(text: "Fire")
		label.position = CGPoint(x: 0, y: -30)
		label.fontName = "NeuropolXRg-Regular"
		label.fontSize = 84
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
    
	private func fire(scene: Stage1) {
		// Make sure object is not nil and is SKSpriteNode
		guard let sprite = objectToFire as? SKSpriteNode else {
			return
		}
		
		// Shenanigans for using both protocol and type properties
		// Prepare for firing
		objectToFire?.prepareForFiring(controller) //objectToFire is of type 'CanBeFired', object is SKSpriteNode, both reference same object
		
        // Speed of firing
        let speed: CGFloat = 50
		
		// Compensation
		let angle = Float(controller.zRotation + CGFloat(90).degreesToRadians())
		
        sprite.zRotation = CGFloat(angle)
		
		// Get vector to fire to
        let dx = CGFloat(cosf(angle)) * speed
        let dy = CGFloat(sinf(angle)) * speed
		
		// Apply impulse based on angle
        sprite.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
		//sprite.physicsBody?.applyAngularImpulse(0.5) // Spin sprite as it fires
		
		//SKTAudio.sharedInstance().playSoundEffect(filename: "Explosion.caf")
		
		let recoilAction = SKAction.sequence([SKAction.moveBy(x: 0, y: -70, duration: 0.03), SKAction.moveBy(x: 0, y: 70, duration: 0.2)])
		canon.run(recoilAction)// Make canon recoil
		objectToFire = nil
		
		// So camera can follow the sprite
		scene.nodeToFollow = sprite
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
		if let scn = scene as? Stage1 {
			fire(scene: scn)
		}
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
}
