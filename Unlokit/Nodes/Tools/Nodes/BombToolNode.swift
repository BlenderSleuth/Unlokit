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
	
	var radius: CGFloat = 200
	
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
	
	override func smash(scene: LevelScene) {
		explode(scene: scene, at: self.position)
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
	func explode(scene: SKScene, at point: CGPoint) {
		// Check if this is the first explosion
		if parent == nil {
			return
		}
		let regionRect = CGRect(origin: CGPoint(x: -radius, y: -radius), size: CGSize(width: radius * 2, height: radius * 2))
		let regionPath = CGPath(ellipseIn: regionRect, transform: nil)
		let region = SKRegion(path: regionPath)
		
		self.position = point
		
		// Shatter all breakables in radius
		scene.enumerateChildNodes(withName: "//breakable*") {node, _ in
			if let breakable = (node as? Breakable) {
				let position = self.convert(node.position, from: node.parent!)
				if region.contains(position) {
					breakable.shatter()
				}
			}
		}
		
		let sound = SoundFX.sharedInstance["explosion"]!
		scene.run(sound)
		
		let explode = SKEmitterNode(fileNamed: "BombExplode")!
		explode.position = scene.convert(position, from: self.parent!)
		scene.addChild(explode)
		removeFromParent()
	}
	func countDown(scene: SKScene, at point: CGPoint, side: Side) {
		var countDown = 5
		
		let position: CGPoint
		if let block = self.parent as? BlockGlueNode {
			position = scene.convert(side.position, from: block)
		} else {
			position = point
		}
		
		let label = SKLabelNode(text: "\(countDown)")
		label.fontSize = 75
		label.verticalAlignmentMode = .center
		label.zPosition = 100
		label.position = position
		scene.addChild(label)
		
		let wait = SKAction.wait(forDuration: 1)
		let block = SKAction.run {
			countDown -= 1
			label.text = "\(countDown)"
		}
		
		let sequence = SKAction.sequence([wait, block])
		let repeatAction = SKAction.repeat(sequence, count: countDown)
		
		run(repeatAction) {
			label.removeFromParent()
			if let glueBlock = self.parent as? BlockGlueNode {
				glueBlock.remove(for: side)
			}
			self.move(toParent: scene)
			self.explode(scene: scene, at: position)
		}
	}
}
