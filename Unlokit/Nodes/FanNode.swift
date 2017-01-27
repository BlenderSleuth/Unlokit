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
	
	var fieldStrength: Float = 60 {
		didSet {
			gravityField.strength = fieldStrength
			emitter.yAcceleration = CGFloat(fieldStrength * 2)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		// Rectangular field
		let fieldSize = CGSize(width: frame.width, height: frame.height * 35)
		let fieldOrigin = CGPoint(x: -frame.width / 2, y: 0)
		let fieldRect = CGRect(origin: fieldOrigin, size: fieldSize)
		
		let regionPath = CGPath(rect: fieldRect, transform: nil)
		let region = SKRegion(path: regionPath)
		
		// Positive Y, adjust with field strength
		let vector: vector_float3 = vector_float3(0,1,0)
		
		gravityField = SKFieldNode.linearGravityField(withVector: vector)
		//field = childNode(withName: "field") as! SKFieldNode
		//field.direction = vector
		gravityField.falloff = 0.1
		gravityField.strength = fieldStrength
		gravityField.region = region
		//gravityField.isEnabled = false
		gravityField.categoryBitMask = Category.fanGravityField
		addChild(gravityField)
		
		dragField = SKFieldNode.dragField()
		dragField.region = region
		dragField.strength = 0.01
		//dragField.isEnabled = false
		dragField.categoryBitMask = Category.fanDragField
		addChild(dragField)
		
		emitter = self.childNode(withName: "emitter")?.children.first as! SKEmitterNode
		
		physicsBody? = SKPhysicsBody(edgeLoopFrom: frame)
		physicsBody?.categoryBitMask = Category.fan
		physicsBody?.contactTestBitMask = Category.bombTool
		physicsBody?.collisionBitMask = Category.all
		
		// Debug node
		let debugNode = SKShapeNode(rect: fieldRect)
		debugNode.strokeColor = .blue
		debugNode.lineWidth = 5
		//addChild(debugNode)
	}
	
	func setup(level: Level, block: BlockGlueNode, side: Side) {
		animate(framesAtlas: level.fanFrames)
		setupParticles(scene: level)
		self.glueBlock = block
		self.side = side
	}
	
	func smash() {
		glueBlock.remove(for: side)
		
		// TO DO: Add particles and sounds effects
		removeFromParent()
	}
	
	private func setupParticles(scene: SKScene) {
		// Set emitter target
		emitter.targetNode = scene
		emitter.fieldBitMask = Category.zero
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
}
