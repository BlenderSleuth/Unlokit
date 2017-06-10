//
//  GameScene.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Category {
	static let zero: UInt32				= 0b0
	
	static let key: UInt32				= 0b1 << 0
	static let lock: UInt32				= 0b1 << 1
	static let bounds: UInt32			= 0b1 << 2
	
	// MARK: - Blocks
	static let mtlBlock: UInt32			= 0b1 << 3
	static let bncBlock: UInt32			= 0b1 << 4
	static let gluBlock: UInt32			= 0b1 << 5
	
	static let breakBlock: UInt32		= 0b1 << 6
	
	static let shadowBlock: UInt32		= 0b1 << 7
	
	static let beamBlock: UInt32		= 0b1 << 8
	
	static let blocks: UInt32 = Category.mtlBlock | Category.bncBlock | Category.gluBlock |
		Category.breakBlock | Category.shadowBlock | Category.beamBlock
	
	// MARK: - Tools
	static let springTool: UInt32		= 0b1 << 9
	static let glueTool: UInt32			= 0b1 << 10
	static let fanTool: UInt32			= 0b1 << 11
	static let gravityTool: UInt32		= 0b1 << 12
	static let bombTool: UInt32			= 0b1 << 13
	static let tools: UInt32 = Category.springTool | Category.glueTool | Category.fanTool | Category.gravityTool | Category.bombTool
	
	// MARK: - Fields
	static let fanGravityField: UInt32	= 0b1 << 14
	static let fanDragField: UInt32		= 0b1 << 15
	static let fields: UInt32			= Category.fanGravityField | Category.fanDragField
	
	// MARK: - Other nodes
	static let fan: UInt32				= 0b1 << 16
	
	static let speed: UInt32			= 0b1 << 17
	static let secretTeleport: UInt32	= 0b1 << 18
	static let ball: UInt32				= 0b1 << 19
	
	// MARK: - Lights
	static let controllerLight: UInt32	= 0b1 << 0
	static let toolLight: UInt32		= 0b1 << 1
	static let lockLight: UInt32		= 0b1 << 2
	static let blockLight: UInt32		= 0b1 << 3
	
	static let all: UInt32				= UInt32.max
}

struct ZPosition {
	static let background: CGFloat					    = -10
	
	static let cannonTower: CGFloat						= 5
	
	static let balls: CGFloat							= 7
	
	static let controller: CGFloat						=  10
	
	static let levelBlocks: CGFloat						=  20
	
	static let tools_key: CGFloat						=  30
	
	static let toolIcons_particles: CGFloat				=  40
	
	static let cannon: CGFloat							=  50
	
	static let interface: CGFloat						=  100
}

// For accessing the GameViewController
protocol LevelController: class {
	var level: Level! { get set }
	
	func startNewGame(levelname: String)
	func startNewGame()
	func saveLevels()
	func finishedLevel()
	func endSecret()
	func returnToLevelSelect()
	func toNextLevel()
}

class GameScene: SKScene {
	
	// MARK: - Variables
	var level: Level!
	
	// Node references
	var controller: ControllerNode!
	
	var fireNode: FireButtonNode!
	var replayButton: ReplayButtonNode!
	var backButton: BackButtonNode!
	var cannon: SKSpriteNode!
	var cameraNode: SKCameraNode!
	var bounds: SKSpriteNode!
	
	var canvasBounds: CGRect!
	var margin: CGFloat!
	
	var isFinished = false
	
	// Array of tools
	var toolBox: SKNode!
	var toolIcons = [ToolType: ToolIcon]()
	var toolNodes = [ToolNode]()
	
	// Key
	var key: KeyNode!
	var lock: LockNode!
	
	// Touch points in different coordinate systems
	var lastTouchPoint = CGPoint.zero
	var lastTouchCam = CGPoint.zero
	
	var currentNode: SKNode?
	
	var levelController: LevelController!
	
	// Audio
	let soundFX = SoundFX.sharedInstance
	
	// For camera following
	var nodeToFollow: SKSpriteNode?
	var isJustFired = false
	let camMoveKey = "cameraMove"
	
	// Preloading textures
	var fanFrames: SKTextureAtlas!
	
	// Dict of fans
	var fans = [FanNode]()

	var isShadowed = false
	
	//MARK: - Setup
	override func willMove(from view: SKView) {
		soundFX.pauseBackgroundMusic()
	}
	
	func setupNodes(delegate: LevelController) {
		// Set default for all scenes
		backgroundColor = .black
		
		// Bind controller to local variable
		controller = childNode(withName: "//controller") as! ControllerNode
		
		// Check for shadow nodes
		enumerateChildNodes(withName: "//shdoBlock") { _, stop in
			#if DEBUG
				self.isShadowed = true
			#else
				self.isShadowed = true
			#endif
			stop.initialize(to: true)
		}
		
		cannon = controller.childNode(withName: "//cannon") as! SKSpriteNode
		
		// Get canvas bounds in scene coordinates
		let canvas = childNode(withName: "//canvas")!
		canvasBounds = CGRect(origin: convert(canvas.frame.origin, from: canvas.parent!), size: canvas.frame.size)
		
		// Parent of all tools
		toolBox = childNode(withName: "toolBox")?.children.first! // Root node of SKReferenceNode
		
		// Bind the camera to local variable
		if let cam = camera {
			cameraNode = cam
		}
		// Bind boundary box to local variable
		bounds = childNode(withName: "bounds") as! SKSpriteNode
		
		// Create physicsworld boundaries
		// Create cgrect with modified origin
		let rect = CGRect(origin: CGPoint(x: -bounds.frame.size.width / 2, y: -bounds.frame.size.height / 2), size: bounds.frame.size)
		bounds.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
		bounds.physicsBody?.categoryBitMask = Category.bounds
		
		// Bind fire node to local variable
		fireNode = cameraNode.childNode(withName: "//fireButton") as! FireButtonNode
		fireNode.controller = controller
		fireNode.cannon = childNode(withName: "//cannon") as! SKSpriteNode
		//Replay button
		replayButton = cameraNode.childNode(withName: "//replayButton") as! ReplayButtonNode
		replayButton.levelController = delegate
		
		backButton = childNode(withName: "//backButton") as! BackButtonNode
		backButton.delegate = delegate
		
		// Bind key to local variable
		key = childNode(withName: "//key") as! KeyNode
		// Allow key to call for reload
		key.levelController = delegate
		
		// Bind lock to local variable
		lock = childNode(withName: "//lock") as! LockNode
	}
	func setupTools() {
		// Create array of tool icons to use later
		enumerateChildNodes(withName: "toolBox//*[Tool]") {node, _ in
			
			if let tool = node as? ToolIcon {
				self.toolIcons[tool.type] = tool
			}
		}
		
		// Get plist
		let plist = Bundle.main.path(forResource: "LevelData", ofType: "plist")!
		let stageDict = NSDictionary(contentsOfFile: plist) as! [String: [String: [String: Int]]]
		let levelDict = stageDict["Stage\(level.stageNumber)"]!
		
		func setupTools(_ level: [String: Int]) {
			// Iterate through all tool icons
			for (type, tool) in toolIcons {
				// Check if value is present
				if let number = level[type.rawValue] {
					// Set tool number
					tool.number = number
				} else {
					// Or zero
					tool.colorBlendFactor = 0.9
					tool.number = 0
				}
			}
		}
		
		// Different names
		if self.level.isSecret, let level = levelDict["LevelS"] {
			setupTools(level)
		} else if self.level.isTutorial, let level = levelDict["LevelTut"] {
			setupTools(level)
		} else if let level = levelDict["Level\(level.number)"] {
			setupTools(level)
		}
	}
	func setupTextures() {
		fanFrames = SKTextureAtlas(named: "FanFrames")
		fanFrames.preload {
			#if DEBUG
				print("loaded textures")
			#endif
		}
	}
	func setupBlocks() {
		// Go through the nodes of the scene to run their setup method
		var nodesToSetup = [NodeSetup]()
		enumerateChildNodes(withName: "//*") { node, _ in
			if let nodeToSetup = node as? NodeSetup {
				nodesToSetup.append(nodeToSetup)
			}
		}
		for node in nodesToSetup {
			node.setup(scene: self)
		}
		
		if isShadowed {
			controller.addLight()
			lock.addLight()
		}
	}
	
	// This is run after the setup methods
	override func didMove(to view: SKView) {
		// Set the defaults value, for the tutorial scene
		//setValueFor(key: .isFirstGameLaunch)
		
		setupCamera(view: view)
		
		// Move camera through scene
		let camSpeed: CGFloat = 500 // Pixels per second (roughly)
		// Get two points
		let point1 = cameraNode.parent!.convert(lock.position, from: lock.parent!)
		let point2 = cameraNode.position
		// Distance between two points
		let d = distance(between: point1, and: point2)
		// Calculate time for camera to move
		let time = TimeInterval(d / camSpeed)
		let move = SKAction.move(to: point2, duration: time)
		move.timingMode = .easeInEaseOut
		cameraNode.position = point1
		cameraNode.run(move, withKey: camMoveKey)
	}
	func setupCamera(view: SKView) {
		let minAspectRatio: CGFloat = 4.0 / 3.0
		
		//Get correct aspect ratio for device
		let aspectRatio: CGFloat
		if iPhone {
			if iPhone4s {
				aspectRatio = 3.0 / 2.0
			} else {
				aspectRatio = 16.0 / 9.0
			}
		} else {
			aspectRatio = minAspectRatio
		}
		
		//Get height of camera
		let cameraHeight = (size.width / aspectRatio)
		
		margin = (size.width / minAspectRatio) - cameraHeight
		
		// Create a range for the camera to be in
		let rangeX: SKRange
		let rangeY: SKRange
		
		// iOS 9 has a bug in which camera position is altered... compensation for now
		if ios9 {
			let scale = view.bounds.size.width / self.size.width
			let scaledHeight = self.size.height * scale
			let scaledOverlap = scaledHeight - view.bounds.size.height
			let overlapAmount = scaledOverlap / scale
			
			// Set position of camera
			camera?.position = CGPoint(x: self.size.width / 2, y: bounds.frame.minY + cameraHeight / 2 - overlapAmount / 2)
			
			// Create range of points in which the camera can go, based on the bounds and size of the screen
			rangeX = SKRange(lowerLimit: bounds.frame.minX + size.width / 2,
			                 upperLimit: bounds.frame.maxX - size.width / 2)
			rangeY = SKRange(lowerLimit: bounds.frame.minY + cameraHeight / 2 - overlapAmount / 2,
			                 upperLimit: bounds.frame.maxY - cameraHeight / 2 - overlapAmount / 2)
		} else {
			// Set position of camera
			camera?.position = CGPoint(x: self.size.width / 2, y:  cameraHeight / 2)
			
			// Create range of points in which the camera can go, based on the bounds and size of the screen
			rangeX = SKRange(lowerLimit: bounds.frame.minX + size.width / 2,
			                 upperLimit: bounds.frame.maxX - size.width / 2)
			rangeY = SKRange(lowerLimit: bounds.frame.minY + cameraHeight / 2,
			                 upperLimit: bounds.frame.maxY - cameraHeight / 2)
		}
		
		// Set interface nodes in case of iphone
		if iPhone {
			if ios9 {
				if iPhone4s {
					fireNode.position.y += 220
				} else {
					replayButton.position.y += 100
					fireNode.position.y += 500
				}
			} else {
				fireNode.position.y += 250
				replayButton.position.y -= 250
				backButton.position.y -= 250
			}
		}
		
		// Set camera constraints
		let cameraConstraint = SKConstraint.positionX(rangeX, y: rangeY)
		cameraNode.constraints = [cameraConstraint]
	}
	
	// MARK: - Moving nodes
	var currentRot: CGFloat = 0
	func moveController(_ location: CGPoint) {
		// Stop camera from moving
		nodeToFollow = nil
		
		let p1 = controller.scenePosition! // Controller position in scene coordinates
		let p2 = lastTouchPoint
		let p3 = location
		
		// Maths to figure out how much rotation to add to controller
		let rot = atan2(p3.y - p1.y, p3.x - p1.x) - atan2(p2.y - p1.y, p2.x - p1.x)
		
		// Make sure that the rotation is an integr
		currentRot += rot.radiansToDegrees()
		if currentRot >= 1 || currentRot <= -1 {
			let newRot = controller.angle + Int(currentRot)
			
			// Clamp the controller to range
			if newRot > 180 {
				controller.angle = 180
			} else if newRot >= 0 {
				// Move controller
				controller.angle += Int(currentRot)
			}
			currentRot = 0
		}
	}
	func moveCamera(to location: CGPoint) {
		camera?.removeAction(forKey: camMoveKey)
		// Get the delta vector
		let vector = lastTouchCam - location
		
		// Add to camera node position
		cameraNode.position += vector
	}
	func moveCamera(with node: SKSpriteNode) {
		guard !isJustFired else {
			return
		}
		// Check if the node is gone
		if node.parent == nil {
			nodeToFollow = nil
			let point = CGPoint(x: size.width / 2, y: size.height / 2)
			let move = SKAction.move(to: point, duration: 1)
			move.timingMode = .easeInEaseOut
			// Wait before camera moves down
			cameraNode.run(SKAction.sequence([SKAction.wait(forDuration: RCValues.sharedInstance.cameraTime), move]), withKey: "cameraMove")
		}
		
		let cameraTarget = node.position
		let camConstant: CGFloat = 0.4 // Idk what this does, it just works
		let targetPosition = CGPoint(x: cameraNode.position.x, y: cameraTarget.y - (view!.bounds.height * camConstant))
		
		let diff = targetPosition - cameraNode.position
		
		// Trial and error
		let lerpValue = CGFloat(RCValues.sharedInstance.cameraLerp)
		let lerpDiff = diff * lerpValue
		let newPosition = cameraNode.position + lerpDiff
		
		cameraNode.position = newPosition
	}
	
	// MARK: - Getting info
	// Function to return correct node, different methods of sorting
	func node(at point: CGPoint) -> SKNode {
		// Check if controller region contains touch location
		let node = atPoint(point)
		
		if controller.region.contains(point) {
			return controller
			
		} else if node is ToolIcon {
			return node
		} else if node is ToolNode {
			return node
		} else if node is KeyNode {
			return key
		} else if node == cannon {
			return node
		}
		
		// Return camera as default
		return cameraNode
	}
	
	// Check if point is in canvas
	func isInCanvas(location: CGPoint) -> Bool {
		// Check is location is inside cnavas
		if location.x < canvasBounds.maxX && location.x > canvasBounds.minX &&
			location.y < canvasBounds.maxY && location.y > canvasBounds.minY{
			return true
		}
		return false
	}
	// MARK: - Loading into gun
	func load(_ key: KeyNode) {
		// If key is animating, don't do anything
		guard !key.animating else {
			return
		}
		if controller.isOccupied {
			fireNode.objectToFire?.disengage(controller)
		}
		
		key.engage(controller) {
			self.fireNode.objectToFire = key
		}
		nodeToFollow = nil
	}
	func unload(_ key: KeyNode) {
		// If key is animating, don't do anything
		guard !key.animating else {
			return
		}
		
		key.disengage(controller)
		fireNode.objectToFire = nil
	}
	
	func load(icon tool: ToolIcon) {
		// Make sure there is a tool to create
		guard tool.number > 0 else {
			return
		}
		
		// If controller is occupied, disengage
		if controller.isOccupied {
			let type = tool.type
			if let tool = fireNode.objectToFire as? ToolNode {
				if tool.type == type {
					return
				}
			}
			fireNode.objectToFire?.disengage(controller)
		}
		
		// Unarchive a brand new tool from file
		let newTool = SKNode(fileNamed: tool.type.rawValue)?.children.first as! ToolNode
		
		// Remove tool from unarchived scene, add it to this one and engage
		newTool.removeFromParent()
		newTool.position = toolBox.convert(tool.position, to: self)
		newTool.zPosition = ZPosition.tools_key
		newTool.icon = tool
		if let bomb = newTool as? BombToolNode {
			bomb.setupFuse(scene: self)
		}
		addChild(newTool)
		newTool.engage(controller) {
			
		}
		
		// Set object to fire to newTool
		fireNode.objectToFire = newTool
		nodeToFollow = nil
	}
	func unLoad(tool: ToolNode, to icon: ToolIcon) {
		guard !tool.animating else {
			return
		}
		
		// If it is enaged and not animating
		if tool.isEngaged {
			tool.disengage(controller)
		}
	}
	
	func die() {
		self.run(soundFX["rumble"]!)
		
		let amplitudeX: CGFloat = 60
		let amplitudeY: CGFloat = 100
		
		let numberOfShakes = 6
		var moveActions = [SKAction]()
		
		for _ in 1...numberOfShakes {
			let moveX = (CGFloat(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX) / 2
			let moveY = (CGFloat(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY) / 2
			
			let shakeAction = SKAction.move(by: CGVector(dx: CGFloat(moveX), dy: CGFloat(moveY)), duration: 0.02)
			shakeAction.timingMode = .easeOut
			moveActions.append(shakeAction)
			moveActions.append(shakeAction.reversed())
		}
		
		let colorise = SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0.3)
		colorise.timingMode = .easeInEaseOut
		
		let decolorise = SKAction.colorize(withColorBlendFactor: 0, duration: 0.3)
		colorise.timingMode = .easeInEaseOut
		
		let coloriseSeq = SKAction.sequence([colorise, decolorise])
		let moveSeq = SKAction.sequence(moveActions)
		
		let group = SKAction.group([coloriseSeq, moveSeq])
		
		cameraNode.run(moveSeq)
		
		enumerateChildNodes(withName: "//background") { background, _ in
			background.run(group)
		}
		enumerateChildNodes(withName: "//canvas") { canvas, _ in
			canvas.run(group)
		}
	}
	func finishedLevel() {
		if level.isSecret {
			levelController.endSecret()
		} else {
			levelController.saveLevels()
			
			// Finished screen
			let finishedLevelNode = SKScene(fileNamed: "FinishedLevel")!.childNode(withName: "finishedLevel") as! SKSpriteNode
			finishedLevelNode.removeFromParent()
			finishedLevelNode.alpha = 0
			
			let finishedLevelNodePosition: CGPoint
			if ios9 {
				finishedLevelNodePosition = CGPoint(x: cameraNode.frame.size.width / 2,
				                                    y: cameraNode.frame.size.height / 2 / 2)
			} else {
				// Center of camera, accomadates iPhone aspect ratio
				finishedLevelNodePosition = CGPoint(x: cameraNode.frame.size.width / 2,
				                                    y: cameraNode.frame.size.height / 2 - margin / 2)
			}
			
			finishedLevelNode.position = finishedLevelNodePosition
			
			cameraNode.addChild(finishedLevelNode)
			
			isFinished = true
			
			let levelButton = finishedLevelNode.childNode(withName: "levelButton") as! LevelSelectButtonNode
			let nextButton = finishedLevelNode.childNode(withName: "nextButton") as! NextLevelButtonNode
			
			// If this is the last level of the last stage
			if level.number == Stages.sharedInstance.stages[level.stageNumber - 1].levels.count &&
				level.stageNumber == Stages.sharedInstance.stages.count {
				nextButton.isHidden = true // Hide next level button
			}
			
			levelButton.delegate = levelController
			nextButton.delegate = levelController
			
			if iPhone {
				levelButton.position.y += 350
				nextButton.position.y += 350
				finishedLevelNode.position.y += 150
			}
			
			finishedLevelNode.run(SKAction.fadeIn(withDuration: 0.5)) { self.isPaused = true }
		}
	}
	
	// MARK: - Touch Events
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard !isFinished else {
			return
		}
		
		for touch in touches {
			cameraNode.removeAction(forKey: camMoveKey)
			nodeToFollow = nil
			
			// Get location of touch in different coordinate systems
			let location = touch.location(in: self)
			let locationCam = touch.location(in: cameraNode)
			
			currentNode = node(at: location)
			
			if let toolIcon = currentNode as? ToolIcon {
				toolIcon.greyOut()
			} else if currentNode == key {
				key.greyOut()
			}
			
			// Set local variables
			lastTouchPoint = location
			lastTouchCam = locationCam
		}
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard !isFinished else {
			return
		}
		for touch in touches {
			// Get location of touch in different coordinate systems
			let location = touch.location(in: self)
			let locationCam = touch.location(in: cameraNode)
			
			if currentNode == controller && isInCanvas(location: location) {
				moveController(location)
			} else if currentNode == cameraNode{
				moveCamera(to: locationCam)
			}
			
			// Set local variables
			lastTouchPoint = location
			lastTouchCam = locationCam
		}
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard !isFinished else {
			return
		}
		for _ in touches {
			
			if let toolIcon = currentNode as? ToolIcon {
				load(icon: toolIcon)
				toolIcon.greyOut()
			} else if cannon == currentNode {
				// Check currently load object, unload
				if let toolNode = fireNode.objectToFire as? ToolNode {
					unLoad(tool: toolNode, to: toolIcons[toolNode.type]!)
				} else if let key = fireNode.objectToFire as? KeyNode {
					unload(key)
				}
			} else if let key = currentNode as? KeyNode{
				load(key)
				key.greyOut()
			}
			
			currentNode = nil
		}
	}
	
	// MARK: - Update
	override func update(_ currentTime: TimeInterval) {
		if let node = nodeToFollow {
			moveCamera(with: node)
		}
		#if DEBUG
			if cheat {
				// Debug, key is invincable
				key.physicsBody?.collisionBitMask = 0
				key.physicsBody?.contactTestBitMask = Category.lock
				key.physicsBody?.fieldBitMask = 0
			}
		#endif
		
		// Iterate through the fans, update fields and particles
		for fan in fans {
			if fan.isMoving || fan.physicsBody!.isDynamic {
				let rot = rotationRelativeToSceneFor(node: fan)
				fan.updateFields(rotation: rot)
			}
		}
	}
}
