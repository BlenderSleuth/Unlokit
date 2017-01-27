//
//  BlockGlueNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BlockGlueNode: BlockNode {
	
	// Side that are connected
	var connected = [Side: Bool]()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.blockGlue
	}
	func checkConnected(scene: Level) {
		for child in children {
			// Modify connected array to include pre-added nodes
			switch child.position {
			case up:
				connected[.up] = true
			case down:
				connected[.down] = true
			case left:
				connected[.left] = true
			case right:
				connected[.right] = true
			case CGPoint.zero:
				// for gravity
				for side in Side.all {
					connected[side] = true
				}
			default:
				break
			}
			if let ref = child as? SKReferenceNode {
				if let node = ref.children.first?.children.first {
					
					if let fan = node as? FanNode {
						// Setup fan
						fan.field.zRotation += CGFloat(180).degreesToRadians()
						fan.field.direction = vector_float3(0,-10,0)
						fan.setupParticles(scene: scene)
						fan.animate(framesAtlas: scene.fanFrames)
					}
					node.move(toParent: self)
					ref.removeFromParent()
				}
			}
		}
	}
	
	// Add a node, based on side
	func add(node: SKSpriteNode, to side: Side) {
		// Make sure there isn't already one on that side
		guard connected[side] == nil else {
			return
		}
		
		let position: CGPoint
		let zRotation: CGFloat
		switch side {
		case .up:
			position = up
			zRotation = CGFloat(0).degreesToRadians()
		case .down:
			position = down
			zRotation = CGFloat(180).degreesToRadians()
		case .left:
			position = left
			zRotation = CGFloat(90).degreesToRadians()
		case .right:
			position = right
			zRotation = CGFloat(270).degreesToRadians()
		}
		
		connected[side] = true
		
		node.physicsBody?.isDynamic = false
		
		if node.parent == nil {
			node.position = position
			node.zRotation = zRotation
			addChild(node)
		} else {
			node.move(toParent: self)
			node.run(SKAction.group([SKAction.move(to: position, duration: 0.1), SKAction.rotate(toAngle: zRotation, duration: 0.1)]))
		}
	}
	
	func add(gravityNode: GravityNode) {
		// Check there is no other nodes
		guard connected.isEmpty else {
			return
		}
		
		// Precaution
		gravityNode.removeFromParent()
		
		gravityNode.position = position
		addChild(gravityNode)
		
		// Fill up remaining sides
		for side in Side.all {
			connected[side] = true
		}
	}
}
