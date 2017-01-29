//
//  FanNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class FanNode: SKSpriteNode {
	
	var gravityField: SKFieldNode!
	var dragField: SKFieldNode!
	private var emitter: SKEmitterNode!
	
	var glueBlock: BlockGlueNode!
	var side: Side!
	
	var debugNode: SKShapeNode!
	
	var region: SKRegion!
	
	var strength: CGFloat = 0 {
		didSet {
			gravityField.strength = Float(strength)
			setParticleVelocity(strength: strength)
		}
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
		
		
		run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 1/25)))
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
		
		// Find vector for angle
		let dx = -Float(cos(rotation + CGFloat(-90).degreesToRadians()))
		let dy = -Float(sin(rotation + CGFloat(-90).degreesToRadians()))
		
		gravityField.direction = vector_float3(dx,dy,0)
		
		gravityField.move(toParent: scene)
		dragField.move(toParent: scene)
		
		let fieldSize = CGSize(width: frame.width, height: frame.height * 40)
		let fieldOrigin = CGPoint(x: -frame.width/2, y: 0)
		let fieldRect = CGRect(origin: fieldOrigin, size: fieldSize)
		
		var transform = CGAffineTransform(rotationAngle: rotation)
		
		let regionPath = CGPath(rect: fieldRect, transform: &transform)
		region = SKRegion(path: regionPath)
		
		gravityField.region = region
		dragField.region = region
	}
	
	func smash() {
		glueBlock.remove(for: side)
		
		// TO DO: Add particles and sounds effects
		removeFromParent()
		
		gravityField.removeFromParent()
		dragField.removeFromParent()
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
}
