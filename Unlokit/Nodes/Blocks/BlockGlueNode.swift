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
	var connected: [Side : Bool] = [.up: false, .down: false, .left: false, .right: false, .centre: false]
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.blockGlue
	}
	
	func checkConnected(scene: GameScene) {

		for child in children {
			// Modify connected array to include pre-added nodes
			let side: Side
			switch child.position {
			case up:
				connected[.up] = true
				side = .up
			case down:
				connected[.down] = true
				side = .down
			case left:
				connected[.left] = true
				side = .left
			case right:
				connected[.right] = true
				side = .right
			case centre:
				// for gravity
				connected[.centre] = true
				side = .centre
			default:
				print("Couldn't find side at \(child.position)")
				return
			}
			
			if child.name == "fanPlaceholder" && side != .centre {
				// Make sure connected side is false
				connected[side] = false
				
				// Get fan node from file
				let fanNode = SKNode(fileNamed: "FanRef")?.children.first as! FanNode
				fanNode.removeFromParent()

				if add(node: fanNode, to: side) {

					// Fan setup after it has been added
					fanNode.setup(level: scene, block: self, side: side)

					// Removes the placeholder
					child.removeFromParent()
				}
			}
		}

		// Detect blocks around so as to remove the possiblity of a fan inbetween blocks
		let rect = CGRect(origin: frame.origin, size: frame.size)

		var transform = CGAffineTransform(translationX: 0, y: frame.height)
		let pathUp = CGPath(rect: rect, transform: &transform)
		let regionUp = SKRegion(path: pathUp)

		transform = CGAffineTransform(translationX: 0, y: -frame.height)
		let pathDown = CGPath(rect: rect, transform: &transform)
		let regionDown = SKRegion(path: pathDown)

		transform = CGAffineTransform(translationX: -frame.height, y: 0)
		let pathLeft = CGPath(rect: rect, transform: &transform)
		let regionLeft = SKRegion(path: pathLeft)

		transform = CGAffineTransform(translationX: frame.height, y: 0)
		let pathRight = CGPath(rect: rect, transform: &transform)
		let regionRight = SKRegion(path: pathRight)

		scene.enumerateChildNodes(withName: "//*block*") { child, _ in
			if child is SKSpriteNode {
				let position = self.parent!.convert(child.position, from: child.parent!)

				func addBlock(to side: Side) {
					self.connected[side] = true
					if var breakable = child as? Breakable {
						breakable.glueBlock = self
						breakable.side = side
					}
				}

				if regionUp.contains(position) {
					addBlock(to: .up)
				} else if regionDown.contains(position) {
					addBlock(to: .down)
				} else if regionLeft.contains(position) {
					addBlock(to: .left)
				} else if regionRight.contains(position) {
					addBlock(to: .right)
				}
			}
		}
	}
	
	func remove(for side: Side) {
		connected[side] = false
	}

	func getSideIfConnected(contact: SKPhysicsContact) -> Side? {
		let side = super.getSide(contact: contact)
		// Check if side is connected
		if connected[side]! {
			return nil
		}
		return side
	}

	// Add a node, based on side. Returns true if successful
	func add(node: SKSpriteNode, to side: Side) -> Bool {
		// Make sure there isn't already one on that side
		guard connected[side] == false else {
			return false
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
		case .centre:
			position = centre
			zRotation = CGFloat(0).degreesToRadians()
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
		return true
	}
	
	func add(gravityNode: GravityNode) -> Bool {
		// Check there are no other nodes
		guard connected[.centre] == false else {
			return false
		}
		
		// Precaution
		gravityNode.removeFromParent()
		
		gravityNode.position = centre
		addChild(gravityNode)

		connected[.centre] = true

		return true
	}
}
