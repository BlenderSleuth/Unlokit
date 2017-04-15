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
	
	override func setupPhysics(shadowed isShadowed: Bool) {
		super.setupPhysics(shadowed: isShadowed)
		
		physicsBody?.categoryBitMask = Category.bombTool
		physicsBody?.contactTestBitMask = Category.bounds | Category.blockMtl |
										  Category.blockBnc | Category.blockGlue |
										  Category.blockBreak | Category.tools
	}
	func setupFuse(scene: SKScene) {
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
		scene.enumerateChildNodes(withName: "//*Breakable") {node, _ in
			if let breakable = (node as? Breakable) {
				let position = self.convert(node.position, from: node.parent!)
				if region.contains(position) {
					breakable.shatter(scene: scene)
				}
			}
		}
		// Play sound
		scene.run(SoundFX.sharedInstance["explosion"]!)
		
		let explode = SKEmitterNode(fileNamed: "BombExplode")!
		explode.position = scene.convert(position, from: self.parent!)
		scene.addChild(explode)
		removeFromParent()
	}
	func explode(scene: SKScene) {
		guard let parent = parent else {
			return
		}
		position = scene.convert(self.position, from: parent)
		explode(scene: scene, at: position)
	}
	func countDown(scene: SKScene, at point: CGPoint, side: Side) {
		var countDown = 3
		
		let label = SKLabelNode(text: "\(countDown)")
		label.fontName = "NeuropolXRg-Regular"
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
			if let glueBlock = self.parent as? BlockGlueNode {
				glueBlock.remove(for: side)
			}

			let position: CGPoint
			if let block = self.parent as? BlockGlueNode {
				position = scene.convert(side.position, from: block)
			} else {
				position = point
			}

			self.move(toParent: scene)
			self.explode(scene: scene, at: position)
		}
	}
}
