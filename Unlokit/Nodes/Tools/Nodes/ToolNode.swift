//
//  ToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 13/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

enum ToolType: String {
	case spring		= "SpringTool"
	case bomb		= "BombTool"
	case glue		= "GlueTool"
	case fan		= "FanTool"
	case gravity	= "GravityTool"
	
	static let all: [ToolType] = [.spring, .bomb, .glue, .fan, .gravity]
}

// Only use this for subclassing...
class ToolNode: SKSpriteNode, CanBeFired {
    
    var type: ToolType!
	
	var isEngaged = false
	var animating = false
	var used = false

	private var timerStarted = false
	
	var icon: ToolIcon!
	
	var emitter: SKEmitterNode!
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		emitter = SKEmitterNode(fileNamed: "Smash")!
		emitter.particleTexture = texture
    }
	func remove() {
		// For overriding to clean up
		removeFromParent()
	}
	
	func engage(_ controller: ControllerNode) {
		isEngaged = true
		animating = true
		controller.isOccupied = true
		run(SKAction.move(to: controller.scenePosition, duration: 0.2)) {
			self.animating = false
		}
		icon.number -= 1
		
		run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(360).degreesToRadians(), duration: 3)), withKey: "rotate")
	}
	func disengage(_ controller: ControllerNode) {
		animating = true
		// Convert icon position to scene coordinates
		let position = scene!.convert(icon.position, from: icon.parent!)
		run(SKAction.move(to: position, duration: 0.2)) {
			self.animating = false
			self.icon.number += 1
			self.remove()
		}
		isEngaged = false
		controller.isOccupied = false
	}
	
	func prepareForFiring(_ scene: GameScene, controller: ControllerNode) {
		setupPhysics(shadowed: controller.isShadowed)
		isEngaged = false
		controller.isOccupied = false
		removeAction(forKey: "rotate")

		run(SKAction.wait(forDuration: 5)) {
			self.smash(scene: scene)
		}
	}
	func setupPhysics(shadowed isShadowed: Bool) {
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.isDynamic = true
		physicsBody?.mass = 0.01
		//physicsBody?.usesPreciseCollisionDetection = true
		// Override in subclasses
		physicsBody?.categoryBitMask = Category.zero
		physicsBody?.contactTestBitMask = Category.bounds
		physicsBody?.collisionBitMask = Category.all
		physicsBody?.fieldBitMask = Category.fields

		if isShadowed {
			let light = SKLightNode()
			light.categoryBitMask = Category.toolLight
			light.falloff = 0.6
			addChild(light)
		}
	}

	func smash(scene: GameScene) {
		guard parent != nil else {
			print("No parent")
			return
		}
		
		emitter.position = self.scene!.convert(position, from: parent!)
		self.scene?.addChild(emitter)
		self.scene?.run(SoundFX.sharedInstance["smash"]!)
		
		removeFromParent()
	}
	
	func startTimer() {
		// If the timer has already started, don't start again
		guard !timerStarted else {
			return
		}
		timerStarted = true

		let wait = SKAction.wait(forDuration: RCValues.sharedInstance.toolTime)
		run(wait, withKey: "timer") {
			weak var `self` =  self
			
			if let scene = self?.scene as? GameScene {
				self?.smash(scene: scene)
			}
		}
	}
}
