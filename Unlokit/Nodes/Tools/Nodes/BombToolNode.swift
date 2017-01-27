//
//  BombToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 13/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BombToolNode: ToolNode {
    
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
		(childNode(withName: "fuse")?.children.first as! SKEmitterNode).targetNode = scene
	}
	
	func explode(scene: SKScene) {
		// Check if this is the first explosion
		if parent == nil {
			return
		}
		
		// TO DO: add sound
		let emitter = SKEmitterNode(fileNamed: "BombExplode")!
		emitter.position = scene.convert(position, from: self.parent!)
		scene.addChild(emitter)
		removeFromParent()
	}
}
