//
//  GlueBlockNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class GlueBlockNode: BlockNode {
	
	weak var gameScene: GameScene!
	
	// Side that are connected
	var connected: [Side : Bool] = [.up: false, .down: false, .left: false, .right: false, .centre: false]
	
	#if DEBUG
		var circles = [SKShapeNode]()
	#endif
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		physicsBody?.categoryBitMask = Category.gluBlock
		physicsBody?.collisionBitMask = Category.all ^ Category.tools

		if physicsBody!.isDynamic {
			physicsBody?.fieldBitMask = Category.fields
		}
	}
	
	override func setup(scene: GameScene) {
		super.setup(scene: scene)
		gameScene = scene
		checkConnected()
	}
	
	func checkConnected() {
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
				// For gravity
				connected[.centre] = true
				side = .centre
			default:
				print("Couldn't find side at \(child.position)")
				continue
			}
			
			if child.name == "fanPlaceholder" && side != .centre {
				// Make sure connected side is false
				connected[side] = false
				
				// Get fan node from file
				let fanNode = SKNode(fileNamed: "FanRef")?.children.first as! FanNode
				fanNode.removeFromParent()

				if add(node: fanNode, to: side) {
					// Fan setup after it has been added
					fanNode.setup(scene: gameScene, block: self, side: side)

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

		gameScene.enumerateChildNodes(withName: "//*Block") { child, _ in
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
		//debugConnected()
	}
	
	func remove(for side: Side) {
		connected[side] = false
		//debugConnected()
	}
	#if DEBUG
	func debugConnected() {
		for circle in circles {
			circle.removeFromParent()
		}
		for (connect, yes) in connected {
			if yes {
				let circle = SKShapeNode(circleOfRadius: 10)
				circle.fillColor = .blue
				circle.strokeColor = .blue
				circle.position = connect.position
				circle.zPosition = 100
				circles.append(circle)
				addChild(circle)
			}
		}
	}
	#endif
	
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
		
		if node.parent == nil {
			node.position = position
			node.zRotation = zRotation
			addChild(node)
		} else {
			node.move(toParent: self)
			node.run(SKAction.move(to: position, duration: 0.1)) {

				// Check if the physics body is dynamic
				if self.physicsBody!.isDynamic {
					if let body1 = node.physicsBody,
						let body2 = self.physicsBody,
						let scene = self.scene,
						let parent = node.parent {

						node.physicsBody?.contactTestBitMask ^= Category.gluBlock

						let anchor = scene.convert(node.position, from: parent)
						let joint = SKPhysicsJointPin.joint(withBodyA: body1, bodyB: body2, anchor: anchor)
						scene.physicsWorld.add(joint)
					}
					
				} else {
					node.physicsBody?.isDynamic = false
				}
			}
		}
		
		if var breakable = node as? Breakable {
			breakable.glueBlock = self
			breakable.side = side
		}
		
		//debugConnected()
		
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
		
		//debugConnected()

		return true
	}
	
	func update() {
		print("Glue block")
	}
}
