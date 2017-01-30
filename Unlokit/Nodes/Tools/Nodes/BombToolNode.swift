//
//  BombToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 13/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BombToolNode: ToolNode {
	// Particles
	var fuse: SKEmitterNode!
	var explode = SKEmitterNode(fileNamed: "BombExplode")!
	
	// TO DO:
	var radius = 50
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        type = .bomb
    }
	
	override func setupPhysics() {
		super.setupPhysics()
		
		physicsBody?.categoryBitMask = Category.bombTool
		physicsBody?.contactTestBitMask = Category.bounds | Category.blockMtl | Category.blockGlue | Category.blockBreak
		physicsBody?.collisionBitMask = Category.all ^ Category.speed // All except speed
	}
	func setupFuse(scene: SKScene) {
		fuse = childNode(withName: "fuse")?.children.first as! SKEmitterNode
		fuse.targetNode = scene
	}
	
	override func smash(scene: Level) {
		explode(scene: scene)
	}
	override func remove() {
		// Hide fuse behind bomb while particles dissipate
		fuse.position = CGPoint.zero
		fuse.particleAlpha = 0
		fuse.move(toParent: scene!)
		
		let action = SKAction.sequence([SKAction.wait(forDuration: 0.7), SKAction.removeFromParent()])
		fuse.run(action)
		
		super.remove()
	}
	func explode(scene: SKScene) {
		// Check if this is the first explosion
		if parent == nil {
			return
		}
		
		// TO DO: add sound
		let sound = SoundFX.sharedInstance["explosion"]!
		scene.run(sound)
		
		let explode = SKEmitterNode(fileNamed: "BombExplode")!
		explode.position = scene.convert(position, from: self.parent!)
		scene.addChild(explode)
		removeFromParent()
	}
}
