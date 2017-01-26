//
//  FanNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class FanNode: SKSpriteNode {
	
	var field: SKFieldNode!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setupField(side: Side) {
		// Rectangular field
		let fieldSize = CGSize(width: frame.width * 4, height: frame.height * 15)
		let fieldOrigin = CGPoint(x: -frame.width * 2, y: -50)
		let fieldRect = CGRect(origin: fieldOrigin, size: fieldSize)
		
		let regionPath = CGPath(rect: fieldRect, transform: nil)
		
		let vector: vector_float3 = vector_float3(0,10,0)
		
		/*
		switch side {
		case .up:
			vector = vector_float3(0,30,0)
		case .down:
			vector = vector_float3(0,30,0)
		case .left:
			vector = vector_float3(-30,0,0)
		case .right:
			vector = vector_float3(30,0,0)
		}
		*/
		field = SKFieldNode.linearGravityField(withVector: vector)
		field.strength = 5
		field.region = SKRegion(path: regionPath)
		
		field.categoryBitMask = Category.fanField
		addChild(field)
		
		//let debugNode = SKShapeNode(path: regionPath)
		//debugNode.strokeColor = .blue
		//debugNode.lineWidth = 5
		//addChild(debugNode)
	}
	
	func setupParticles(scene: SKScene) {
		let emitter = self.childNode(withName: "emitter")?.children.first as! SKEmitterNode
		
		// Set emitter target
		emitter.targetNode = scene
		emitter.fieldBitMask = Category.fanField
	}
	
	func animate(framesAtlas: SKTextureAtlas) {
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
