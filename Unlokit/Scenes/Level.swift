//
//  Level.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import SpriteKit
struct Category {
	static let zero: UInt32			= 0b0
	
	static let key: UInt32			= 0b1
	static let lock: UInt32			= 0b10
	static let controller: UInt32	= 0b100
	static let blockMtl: UInt32     = 0b1000
	static let blockBnc: UInt32     = 0b10000
	
	static let blocks: UInt32		= 0b11000
	
	static let bounds: UInt32		= 0b100000
	
	static let glueTool: UInt32     = 0b1000000
	static let springTool: UInt32   = 0b10000000
	
	static let all: UInt32 = UInt32.max
}

struct ZPosition {
	static let background: CGFloat	= 0
	static let levelNodes: CGFloat	= 20
	static let tools: CGFloat		= 40
	static let key: CGFloat			= 50
	static let controller			= 60
	static let activeItem: CGFloat	= 80
	static let interface: CGFloat	= 100
}

protocol start {
	func startNewGame()
}

class Level: SKScene, Reload {
    
    //MARK: Variables
    var controller: ControllerNode!
    
    var fireNode: FireButtonNode!
	var replayNode: ReplayButtonNode!
    
    var gun: SKNode!
    var cameraNode: SKCameraNode!
    var bounds: SKSpriteNode!
	
	// Universal constraint for tools and key
	var canvasConstraint: SKConstraint!
    
    var canvasBounds: CGRect!
    
    // Array of tools
	var toolBox: SKNode!
    var toolIcons = [ToolIcon]()
	var toolNodes = [ToolNode]()
	
	// Key
	var key: KeyNode!
	var lock: LockNode!
    
    // Touch points in different coordinate systems
	var lastTouchPoint = CGPoint.zero
    var lastTouchCam = CGPoint.zero
	
	// zPosition management
	var currentNode: SKNode? {
		didSet {
			guard !(currentNode is ToolIcon) else {
				return
			}
			currentNode?.zPosition = ZPosition.activeItem
		}
		willSet {
			switch currentNode {
			case is KeyNode:
				currentNode?.zPosition = ZPosition.key
			default:
				currentNode?.zPosition = ZPosition.tools
			}
		}
	}
		
    // Time intervals
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
	
	var start: start!
	
	//MARK: Setup
    override func didMove(to view: SKView) {
		setupNodes()
		setupCamera()
        setupTools()
		physicsWorld.contactDelegate = self
    }
	func setupNodes() {
		// Bind controller to local variable
		controller = childNode(withName: "controller") as! ControllerNode
		controller.setupPhysics()
		
		canvasBounds = childNode(withName: "canvas")?.frame
		
		// Bind gun to local variable
		gun = controller.childNode(withName: "gun")!.children.first
		
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
		fireNode = cameraNode.childNode(withName: "fireButton") as! FireButtonNode
		replayNode = cameraNode.childNode(withName: "replayButton") as! ReplayButtonNode
		replayNode.reloadable = self
		
		// Bind key to local variable
		key = childNode(withName: "key") as! KeyNode
		key.setupPhysics()
		// Allow key to call for reload
		key.reloadable = self
		
		// Create constraint to keep in canvas
		let canvasX = SKRange(lowerLimit: 0, upperLimit: canvasBounds.width)
		let canvasY = SKRange(lowerLimit: 0, upperLimit: canvasBounds.height)
		canvasConstraint = SKConstraint.positionX(canvasX, y: canvasY)
		
		// Stop key from entering controller (yet...)
		let outsideController = SKRange(lowerLimit: controller.size.width / 2) // Outside radius of controller
		let controllerConstraint = SKConstraint.distance(outsideController, to: controller)
		
		// Apply constraints to key, save for later
		key.constraints = [canvasConstraint, controllerConstraint]
		key.saveContraints()
		
		// Bind lock to local variable
		lock = childNode(withName: "lock") as! LockNode
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
		
		// Set interface nodes incase of iphone
		if iPhone {
			fireNode.position.y  += 250
			replayNode.position.y -= 250
		}
		
		// Set camera constraints
		let cameraConstraint = SKConstraint.positionX(rangeX, y: rangeY)
		cameraNode.constraints = [cameraConstraint]
	}
	func setupTools() {
		// Create array of tool icons to use later
		enumerateChildNodes(withName: "toolBox//*[Tool]") {node, _ in
			
			if let tool = node as? ToolIcon {
				self.toolIcons.append(tool)
			}
		}
		
		setupToolsForLevel()
	}
	func setupToolsForLevel() {
		// To be overridden
	}
	
    func handleTouchController(_ location: CGPoint) {
        let p1 = controller.position
        let p2 = lastTouchPoint
        let p3 = location
		
        // Maths to figure out how much rotation to add to controller
        let rot = atan2(p3.y - p1.y, p3.x - p1.x) - atan2(p2.y - p1.y, p2.x - p1.x)
		
        // Rotate controller, clamp zRotation
        let newRot = controller.zRotation + rot
        if !(newRot <= CGFloat(-90).degreesToRadians() || newRot >= CGFloat(90).degreesToRadians()) {
            controller.zRotation += rot
        }
        
        // Give fireNode the angle for the bullets
        fireNode.angle = Float(newRot) + Float(90).degreesToRadians()
    }
    
    func moveCamera(to location: CGPoint) {
        // Get the delta vector
        let vector = lastTouchCam - location
        
        // Add to camera node position
        cameraNode.position += vector
    }
	
	func move(key: KeyNode, to location: CGPoint) {
		// If key is fired, don't do anything
		guard !key.isFired else {
			return
		}
		
		//make sure key isn't animating position
		guard !key.isEngaging || !key.isDisengaging else {
			if key.isDisengaging {
				//key.run(SKAction.move(to: location, duration: 0.2), withKey: "disengaging") {
				//	key.isEngaged = false
				//}
			}
			
			return
		}
		
		if !key.isEngaged {
			// Check if user touched centre of controller
			if controller.middleRegion.contains(location) {
				// Animate to centre
				key.isEngaged = true
				key.inside = true
				key.run(SKAction.move(to: controller.position, duration: 0.2), withKey: "engaging") {
					self.fireNode.objectToFire = key
				}
			} else {
				key.position = location
			}
			
		} else {
			// Check if user touched outside of controller
			if !controller.combinedRegion.contains(location) && key.inside {
				// Animate outside
				fireNode.objectToFire = nil
				key.inside = false
				key.run(SKAction.move(to: location, duration: 0.2), withKey: "disengaging") {
					key.isEngaged = false
					key.position = location
				}
			}
		}

	}
	
	// Function to return correct node, different methods of sorting
    func node(at point: CGPoint) -> SKNode {
        // Check if controller region contains touch location
		let node = atPoint(point)
		
        if controller.region.contains(point) {
            return controller
        } else if node is ToolIcon {
			// Point to check for tools
			return node
		} else if node is ToolNode {
			return node
		} else if node is KeyNode {
			return key
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
	
	func createToolWith(icon tool: ToolIcon) {
		// Make sure there is a tool to create
		guard tool.number > 0 else {
			return
		}
		
		tool.number -= 1
		
		// Unarchive a tool from file
		let newTool = SKNode(fileNamed: tool.type.rawValue)?.children.first as! ToolNode

		// Remove tool from unarchived scene, add it to this one
		newTool.removeFromParent()
		newTool.position = toolBox.convert(tool.position, to: self)
		
		newTool.constraints = [canvasConstraint]
		addChild(newTool)
		newTool.zPosition = ZPosition.tools
	}
	func move(tool: ToolNode, to position: CGPoint) {
		tool.position = position
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
				createToolWith(icon: toolIcon)
			} else if let toolNode = currentNode as? ToolNode {
				move(tool: toolNode, to: location)
			} else if currentNode == key {
				move(key: key, to: location)
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
			
			currentNode = node(at: location)
			
			if currentNode == controller && isInCanvas(location: location) {
				handleTouchController(location)
			} else if let toolIcon = currentNode as? ToolIcon {
				createToolWith(icon: toolIcon)
			} else if let toolNode = currentNode as? ToolNode {
				move(tool: toolNode, to: location)
			} else if currentNode == cameraNode{
				moveCamera(to: locationCam)
			} else if currentNode == key {
				move(key: key, to: location)
			}
            
            // Set local variables
            lastTouchPoint = location
			lastTouchCam = locationCam
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            
            // Get location in two different coordinate systems
            //let location = touch.location(in: self)
            //let locationCam = touch.location(in: cameraNode)
            
            //Handle for for different nodes
            currentNode = nil
            
            // Set local variables
            //lastTouchPoint = location
            //lastTouchCam = locationCam
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            
            // Get location in two different coordinate systems
            //let location = touch.location(in: self)
            //let locationCam = touch.location(in: cameraNode)
            
            //Handle for for different nodes
            currentNode = nil
            
            // Set local variables
            //lastTouchPoint = location
            //lastTouchCam = locationCam
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        } else {
            dt = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
    }
}
