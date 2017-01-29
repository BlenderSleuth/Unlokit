//
//  FanNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class FanNode: SKSpriteNode {
	
	// Children
	var gravityField: SKFieldNode!
	var dragField: SKFieldNode!
	private var emitter: SKEmitterNode!
	
	var glueBlock: BlockGlueNode!
	var side: Side!
	
	var fieldRect: CGRect!
	var fieldRegion: SKRegion!
	
	var strength: CGFloat = 0 {
		didSet {
			gravityField.strength = Float(strength)
			setParticleVelocity(strength: strength)
		}
	}
	
	var isMoving = false
	
	required override init(texture: SKTexture?, color: UIColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	// Copy all instance variables
	override func copy() -> Any {
		let node = super.copy() as! FanNode
		node.gravityField = node.childNode(withName: "gravityField") as! SKFieldNode
		node.dragField = node.childNode(withName: "dragField") as! SKFieldNode
		node.emitter = node.childNode(withName: "emitter")!.children.first as! SKEmitterNode
		return node
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		// Get field references
		gravityField = childNode(withName: "gravityField") as! SKFieldNode
		gravityField.falloff = 0.1

		gravityField.categoryBitMask = Category.fanGravityField
		
		dragField = childNode(withName: "dragField") as! SKFieldNode
		dragField.strength = 0.01
		dragField.categoryBitMask = Category.fanDragField
		
		emitter = self.childNode(withName: "emitter")?.children.first as! SKEmitterNode
		
		physicsBody? = SKPhysicsBody(edgeLoopFrom: frame)
		physicsBody?.categoryBitMask = Category.fan
		physicsBody?.contactTestBitMask = Category.bombTool
		physicsBody?.collisionBitMask = Category.all
	}
	
	func setup(level: Level, block: BlockGlueNode, side: Side) {
		animate(framesAtlas: level.fanFrames)
		setupParticles(scene: level)
		setupFields(scene: level)
		self.glueBlock = block
		self.side = side
		
		isMoving = checkHasActions(node: self)
		
		level.fans.append(self)
		
		// Set strength to default value
		strength = 60
	}
	
	private func animate(framesAtlas: SKTextureAtlas) {
		var frames = [SKTexture]()
		
		let numOfFrame = framesAtlas.textureNames.count - 1
		
		for i in 0...numOfFrame {
			let textureName = framesAtlas.textureNames[i]
			let texture = framesAtlas.textureNamed(textureName)
			frames.append(texture)
		}
		
		
		run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 1/25)), withKey: "animate")
	}
	private func setupParticles(scene: SKScene) {
		// Set emitter target
		emitter.targetNode = scene
		// Make particles go in the right direction
		let rotation = rotationRelativeToSceneFor(node: self)
		emitter.emissionAngle += rotation
	}
	// Set emitter velocity based on strength of fan
	private func setParticleVelocity(strength: CGFloat) {
		let rotation = rotationRelativeToSceneFor(node: self)  + CGFloat(-90).degreesToRadians()
		
		// Find vector for angle
		let dx = cos(rotation) * strength
		let dy = sin(rotation) * strength
		
		emitter.xAcceleration = -dx
		emitter.yAcceleration = -dy
	}
	private func setupFields(scene: SKScene) {
		let rotation = rotationRelativeToSceneFor(node: self)
		
		let fieldSize = CGSize(width: frame.width, height: frame.height * 40)
		let fieldOrigin = CGPoint(x: -frame.width/2, y: 0)
		fieldRect = CGRect(origin: fieldOrigin, size: fieldSize)
		
		// Calculate region rotation transform
		let rot = rotation - (CGFloat(360).degreesToRadians() - rotation)
		
		var transform = CGAffineTransform(rotationAngle: rot)
		let regionPath = CGPath(rect: fieldRect, transform: &transform)
		fieldRegion = SKRegion(path: regionPath)
		
		gravityField.region = fieldRegion
		dragField.region = fieldRegion
	}
	
	func smash() {
		glueBlock.remove(for: side)
		
		// TO DO: Add particles and sounds effects
		if let level = scene as?  Level {
			level.fans.remove(at: level.fans.index(of: self)!)
		}
		removeFromParent()
	}
	func rotationRelativeToSceneFor(node: SKNode) -> CGFloat {
		var nodeRotation = CGFloat(0)
		var tempNode: SKNode = node
		
		while !(tempNode is SKScene) {
			nodeRotation += tempNode.zRotation
			tempNode = tempNode.parent!
		}
		
		return nodeRotation
	}
	
	// Check for actions other than animate
	func checkHasActions(node: SKNode) -> Bool {
		var tempNode = node
		
		while !(tempNode is SKScene) {
			if !tempNode.actionForKeyIsRunning(key: "animate") {
				if tempNode.hasActions() {
					return true
				}
			}
			tempNode = tempNode.parent!
		}
		return false
	}
	
	// Update the region rotations
	func updateFields(rotation: CGFloat) {
		// Calculate region rotation transform
		let rot = rotation - (CGFloat(360).degreesToRadians() - rotation)
		
		var transform = CGAffineTransform(rotationAngle: rot)
		let regionPath = CGPath(rect: fieldRect, transform: &transform)
		fieldRegion = SKRegion(path: regionPath)
		
		gravityField.region = fieldRegion
		dragField.region = fieldRegion
	}
}
