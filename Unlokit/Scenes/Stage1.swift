//
//  Stage1.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import SpriteKit
struct Category {
	static let zero: UInt32				= 0b0
	
	static let key: UInt32				= 0b1
	static let lock: UInt32				= 0b1 << 1
	static let bounds: UInt32			= 0b1 << 2
	
	static let blockMtl: UInt32			= 0b1 << 3
	static let blockBnc: UInt32			= 0b1 << 4
	static let blockGlue: UInt32		= 0b1 << 5
	
	static let blockBreak: UInt32		= 0b1 << 6
	static let blockBreakBnc: UInt32	= 0b1 << 7
	static let blockBreakGlue: UInt32	= 0b1 << 8
	static let blockBreakable: UInt32	= Category.blockBreak | Category.blockBreakBnc | Category.blockBreakGlue
	
	static let blocks: UInt32 = Category.blockMtl | Category.blockBnc | Category.blockGlue | Category.blockBreak
	
	static let springTool: UInt32		= 0b1 << 9
	static let glueTool: UInt32			= 0b1 << 10
	static let fanTool: UInt32			= 0b1 << 11
	static let gravityTool: UInt32		= 0b1 << 12
	static let bombTool: UInt32			= 0b1 << 13
	static let tools: UInt32 = Category.springTool | Category.glueTool | Category.fanTool | Category.gravityTool | Category.bombTool
	
	static let fanGravityField: UInt32	= 0b1 << 14
	static let fanDragField: UInt32		= 0b1 << 15
	static let fields: UInt32			= Category.fanGravityField | Category.fanDragField
	
	static let fan: UInt32				= 0b1 << 16
	
	static let speed: UInt32			= 0b1 << 17
	static let secretTeleport: UInt32	= 0b1 << 18
	
	static let all: UInt32 = UInt32.max
}

struct ZPosition {
	static let background: CGFloat	= 0
	static let tools: CGFloat		= 40
	static let toolIcons: CGFloat	= 45
	static let levelNodes: CGFloat	= 50
	static let key: CGFloat			= 60
	static let canon				= 70
	static let activeItem: CGFloat	= 80
	static let interface: CGFloat	= 100
}

protocol start {
	func startNewGame()
}

class Stage1: SKScene, Reload {
    
    //MARK: Variables
	var levelNumber = 1
	
	// Node references
    var controller: ControllerNode!
    
    var fireNode: FireButtonNode!
	var replayNode: ReplayButtonNode!
	var backButton: BackButtonNode!
	var canon: SKSpriteNode!
    var cameraNode: SKCameraNode!
    var bounds: SKSpriteNode!
    
    var canvasBounds: CGRect!
    
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
	
	var start: start!
	
	// Audio
	let soundFX = SoundFX.sharedInstance
	
	// For camera following
	var nodeToFollow: SKSpriteNode?
	
	// Preloading textures
	var fanFrames: SKTextureAtlas!
	
	// Dict of fans
	var fans = [FanNode]()
	
	//MARK: Setup
    override func didMove(to view: SKView) {
    }
	
	override func willMove(from view: SKView) {
		soundFX.pauseBackgroundMusic()
	}
	
	func setupNodes(vc: GameViewController) {
		// Bind controller to local variable
		controller = childNode(withName: "//controller") as! ControllerNode
		controller.setupRegion(scene: self) // Pass in scene for controller to use
		
		canon = controller.childNode(withName: "//canon") as! SKSpriteNode
		
		// Get canvas bounds in scene coordinates
		let canvas = childNode(withName: "//canvas")!
		canvasBounds = CGRect(origin: convert(canvas.frame.origin, from: canvas.parent!), size: canvas.frame.size)
		
		// parent of all tools
		toolBox = childNode(withName: "toolBox")?.children.first! // Root node of SKReferenceNode
		
		//Bind the camera to local variable
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
		fireNode.canon = childNode(withName: "//canon") as! SKSpriteNode
		replayNode = cameraNode.childNode(withName: "//replayButton") as! ReplayButtonNode
		replayNode.reloadable = self
		
		backButton = childNode(withName: "//backButton") as! BackButtonNode
		backButton.vc = vc
		
		// Bind key to local variable
		key = childNode(withName: "//key") as! KeyNode
		// Allow key to call for reload
		key.reloadable = self
		
		// Bind lock to local variable
		lock = childNode(withName: "//lock") as! LockNode
		lock.setupPhysics()
	}
	func setupCamera() {
		//Get correct aspect ratio for device
		let aspectRatio: CGFloat
		if iPhone {
			aspectRatio = 16.0 / 9.0
		} else {
			aspectRatio = 4.0 / 3.0
		}
		
		//Get height of camera
		let height = (size.width / aspectRatio)
		
		// Create a range for the camera to be in
		let rangeX: SKRange
		let rangeY: SKRange
		
		// iOS 9 has a bug in which camera position is altered... compensation for now
		if ios9 {
			func overlapAmount() -> CGFloat {
				guard let view = self.view else {
					return 0
				}
				let scale = view.bounds.size.width / self.size.width
				let scaledHeight = self.size.height * scale
				let scaledOverlap = scaledHeight - view.bounds.size.height
				return scaledOverlap / scale
			}
			
			// Set position of camera
			camera?.position = CGPoint(x: self.size.width / 2, y: bounds.frame.minY + height / 2 - overlapAmount() / 2)
			
			// Create range of points in which the camera can go, based on the bounds and size of the screen
			rangeX = SKRange(lowerLimit: bounds.frame.minX + size.width / 2,
			                 upperLimit: bounds.frame.maxX - size.width / 2)
			rangeY = SKRange(lowerLimit: bounds.frame.minY + height / 2 - overlapAmount() / 2,
			                 upperLimit: bounds.frame.maxY - height / 2 - overlapAmount() / 2)
		} else {
			// Set position of camera
			camera?.position = CGPoint(x: self.size.width / 2, y:  height / 2)
			
			// Create range of points in which the camera can go, based on the bounds and size of the screen
			rangeX = SKRange(lowerLimit: bounds.frame.minX + size.width / 2,
			                 upperLimit: bounds.frame.maxX - size.width / 2)
			rangeY = SKRange(lowerLimit: bounds.frame.minY + height / 2,
			                 upperLimit: bounds.frame.maxY - height / 2)
		}
		
		// Set interface nodes in case of iphone
		if iPhone {
			fireNode.position.y  += 250
			replayNode.position.y -= 250
			backButton.position.y -= 250
		}
		
		// Set camera constraints
		let cameraConstraint = SKConstraint.positionX(rangeX, y: rangeY)
		cameraNode.constraints = [cameraConstraint]
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
		let levelDict = stageDict["Stage1"]!
		
		let level = levelDict["Level\(levelNumber)"]!
		
		// Iterate through all tool icons
		for (type, tool) in toolIcons {
			// Check if value is present
			if let number = level[type.rawValue] {
				// Set tool number
				tool.number = number
			} else {
				// Or zero
				tool.number = 0
			}
			
		}
	}
	func setupTextures() {
		fanFrames = SKTextureAtlas(named: "FanFrames")
		fanFrames.preload {
			print("loaded textures")
		}
	}
	func setupBlocks() {
		// Edit blocks outside of enumeration to prevent crash
		var blocks = [BlockGlueNode]()
		
		enumerateChildNodes(withName: "//blockGlue") { node, _ in
			let block = node as! BlockGlueNode
			blocks.append(block)
		}
		for block in blocks {
			block.checkConnected(scene: self)
		}
	}
	
    func moveController(_ location: CGPoint) {
        let p1 = controller.scenePosition! // Controller position in scene coordinates
        let p2 = lastTouchPoint
        let p3 = location
		
        // Maths to figure out how much rotation to add to controller
        let rot = atan2(p3.y - p1.y, p3.x - p1.x) - atan2(p2.y - p1.y, p2.x - p1.x)
		
        // Rotate controller, clamp zRotation
        let newRot = CGFloat(Int(controller.zRotation + rot + 0.5))
		
		// Bit of room for label to display correctly
        if !(newRot <= CGFloat(-91).degreesToRadians() || newRot >= CGFloat(90).degreesToRadians()) {
			// Round rotation
            controller.zRotation += rot
        }
    }
    func moveCamera(to location: CGPoint) {
		camera?.removeAction(forKey: "cameraMove")
        // Get the delta vector
        let vector = lastTouchCam - location
        
        // Add to camera node position
        cameraNode.position += vector
    }
	func moveCamera(with node: SKSpriteNode) {
		// Check if the node is gone
		if node.parent == nil {
			nodeToFollow = nil
			let point = CGPoint(x: size.width / 2, y: size.height / 2)
			let move = SKAction.move(to: point, duration: 1)
			move.timingMode = .easeInEaseOut
			cameraNode.run(SKAction.sequence([SKAction.wait(forDuration: 2), move]), withKey: "cameraMove")
		}
		
		// TO DO: lerp more
		let cameraTarget = node.position
		let targetPosition = CGPoint(x: cameraNode.position.x, y: cameraTarget.y - (scene!.view!.bounds.height * 0.4))
		
		let diff = targetPosition - cameraNode.position
		
		let lerpValue: CGFloat = 0.2
		let lerpDiff = diff * lerpValue
		let newPosition = cameraNode.position + lerpDiff
		
		cameraNode.position = newPosition
	}
	
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
		} else if node == canon {
			return node
		}
		
		// Return camera as default
		return cameraNode
    }
	
	func isInCanvas(location: CGPoint) -> Bool {
		// Check is location is inside cnavas
		if location.x < canvasBounds.maxX && location.x > canvasBounds.minX &&
			location.y < canvasBounds.maxY && location.y > canvasBounds.minY{
			return true
		}
		return false
	}
	
	func load(_ key: KeyNode) {
		// If key is animating, don't do anything
		guard !key.animating else {
			return
		}
		if controller.isOccupied {
			fireNode.objectToFire?.disengage(controller)
		}
		
		key.engage(controller)
		fireNode.objectToFire = key
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
		
		// Unarchive a tool from file
		let newTool = SKNode(fileNamed: tool.type.rawValue)?.children.first as! ToolNode
		//let newTool = toolNodesRef[tool.type]?.copy() as! ToolNode

		// Remove tool from unarchived scene, add it to this one and engage
		newTool.removeFromParent()
		newTool.position = toolBox.convert(tool.position, to: self)
		newTool.zPosition = ZPosition.tools
		newTool.icon = tool
		if let bomb = newTool as? BombToolNode {
			bomb.setupFuse(scene: self)
		}
		addChild(newTool)
		newTool.engage(controller)
		
		// Set object to fire to newTool
		fireNode.objectToFire = newTool
		
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
	
	func reload() {
		if start != nil {
			start.startNewGame()
		}
	}
	func endGame() {
		
	}
	
    //MARK: Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
			
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
        for _ in touches {
			
			if let toolIcon = currentNode as? ToolIcon {
				load(icon: toolIcon)
				toolIcon.greyOut()
			} else if canon == currentNode {
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
	
	override func update(_ currentTime: TimeInterval) {
		if let node = nodeToFollow {
			moveCamera(with: node)
		}
		controller.updateAngle()
		
		for fan in fans {
			if fan.isMoving {
				let rot = fan.rotationRelativeToSceneFor(node: fan)
				fan.updateFields(rotation: rot)
			}
		}
	}
}
