//
//  KeyNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 22/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class KeyNode: SKSpriteNode, CanBeFired {
	
	// Status flags
	var isEngaged = false
	var animating = false
	private var isGreyed = false
	
	weak var levelController: LevelController!
	
	let emitter = SKEmitterNode(fileNamed: "Smash")!
	
	// Initial key position, to return to
	var startPosition: CGPoint!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		// Set position to start
		startPosition = position
		
		emitter.isPaused = true
	}
	
	func engage(_ controller: ControllerNode) {
		guard let position = getPosition(from: controller) else {
			return
		}
		
		controller.isOccupied = true
		isEngaged = true
		animating = true
		run(SKAction.move(to: position, duration: 0.2)) {
			self.animating = false
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

	func prepareForFiring(_ controller: ControllerNode) {
		// Sets up before firing
		setupPhysics()
		isEngaged = false
		controller.isOccupied = false
		removeAction(forKey: "rotate")
	}
	private func setupPhysics() {
		// Physicsbody
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		physicsBody?.isDynamic = true
		physicsBody?.usesPreciseCollisionDetection = true
		physicsBody?.mass = 0.01
		physicsBody?.categoryBitMask = Category.key
		physicsBody?.contactTestBitMask = Category.lock | Category.blocks | Category.bounds
		physicsBody?.collisionBitMask = Category.all ^ (Category.lock | Category.speed) // All except lock
	}
	
	func getPosition(from node: SKNode) -> CGPoint? {
		// Make sure keynode had a scene and a parent
		guard let prnt = node.parent, let selprnt = self.parent else {
			return nil
		}
		
		return prnt.convert(node.position, to: selprnt)
	}
	
	func smash() {
		// Check if key has already been smashed
		guard parent != nil else {
			return
		}
		
		let wait = SKAction.wait(forDuration: 1)
		let sound = SoundFX.sharedInstance["smash"]!
		let group = SKAction.group([wait, sound])
		
		scene?.run(group) {
			// Reload scene
			self.levelController.startNewGame()
		}
		
		emitter.isPaused = false
		emitter.position = scene!.convert(position, from: parent!)
		scene?.addChild(emitter)
		
		removeFromParent()
	}
	
	func lock(_ lock: LockNode) {
		guard let position = getPosition(from: lock) else {
			return
		}
		
		physicsBody = nil
		
		// Move and rotate to lock position
		let move = SKAction.move(to: position, duration: 0.2)
		let rotate = SKAction.rotate(toAngle: lock.zRotation, duration: 0.2)
		let group = SKAction.group([move, rotate])
		
		run(group) {
			self.removeAllActions()
			self.run(SoundFX.sharedInstance["lock"]!)
			
			self.run(SKAction.wait(forDuration: 1)) {
				if let stage1 = self.scene as? Stage1 {
					stage1.endGame()
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
