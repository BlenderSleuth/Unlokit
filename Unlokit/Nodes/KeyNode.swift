//
//  KeyNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 22/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class KeyNode: SKSpriteNode, CanBeFired, Breakable {
	var glueBlock: GlueBlockNode?
	var side: Side?
	
	var particleTexture: SKTexture?
	var particleColour: SKColor?
	
	// Status flags
	var isEngaged = false
	var animating = false
	private var isGreyed = false

	private var timerStarted = false
	
	weak var levelController: LevelController!
	
	// Initial key position, to return to
	var startPosition: CGPoint!

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		// Set position to start
		startPosition = position
	}
	
	func engage(_ controller: ControllerNode, completion: @escaping () -> ()) {
		guard let position = getPosition(from: controller) else {
			return
		}
		
		controller.isOccupied = true
		isEngaged = true
		animating = true
		run(SKAction.move(to: position, duration: 0.2)) {
			self.animating = false
			completion()
		}
		run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(360).degreesToRadians(), duration: 3)), withKey: "rotate")
	}
	func disengage(_ controller: ControllerNode) {
		animating = true
		run(SKAction.move(to: startPosition, duration: 0.2)) {
			self.animating = false
			self.removeAllActions()
			
		}
		isEngaged = false
		controller.isOccupied = false
	}

	func prepareForFiring(controller: ControllerNode) {
		// Sets up before firing
		setupPhysics(shadowed: controller.isShadowed)
		isEngaged = false
		controller.isOccupied = false
		removeAction(forKey: "rotate")
	}
	private func setupPhysics(shadowed isShadowed: Bool) {
		// Physicsbody
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.isDynamic = true
		physicsBody?.usesPreciseCollisionDetection = true
		physicsBody?.mass = 0.01
		physicsBody?.categoryBitMask = Category.key
		physicsBody?.contactTestBitMask = Category.lock | Category.blocks | Category.bounds
		physicsBody?.collisionBitMask = Category.all ^ (Category.lock | Category.speed) // All except lock

		if isShadowed {
			let light = SKLightNode()
			light.categoryBitMask = Category.toolLight
			light.falloff = 0.6
			addChild(light)
		}
	}
	
	func getPosition(from node: SKNode) -> CGPoint? {
		// Make sure keynode had a scene and a parent
		guard let prnt = node.parent, let selprnt = self.parent else {
			return nil
		}
		
		return prnt.convert(node.position, to: selprnt)
	}
	
	func shatter(scene: GameScene) {
		smash(scene: scene)
	}
	func smash(scene: GameScene) {
		// Check if key has already been smashed
		guard parent != nil else {
			return
		}
		
		let wait = SKAction.wait(forDuration: 1)
		let sound = SoundFX.sharedInstance["smash"]!
		let group = SKAction.group([wait, sound])
		
		let emitter = SKEmitterNode(fileNamed: "Smash")!
		emitter.isPaused = false
		emitter.position = scene.convert(position, from: parent!)
		scene.addChild(emitter)
		
		removeFromParent()
        
        // Shake and colorise scene
        scene.die()

		scene.run(group) {
			// Reload scene
			self.levelController.startNewGame()
		}
	}
	
	// Key doesn't have a timer, so these functions are stubs
	func startTimer(glueBlock: GlueBlockNode, side: Side) {
		//Stub
	}
	func startTimer() {
		//Stub
	}
	
	func lock(_ lock: LockNode) {
		if let scene = scene{
			self.move(toParent: scene)
		} else {
			return
		}
		
		guard let position = getPosition(from: lock) else {
			return
		}
		
		physicsBody?.isDynamic = false
		lock.physicsBody?.isDynamic = false
		
		// Move and rotate to lock position
		let move = SKAction.move(to: position, duration: 0.2)
		let rotate = SKAction.rotate(toAngle: lock.zRotation, duration: 0.2)
		let group = SKAction.group([move, rotate])
		
		run(group) {
			self.removeAllActions()
			
			self.run(SoundFX.sharedInstance["lock"]!)
			
			self.run(SKAction.wait(forDuration: 1)) {
				if let stage1 = self.scene as? GameScene {
					stage1.finishedLevel()
				}
			}
		}
	}
	
	func greyOut() {
		if isGreyed {														// Same value
			run(SKAction.colorize(withColorBlendFactor: 0, duration: 0.2), withKey: "colorise")
		} else {
			run(SKAction.colorize(withColorBlendFactor: 0.6, duration: 0.2), withKey: "colorise")
		}
		isGreyed = !isGreyed
	}
}

class KeyTutorialNode: KeyNode {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func engage(_ controller: ControllerNode, completion: @escaping () -> ()) {
		super.engage(controller, completion: completion)
		
		if let scene = scene as? TutorialScene {
			scene.goNext(to: controller, text: "")
		} else {
			fatalError("Tutorial not initiated")
		}
	}
}
