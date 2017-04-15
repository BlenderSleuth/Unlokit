//
//  FanNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 25/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class FanNode: SKSpriteNode, Breakable {
	// Children
	var gravityField: SKFieldNode!
	var dragField: SKFieldNode!

	var backGravityField: SKFieldNode?

	private var emitter: SKEmitterNode!

	var glueBlock: BlockGlueNode?
	var side: Side?
	
	var particleTexture: SKTexture?
	
	var fieldLength: CGFloat?
	var fieldRect: CGRect!
	var fieldRegion: SKRegion!
	
	var strength: CGFloat = 0 {
		didSet {
			gravityField.strength = Float(strength)
			setParticleVelocity(strength: strength)
		}
	}
	
	var isMoving = false
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		// Get field references
		gravityField = childNode(withName: "gravityField") as! SKFieldNode
		gravityField.falloff = 0.1

		gravityField.categoryBitMask = Category.fanGravityField
		
		dragField = childNode(withName: "dragField") as! SKFieldNode
		dragField.strength = 0.01
		dragField.categoryBitMask = Category.fanDragField
		
		emitter = childNode(withName: "emitter")!.children.first as! SKEmitterNode
		
		physicsBody = SKPhysicsBody(rectangleOf: frame.size, center: CGPoint(x: 0, y: frame.size.height / 2))
		// Has to weigh something, but very small amount
		physicsBody?.mass = 0.001

		physicsBody?.categoryBitMask = Category.fan
		physicsBody?.contactTestBitMask = Category.bombTool
		physicsBody?.collisionBitMask = Category.all
	}
	func setup(level: GameScene, block: BlockGlueNode, side: Side) {
		self.glueBlock = block
		self.side = side
		// If level has different properties
		getDataFromParent()
		// Setup other physics things
		setupPhysics(scene: level)
		// Animate fan with frames
		animate(framesAtlas: level.fanFrames)
		// Setup particles and fields
		setupParticles(scene: level)
		setupFields(scene: level)
		
		// Check if fan needs field updates
		isMoving = checkHasActions(node: self)
		
		// Append to fan array
		level.fans.append(self)
		
		// Set strength to default value
		strength = 60
	}
	
	private func getDataFromParent() {
		var data: NSDictionary?
		
		// Find user data from parents
		var tempNode: SKNode = self
		while !(tempNode is SKScene) {
			if let userData = tempNode.userData {
				data = userData
			}
			tempNode = tempNode.parent!
		}
		
		// Set instance properties
		if let length = data?["length"] as? Float {
			fieldLength = CGFloat(length)
		}
		if let strength = data?["strength"] as? Float {
			self.strength = CGFloat(strength)
		}
	}
	private func setupPhysics(scene: SKScene) {
		// Check if fan should be dynamic
		let dynamic: Bool
		if let parentPhysics = self.parent?.physicsBody {

			if parentPhysics.isDynamic {
				dynamic = true

				let anchor = scene.convert(self.position, from: self.parent!)

				let pinJoint = SKPhysicsJointPin.joint(withBodyA: physicsBody!, bodyB: parentPhysics, anchor: anchor)
				pinJoint.shouldEnableLimits = true

				scene.physicsWorld.add(pinJoint)

				self.physicsBody?.fieldBitMask = Category.zero

			} else {
				dynamic = false
			}
		} else {
			dynamic = false
		}
		physicsBody?.isDynamic = dynamic
	}

	private func animate(framesAtlas: SKTextureAtlas) {
		var frames = [SKTexture]()
		
		let numOfFrame = framesAtlas.textureNames.count - 1
		
		for i in 0...numOfFrame {
			let textureName = framesAtlas.textureNames[i]
			let texture = framesAtlas.textureNamed(textureName)
			frames.append(texture)
		}
		
		run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 1/15)), withKey: "animate")
	}
	private func setupParticles(scene: GameScene) {
		// Get emitter from child, doesn't work from property
		let emitter = childNode(withName: "emitter")!.children.first! as! SKEmitterNode
		// Set emitter target
		emitter.targetNode = scene
		// Make particles go in the right direction
		let rotation = rotationRelativeToSceneFor(node: self)
		emitter.emissionAngle += rotation

		// Make sure particles don't stand out in darkness
		if scene.isShadowed {
			emitter.particleColorSequence = nil
			emitter.particleColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
			emitter.particleColorBlendFactor = 1.0
		}
	}
	
	// Set emitter velocity based on strength of fan
	private func setParticleVelocity(strength: CGFloat) {
		let rotation = rotationRelativeToSceneFor(node: self)  + CGFloat(-90).degreesToRadians()
		
		// Find vector for angle
		let dx = cos(rotation) * strength
		let dy = sin(rotation) * strength
		
		emitter.xAcceleration = -dx
		emitter.yAcceleration = -dy
	}
	private func setupFields(scene: SKScene) {
		let rotation = rotationRelativeToSceneFor(node: self)
		
		// Check if custom user properties
		let height: CGFloat
		if fieldLength != nil {
			height = fieldLength!
		} else {
			height = frame.height * 40
		}
		
		let fieldSize = CGSize(width: frame.width, height: height)
		let fieldOrigin = CGPoint(x: -frame.width/2, y: 0)
		fieldRect = CGRect(origin: fieldOrigin, size: fieldSize)
		
		// Calculate region rotation transform
		let fieldRotation = self.fieldRotation(rotation)
		
		var transform = CGAffineTransform(rotationAngle: fieldRotation)
		let regionPath = CGPath(rect: fieldRect, transform: &transform)
		fieldRegion = SKRegion(path: regionPath)
		
		gravityField.region = fieldRegion
		dragField.region = fieldRegion
	}

	func createBackField(scene: SKScene) {
		let rotation = rotationRelativeToSceneFor(node: self)
		let fieldRotation = self.fieldRotation(rotation)
		backGravityField = SKFieldNode.linearGravityField(withVector: vector_float3(0,-1,0))
		backGravityField?.categoryBitMask = Category.fields

		// Set the back field region
		var transform = CGAffineTransform(rotationAngle: fieldRotation)
		let backFieldRect = CGRect(origin: -fieldRect.origin, size: -self.size)
		let backRegionPath = CGPath(rect: backFieldRect, transform: &transform)
		let backFieldRegion = SKRegion(path: backRegionPath)

		backGravityField?.region = backFieldRegion
		addChild(backGravityField!)
	}
	
	// Check for actions other than animate
	func checkHasActions(node: SKNode) -> Bool {
		var tempNode = node
		
		while !(tempNode is SKScene) {
			if !tempNode.actionForKeyIsRunning(key: "animate") {
				if tempNode.hasActions() {
					return true
				}
			}
			tempNode = tempNode.parent!
		}
		return false
	}

	// Calculate the rotation so that the fields rotate correctly.
	func fieldRotation(_ rotation: CGFloat) -> CGFloat {
		return rotation - (CGFloat(360).degreesToRadians() - rotation)
	}
	
	// Update the region rotations
	func updateFields(rotation: CGFloat) {
		// Calculate region rotation transform
		let fieldRotation = self.fieldRotation(rotation)
		
		var transform = CGAffineTransform(rotationAngle: fieldRotation)
		let regionPath = CGPath(rect: fieldRect, transform: &transform)
		fieldRegion = SKRegion(path: regionPath)
		
		gravityField.region = fieldRegion
		dragField.region = fieldRegion

		// Set the back field region
		let backFieldRect = CGRect(origin: fieldRect.origin, size: -self.size)
		let backRegionPath = CGPath(rect: backFieldRect, transform: &transform)
		let backFieldRegion = SKRegion(path: backRegionPath)

		backGravityField?.region = backFieldRegion

		// Get emitter from child, doesn't work from property; not the most efficient, but...
		let emitter = childNode(withName: "emitter")?.children.first as! SKEmitterNode
		emitter.emissionAngle = rotation + CGFloat(90).degreesToRadians()
	}
}
