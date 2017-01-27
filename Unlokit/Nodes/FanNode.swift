//
//  FanNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class FanNode: SKSpriteNode {
	
	private var field: SKFieldNode!
	
	var fieldStrength: Float = 1000 {
		didSet {
			field.strength = fieldStrength
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		// Rectangular field
		let fieldSize = CGSize(width: frame.width, height: frame.height * 15)
		let fieldOrigin = CGPoint(x: -frame.width / 2, y: -60)
		let fieldRect = CGRect(origin: fieldOrigin, size: fieldSize)
		
		let regionPath = CGPath(rect: fieldRect, transform: nil)
		
		// Positive Y, adjust with field strength
		let vector: vector_float3 = vector_float3(0,1,0)
		
		field = SKFieldNode.linearGravityField(withVector: vector)
		field.strength = fieldStrength
		field.region = SKRegion(path: regionPath)
		
		field.categoryBitMask = Category.fanField
		addChild(field)
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
