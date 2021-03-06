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
class ToolNode: SKSpriteNode, CanBeFired, Breakable {
    var type: ToolType!
	
	var isEngaged = false
	var animating = false
	var used = false

	var glueBlock: GlueBlockNode?
	var side: Side?
	
	var particleTexture: SKTexture?
	var particleColour: SKColor?

	private var timerStarted = false
	
	var icon: ToolIcon!
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		
		setScale(RCValues.sharedInstance.initialToolScale)
    }
	func shatter(scene: GameScene) {
		smash(scene: scene)
	}
	func remove() {
		// For overriding to clean up
		removeFromParent()
	}
	func removeFromBlock(scene: GameScene, glueBlock: GlueBlockNode, side: Side) {
		glueBlock.remove(for: side)
		smash(scene: scene)
	}
	
	func engage(_ controller: ControllerNode, completion: @escaping () -> ()) {
		isEngaged = true
		animating = true
		controller.isOccupied = true
		run(SKAction.group([SKAction.move(to: controller.scenePosition, duration: 0.2),
		                    SKAction.scale(to: 1, duration: 0.2)])) {
			self.animating = false
			completion()
		}
		icon.number -= 1
		
		run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(360).degreesToRadians(), duration: 3)), withKey: "rotate")
	}
	func disengage(_ controller: ControllerNode) {
		animating = true
		// Convert icon position to scene coordinates
		let position = scene!.convert(icon.position, from: icon.parent!)
		run(SKAction.group([SKAction.move(to: position, duration: 0.2),
		                    SKAction.scale(to: RCValues.sharedInstance.initialToolScale, duration: 0.2)])) {
			self.animating = false
			self.icon.number += 1
			self.remove()
		}
		isEngaged = false
		controller.isOccupied = false
	}
	
	func prepareForFiring(controller: ControllerNode) {
		setupPhysics(shadowed: controller.isShadowed)
		isEngaged = false
		controller.isOccupied = false
		removeAction(forKey: "rotate")
	}
	func setupPhysics(shadowed isShadowed: Bool) {
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.isDynamic = true
		physicsBody?.mass = 0.01
		
		// Override in subclasses
		physicsBody?.categoryBitMask = Category.zero
		physicsBody?.contactTestBitMask = Category.bounds
		physicsBody?.collisionBitMask = Category.all ^ Category.speed // All except speed
		physicsBody?.fieldBitMask = Category.fields

		if isShadowed {
			lightingBitMask = Category.toolLight | Category.controllerLight
			let light = SKLightNode()
			light.categoryBitMask = Category.toolLight
			light.falloff = 2
			addChild(light)
		}
	}

	func smash(scene: GameScene) {
		guard parent != nil else {
			return
		}

		let emitter = SKEmitterNode(fileNamed: "Smash")!
		emitter.particleTexture = texture
		emitter.position = scene.convert(position, from: parent!)
		scene.addChild(emitter)
		scene.run(SoundFX.sharedInstance["smash"]!)
		
		removeFromParent()
	}
	func startTimer() {
		// If the timer has already started, dont start a new one
		if timerStarted {
			return
		}
		
		timerStarted = true

		let wait = SKAction.wait(forDuration: RCValues.sharedInstance.toolTime)
		run(wait, withKey: "timer") {
			weak var `self` = self

			if let scene = self?.scene as? GameScene {
				self?.smash(scene: scene)
			}
		}
	}
	func startTimer(glueBlock: GlueBlockNode, side: Side) {
		// If the timer has already started, remove it
		if timerStarted {
			removeAction(forKey: "timer")
		} else {
			timerStarted = true
		}

		let wait = SKAction.wait(forDuration: RCValues.sharedInstance.toolTime)
		run(wait, withKey: "timer") {
			weak var `self` = self
			
			if let scene = self?.scene as? GameScene {
				self?.removeFromBlock(scene: scene, glueBlock: glueBlock, side: side)
			}
		}
	}
}
