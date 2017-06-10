//
//  TutorialScene.swift
//  Unlokit
//
//  Created by Ben Sutherland on 5/5/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit
import UIKit

// To keep track of which part the tutorial is
enum TutStage: Int {
	case start = 0
	case lock
	case key
	case goal
	case mtlBlock
	case spring
	case rubberBlock
	case bomb
	case breakableBlock
	case glue
	case glueBlock
	case fan
	case fanGlueBlock
	case gravity
	case gravityGlueBlock
	case load
	case rotate
	case fire
	case last
	
	var nextStep: TutStage? {
		return TutStage(rawValue: rawValue + 1)
	}
}
// For triggering different actions
enum TriggerAction {
	case touch
	case loadKey
	case rotate
	case fire
}

class TutorialScene: GameScene {
	
	var animating = false
	
	var background: SKSpriteNode?
	
	var tutStage: TutStage = .start
	// The current helpnode
	var current: HelpNode!
	
	override func didMove(to view: SKView) {
		super.didMove(to: view)
		// Set the startingg angle of the controller
		controller.angle = 120
		startTutorial()
	}
	
	override func moveController(_ location: CGPoint) {
		super.moveController(location)
		goToNextStage(action: .rotate)
	}
	
	func startTutorial() {
		// Dark background to fade out later
		background = SKSpriteNode(color: UIColor(red: 0.08, green: 0, blue: 0.08, alpha: 0.92), size: self.size)
		background?.zPosition = 240
		background?.position = CGPoint(x: size.width/2, y: size.height/2)
		addChild(background!)
		
		let boxSize = CGSize(width: 1200, height: 200)
		let boxPos = CGPoint(x: size.width/2, y: size.height/2)
		current = HelpNode(position: boxPos, size: boxSize, text: "Welcome to Unlokit", nextAction: "Tap to continue")
		current.alpha = 0.7
		current.zPosition = 250
		addChild(current)
		
		// Setup nodes for the tutorial
		fireNode.isUserInteractionEnabled = false
		fireNode.zPosition = 210
		key.isUserInteractionEnabled = true
		for (_, tool) in toolIcons {
			tool.isUserInteractionEnabled = true
		}
		// Make camera follow the
		nodeToFollow = current
	}
	func goToNextStage(action: TriggerAction) {
		// Make sure it is not animating
		guard !animating else {
			return
		}
		
		let nextStage: TutStage
		if let next = tutStage.nextStep {
			nextStage = next
		} else {
			print("Last Stage")
			nextStage = tutStage
		}
		
		// Default properties
		var size = CGSize(width: 700, height: 300)
		var arrowVector: CGPoint!
		let pos: CGPoint
		let text: String
		var nextAction = "Tap to continue"
		
		// Check which stage we are up to
		switch (nextStage, action) {
		case (.lock, .touch):
			arrowVector = CGPoint(x: 200, y: 200)
			let lockPos = convert(lock.position, from: lock.parent!)
			pos = CGPoint(x: lockPos.x - size.width/2 - arrowVector.x,
			              y: lockPos.y - size.height/2 - arrowVector.y)
			text = "This is the lock"
		case (.key, .touch):
			arrowVector = CGPoint(x: -115, y: -115)
			pos = CGPoint(x: key.position.x + size.width/2 - arrowVector.x,
			              y: key.position.y + size.height/2 - arrowVector.y)
			text = "This is the key"
		case (.goal, .touch):
			size.width = 2100
			pos = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
			text = "The goal of the game: shoot the key into the lock"
		//********************* TOOL SECTION **********************************************
		case (.spring, .touch), (.bomb, .touch), (.glue, .touch), (.fan, .touch), (.gravity, .touch):
			
			let tool: ToolIcon
			
			// Only set different properties
			switch nextStage {
			case .spring:
				size.width = 1400
				tool = toolIcons[.spring]!
				text = "The spring tool will turn blocks..."
			case .bomb:
				size.width = 1200
				tool = toolIcons[.bomb]!
				text = "The bomb tool can destroy..."
			case .glue:
				size.width = 1200
				tool = toolIcons[.glue]!
				text = "The glue tool will turn blocks..."
			case .fan:
				size.width = 1100
				tool = toolIcons[.fan]!
				text = "The fan tool will stick to..."
			case .gravity:
				size.width = 1500
				tool = toolIcons[.gravity]!
				text = "The black hole tool will create..."
			default:
				return
			}
			
			arrowVector = CGPoint(x: -110, y: -110)
			let toolPos = convert(tool.position, from: tool.parent!)
			pos = CGPoint(x: toolPos.x + size.width/2 - arrowVector.x,
			              y: toolPos.y + size.height/2 - arrowVector.y)
			
		//********************* BLOCK SECTION **********************************************
		case (.mtlBlock, .touch), (.rubberBlock, .touch), (.breakableBlock, .touch), (.glueBlock, .touch), (.fanGlueBlock, .touch), (.gravityGlueBlock, .touch):
			
			arrowVector = CGPoint(x: 130, y: -130)
			let block: SKNode
			
			switch nextStage {
			case .mtlBlock:
				block = childNode(withName: "blockShow")!
				arrowVector.x = -130
				text = "This is a block"
			case .rubberBlock:
				size.width = 900
				arrowVector.x = -130
				block = childNode(withName: "rubberBlockShow")!
				text = "...into rubber blocks"
			case .breakableBlock:
				size.width = 900
				block = childNode(withName: "breakableBlockShow")!
				text = "...breakable blocks"
			case .glueBlock:
				size.width = 900
				block = childNode(withName: "glueBlockShow")!
				text = "...into glue blocks"
			case .fanGlueBlock:
				block = childNode(withName: "//breakableFan")!
				text = "...glue blocks"
			case .gravityGlueBlock:
				size.width = 800
				block = childNode(withName: "gravityBlockShow")!
				text = "...a black hole"
			default:
				return
			}
			
			let blockPos = convert(block.position, from: block.parent!)
			
			if arrowVector.x < 0 {
				pos = CGPoint(x: blockPos.x + size.width/2 - arrowVector.x,
				              y: blockPos.y + size.height/2 - arrowVector.y)
			} else {
				pos = CGPoint(x: blockPos.x - size.width/2 - arrowVector.x,
				              y: blockPos.y + size.height/2 - arrowVector.y)
			}
			
		//********************* INTERACTIVE SECTION **********************************************
		case (.load, .touch):
			size.width = 1000
			arrowVector = CGPoint(x: -115, y: -115)
			pos = CGPoint(x: key.position.x + size.width/2 - arrowVector.x,
			              y: key.position.y + size.height/2 - arrowVector.y)
			key.zPosition = 510
			key.isUserInteractionEnabled = false
			text = "Tap the key to load it"
			nextAction = "Load key"
		case (.rotate, .loadKey):
			key.isUserInteractionEnabled = true
			size = CGSize(width: 1200, height: 600)
			arrowVector = CGPoint(x: -80, y: -900)
			let controllerPos = controller.scenePosition!
			pos = CGPoint(x: controllerPos.x + size.width/2 - arrowVector.x,
			              y: controllerPos.y + size.height/2 - arrowVector.y)
			text = "Rotate the controller to aim"
			nextAction = "Rotate controller"
		case (.fire, .rotate):
			size.width = 800
			arrowVector = CGPoint(x: 50, y: -280)
			let firePos = convert(fireNode.position, from: fireNode.parent!)
			pos = CGPoint(x: firePos.x - size.width/2 - arrowVector.x,
			              y: firePos.y + size.height/2 - arrowVector.y)
			text = "Press this to fire"
			nextAction = "Fire!"
			fireNode.isUserInteractionEnabled = true
		case (.last, .fire):
			key.zPosition = 50
			fireNode.zPosition = 50
			// Hide the node
			current.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
			return
		default:
			return
		}
		
		// Only set this after
		tutStage = nextStage
		
		// Set this to animating
		animating = true
		
		// Fadeout the arrow first, looks ugly otherwise
		current.arrowSprite?.run(SKAction.fadeOut(withDuration: 0.05))
		
		background?.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()])) {
			weak var `self` = self
			self?.background = nil
		}
		// Fadeout last helpnode
		current.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
		
		// Create a new helpnode
		current = HelpNode(position: pos,
		                   size: size,
		                   text: text,
		                   arrow: arrowVector,
		                   nextAction: nextAction)
		
		// Fade in the help node
		current.alpha = 0
		addChild(current)
		
		current.run(SKAction.fadeIn(withDuration: 0.3)) {
			weak var `self` = self
			self?.animating = false
		}
		
		// Make the camera follow it
		nodeToFollow = current
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		for _ in touches {
			goToNextStage(action: .touch)
		}
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		// Don't go onto the next turorial
	}
}

class HelpNode: SKSpriteNode {
	var arrowSprite: SKSpriteNode?
	
	init(position: CGPoint, size: CGSize, text: String, arrow: CGPoint? = nil, nextAction: String) {
		super.init(texture: nil, color: .clear, size: size)
		
		self.alpha = 0
		run(SKAction.fadeIn(withDuration: 0.3))
		
		self.position = position
		self.anchorPoint = CGPoint(x: 0, y: 0)
		self.zPosition = 200
		
		let box = SKShapeNode(rect: CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size), cornerRadius: 25)
		box.fillColor = .purple
		box.strokeColor = .black
		box.lineWidth = 3
		box.glowWidth = 2
		addChild(box)
		
		let label = SKLabelNode(fontNamed: neuropolFont)
		label.verticalAlignmentMode = .center
		label.fontSize = 64
		label.text = text
		addChild(label)
		
		let tapToContinue = SKLabelNode(fontNamed: neuropolFont)
		label.verticalAlignmentMode = .center
		tapToContinue.text = nextAction
		tapToContinue.fontSize = 40
		tapToContinue.position.y = -size.height / 3 // Close to the bottom of the box
		tapToContinue.alpha = 0
		addChild(tapToContinue)
		
		// Actions
		let fadeIn = SKAction.fadeIn(withDuration: 1)
		fadeIn.timingMode = .easeInEaseOut
		let fadeOut = SKAction.fadeOut(withDuration: 1)
		fadeOut.timingMode = .easeInEaseOut
		let fadeInOut = SKAction.repeatForever(SKAction.sequence([fadeIn, fadeOut]))
		tapToContinue.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), fadeInOut]))
		
		// Create an arrow to point at something
		if let arrow = arrow {
			let width = sqrt(pow(arrow.x, 2) + pow(arrow.y, 2))
			let arrowSize = CGSize(width: width, height: 30)
			arrowSprite = SKSpriteNode(color: .purple, size: arrowSize)
			
			// Find the corner based on arrow vector
			let posX: CGFloat
			let posY: CGFloat
			
			if arrow.x < 0 {
				posX = -size.width/2
			} else {
				posX = size.width/2
			}
			if arrow.y < 0 {
				posY = -size.height/2
			} else {
				posY = size.height/2
			}
			
			arrowSprite!.position = CGPoint(x: posX, y: posY)
			
			arrowSprite!.zRotation = atan(arrow.y/arrow.x)
			addChild(arrowSprite!)
			
			let circle = SKShapeNode(circleOfRadius: width/2)
			circle.fillColor = .clear
			circle.strokeColor = .purple
			circle.lineWidth = 10
			circle.position = CGPoint(x: posX + arrow.x,  y: posY + arrow.y)
			addChild(circle)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
