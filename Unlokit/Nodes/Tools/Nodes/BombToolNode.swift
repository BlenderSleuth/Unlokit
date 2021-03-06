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
	
	var exploded = false
	
	var radius: CGFloat = 200
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        type = .bomb
    }
	
	override func setupPhysics(shadowed isShadowed: Bool) {
		super.setupPhysics(shadowed: isShadowed)
		
		physicsBody?.categoryBitMask = Category.bombTool
		physicsBody?.contactTestBitMask = Category.bounds | Category.mtlBlock |
										  Category.bncBlock | Category.gluBlock |
										  Category.breakBlock | Category.tools
	}
	func setupFuse(scene: GameScene) {
		fuse = childNode(withName: "fuse")?.children.first as! SKEmitterNode
		fuse.targetNode = scene
	}
	
	override func smash(scene: GameScene) {
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
	func explode(scene: GameScene, at point: CGPoint) {
		// Check if this is the first explosion
		if parent == nil || exploded {
			return
		}
		
		exploded = true
		
		let regionRect = CGRect(origin: CGPoint(x: -radius, y: -radius), size: CGSize(width: radius * 2, height: radius * 2))
		let regionPath = CGPath(ellipseIn: regionRect, transform: nil)
		let region = SKRegion(path: regionPath)
		
		self.position = point
		
		var breakables = [Breakable]()
		
		// Shatter all breakables in radius
		scene.enumerateChildNodes(withName: "//breakable*") { node, _ in
			// Protect self
			guard node != self else {
				return
			}
			if let breakable = (node as? Breakable) {
				let position = self.convert(node.position, from: node.parent!)
				if region.contains(position) {
					breakables.append(breakable)
				}
			}
		}
		
		// Shatter objects outside of loop
		for breakable in breakables {
			breakable.shatter(scene: scene)
		}
		// Play sound
		scene.run(SoundFX.sharedInstance["explosion"]!)
		
		let explode = SKEmitterNode(fileNamed: "BombExplode")!
		explode.position = scene.convert(position, from: self.parent!)
		scene.addChild(explode)
		removeFromParent()
	}
	func explode(scene: GameScene) {
		guard let parent = parent else {
			return
		}
		position = scene.convert(self.position, from: parent)
		explode(scene: scene, at: position)
	}
	func countDown(scene: GameScene, at point: CGPoint, side: Side) {
		var countDown = 3
		
		let label = SKLabelNode(text: "\(countDown)")
		label.fontName = neuropolFont
		label.fontSize = 64
		label.verticalAlignmentMode = .center
		label.zPosition = 100
		//label.position = position
		addChild(label)
		
		let wait = SKAction.wait(forDuration: 1)
		let block = SKAction.run {
			countDown -= 1
			label.text = "\(countDown)"
		}
		
		let sequence = SKAction.sequence([wait, block])
		let repeatAction = SKAction.repeat(sequence, count: countDown)
		
		run(repeatAction) {
			label.removeFromParent()
			if let glueBlock = self.parent as? GlueBlockNode {
				glueBlock.remove(for: side)
			}

			let position: CGPoint
			if let block = self.parent as? GlueBlockNode {
				position = scene.convert(side.position, from: block)
			} else {
				position = point
			}

			self.move(toParent: scene)
			self.explode(scene: scene, at: position)
		}
	}
}
