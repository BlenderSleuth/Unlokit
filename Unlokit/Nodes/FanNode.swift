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
		
		field = SKFieldNode.velocityField(withVector: vector_float3(6, 4, 6))
		//addChild(field)
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
