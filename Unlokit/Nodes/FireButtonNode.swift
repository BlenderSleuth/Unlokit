//
//  FireButtonNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 11/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

protocol CanBeFired {
	func engage(_ controller: ControllerNode, completion: @escaping () -> ())
	func disengage(_ controller: ControllerNode)
	func prepareForFiring(controller: ControllerNode)

	// To stop tools being stuck
	func startTimer(glueBlock: BlockGlueNode, side: Side)
	func startTimer()
}

class FireButtonNode: SKSpriteNode {
	
	//MARK: Variables
	let nonPressedtexture = SKTexture(image: #imageLiteral(resourceName: "FireButton"))
	let pressedTexture = SKTexture(image: #imageLiteral(resourceName: "FireButtonPressed"))
    
    var pressed = false
	var objectToFire: CanBeFired?
	
	// Must be initalised from scene
	var controller: ControllerNode!
	var canon: SKSpriteNode!
	
    // Used for initialising from file
    required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.position = position
		
		isUserInteractionEnabled = true
    }
	
    private func press() {
        pressed = !pressed
		if pressed {
			texture = pressedTexture
		} else {
			texture = nonPressedtexture
		}
    }
    
	private func fire(scene: GameScene) {
		// Make sure object is not nil and is a SKSpriteNode
		guard let sprite = objectToFire as? SKSpriteNode else {
			return
		}
		
		// Shenanigans for using both protocol and type properties
		// Prepare for firing
		objectToFire?.prepareForFiring(controller: controller)
		//objectToFire is of type 'CanBeFired', object is SKSpriteNode, both reference same object
		
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
		canon.run(recoilAction) // Make canon recoil
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
		// Check if touch is in button
		let location = touches.first!.location(in: parent!)
		if frame.contains(location), let scene = scene as? GameScene {
			fire(scene: scene)
		}
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
}
