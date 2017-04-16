//
//  BreakBlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

protocol Breakable {
	func shatter(scene: SKScene)
	var glueBlock: GlueBlockNode? { get set }
	var side: Side? { get set }

	var particleTexture: SKTexture? { get }
	
	// From SKSpriteNode
	var parent: SKNode? { get }
	var position: CGPoint { get }
	
	func removeFromParent()
}
extension Breakable {
	func shatter(scene: SKScene) {
		// Remove from blocks 'connected' array
		if let side = side, let block = glueBlock {
			block.remove(for: side)
		}
		
		
		if let parent = parent {
			let emitter = SKEmitterNode(fileNamed: "Shatter")!
			// If there is a custom texture, use it
			if let texture = particleTexture {
				emitter.particleTexture = texture
			}
			emitter.position = position
			parent.addChild(emitter)
		}
		
		
		scene.run(SoundFX.sharedInstance["blockShatter"]!)
		removeFromParent()
	}
}

class BreakBlockNode: MtlBlockNode, Breakable {
	var side: Side?
	var glueBlock: GlueBlockNode?
	
	var particleTexture: SKTexture?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.breakBlock
	}
}
