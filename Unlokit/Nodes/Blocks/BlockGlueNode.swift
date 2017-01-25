//
//  BlockGlueNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

enum Side {
	case up
	case down
	case left
	case right
}

class BlockGlueNode: SKSpriteNode {
	
	// For calculating the side that was contacted
	var up: CGPoint!
	var down: CGPoint!
	var left: CGPoint!
	var right: CGPoint!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		// get coordinates of sides of block
		let halfWidth = frame.width / 2
		let halfHeight = frame.height / 2
		down = CGPoint(x: frame.origin.x + halfWidth, y: frame.origin.y)
		up = CGPoint(x: frame.origin.x + halfWidth, y: frame.origin.y + frame.size.height)
		left = CGPoint(x: frame.origin.x, y: frame.origin.y + halfHeight)
		right = CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y + halfHeight)
		
		physicsBody?.categoryBitMask = Category.blockGlue
	}
	
	// Add a node, based on side
	func add(node: SKSpriteNode, to side: Side) {
		// Precaution
		node.removeFromParent()
		
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
			zRotation = CGFloat(270).degreesToRadians()
		case .right:
			position = right
			zRotation = CGFloat(90).degreesToRadians()
		}
		
		node.position = position
		node.zRotation = zRotation
		addChild(node)
	}
	
	// Find side from contact
	func getSide(contact: SKPhysicsContact) -> Side {
		// Get point in block coordinates
		let point = convert(contact.contactPoint, from: scene!)
		
		let upDistance = getDistance(p1: point, p2: up)
		let downDistance = getDistance(p1: point, p2: down)
		let leftDistance = getDistance(p1: point, p2: left)
		let rightDistance = getDistance(p1: point, p2: right)
		
		let dict = [Side.up: upDistance, Side.down: downDistance, Side.left: leftDistance, Side.right: rightDistance]
		
		var side = Side.up
		
		// Large number to start
		var smallestDistance = CGFloat(UInt32.max)
		
		// Find smallest distance
		for (sideName, distance) in dict {
			if distance < smallestDistance {
				smallestDistance = distance
				side = sideName
			}
		}
		return side
	}
	
	// Difference between two points
	func getDistance(p1:CGPoint,p2:CGPoint)->CGFloat {
		let xDist = (p2.x - p1.x)
		let yDist = (p2.y - p1.y)
		return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
	}
}
