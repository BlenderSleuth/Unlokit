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
	
	var fieldStrength: Float = 600 {
		didSet {
			gravityField.strength = fieldStrength
			emitter.yAcceleration = CGFloat(fieldStrength * 2)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		// Rectangular field
		let fieldSize = CGSize(width: frame.width, height: frame.height * 35)
		let fieldOrigin = CGPoint(x: -frame.width/2, y: 0)
		let fieldRect = CGRect(origin: fieldOrigin, size: fieldSize)
		
		let regionPath = CGPath(rect: fieldRect, transform: nil)
		region = SKRegion(path: regionPath)
		
		//gravityField = SKFieldNode.linearGravityField(withVector: vector)
		gravityField = childNode(withName: "gravityField") as! SKFieldNode
		gravityField.falloff = 0.1
		gravityField.strength = fieldStrength
		gravityField.region = region
		gravityField.categoryBitMask = Category.fanGravityField
		//addChild(gravityField)
		
		//dragField = SKFieldNode.dragField()
		//dragField = childNode(withName: "dragField") as! SKFieldNode
		//dragField.region = region
		//dragField.strength = 0.01
		//dragField.categoryBitMask = Category.fanDragField
		//addChild(dragField)
		
		//emitter = self.childNode(withName: "emitter")?.children.first as! SKEmitterNode
		
		physicsBody? = SKPhysicsBody(edgeLoopFrom: frame)
		physicsBody?.categoryBitMask = Category.fan
		physicsBody?.contactTestBitMask = Category.bombTool
		physicsBody?.collisionBitMask = Category.all
		
		// Debug node
		debugNode = SKShapeNode(path: regionPath)
		//debugNode = SKShapeNode(path: region.path!)
		//debugNode.setScale(30)
		//debugNode.zRotation = CGFloat(-90).degreesToRadians()
		debugNode.strokeColor = .blue
		debugNode.lineWidth = 5
		//gravityField.addChild(debugNode)
	}
	
	func setup(level: Level, block: BlockGlueNode, side: Side) {
		animate(framesAtlas: level.fanFrames)
		//setupParticles(scene: level)
		setupFields(scene: level)
		self.glueBlock = block
		self.side = side
	}
	
	func setupFields(scene: SKScene) {
		//gravityField.zRotation = rotationRelativeToSceneFor(node: self) + CGFloat(90).degreesToRadians()
		//dragField.zRotation = rotationRelativeToSceneFor(node: self) + CGFloat(90).degreesToRadians()
		
		let rotationV = rotationRelativeToSceneFor(node: self) + CGFloat(-90).degreesToRadians()
		let rotation = rotationRelativeToSceneFor(node: self)// + CGFloat(180).degreesToRadians()
		
		// Find vector for angle
		let dx = -Float(cos(rotationV))
		let dy = -Float(sin(rotationV))
		
		gravityField.direction = vector_float3(dx,dy,0)
		
		gravityField.move(toParent: scene)
		//dragField.move(toParent: scene)
		
		print("Gravity zRotation: \(gravityField.zRotation)")
		print("Gravity: \(gravityField.position)")
		
		let fieldSize = CGSize(width: frame.width, height: frame.height * 35)
		let fieldOrigin = CGPoint(x: -frame.width/2, y: 0)
		let fieldRect = CGRect(origin: fieldOrigin, size: fieldSize)
		
		var transform = CGAffineTransform(rotationAngle: rotation)
		
		let regionPath = CGPath(rect: fieldRect, transform: &transform)
		region = SKRegion(path: regionPath)
		
		gravityField.region = region
		//dragField.region = region
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
