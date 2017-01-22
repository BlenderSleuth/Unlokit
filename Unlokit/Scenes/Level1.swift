//
//  GameScene.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import SpriteKit
import UIKit

struct Category {
	static let key1: UInt32			= 0b1
	static let key2: UInt32			= 0b10
	static let key3: UInt32			= 0b100
	static let lock1: UInt32		= 0b1000
	static let lock2: UInt32		= 0b10000
	static let lock3: UInt32		= 0b100000
	static let controller: UInt32	= 0b1000000
	
	//static let blockStd: UInt32       = 0b10
	//static let blockBreakable: UInt32 = 0b100
	//static let blockNonStick: UInt32  = 0b1000
	//static let blockStick: UInt32     = 0b10000
	//static let blockFlammable: UInt32 = 0b100000
}

class Level1: SKScene {
    
    //MARK: Variables
    var controller: ControllerNode!
    
    var fireNode: FireButtonNode!
    
    var gun: SKNode!
    var cameraNode: SKCameraNode!
    var bounds: SKSpriteNode!
    
    var canvasBounds: CGRect!
    
    // Components for key
    var components = [ComponentNode]()
	
	// Key
	var key: KeyNode!
    
    // Touch points in different coordinate systems
	var lastTouchPoint = CGPoint.zero
    var lastTouchCam = CGPoint.zero
    
    var currentNode: SKNode!
    
    // Time intervals
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
	
	//MARK: Setup
    override func didMove(to view: SKView) {
		setupNodes()
		setupCamera()
        setupComponents()
    }
	func setupNodes() {
		// Bind controller to local variable
		controller = childNode(withName: "controller") as! ControllerNode
		controller.setupPhysics()
		
		canvasBounds = childNode(withName: "canvas")?.frame
		
		// Bind gun to local variable
		gun = controller.childNode(withName: "gun")!.children.first
		
		//Bind the camera to local variable
		if let cam = camera {
			cameraNode = cam
		}
		
		// Bind boundary box to local variable
		bounds = childNode(withName: "bounds") as! SKSpriteNode
		
		// Bind fire node to local variable
		fireNode = childNode(withName: "fireButton") as! FireButtonNode
		
		// Bind key to local variable
		key = childNode(withName: "key") as! KeyNode
		key.setupPhysics()
		
		// Keep key in canvas
		let canvasX = SKRange(lowerLimit: 0, upperLimit: canvasBounds.width)
		let canvasY = SKRange(lowerLimit: 0, upperLimit: canvasBounds.height)
		let canvasConstraint = SKConstraint.positionX(canvasX, y: canvasY)
		
		// Stop key from entering controller (yet...)
		let outsideController = SKRange(lowerLimit: controller.size.width / 2) // Outside radius of controller
		let controllerConstraint = SKConstraint.distance(outsideController, to: controller)
			
		key.constraints = [canvasConstraint, controllerConstraint]
		key.saveContraints()
	}
	
	func setupCamera() {
		//Get correct aspect ratio for device
		let aspectRatio: CGFloat
		if UIDevice.current.model == "iPhone" {
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
			rangeX = SKRange(lowerLimit: bounds.frame.minX + size.width / 2, upperLimit: bounds.frame.maxX - size.width / 2)
			rangeY = SKRange(lowerLimit: bounds.frame.minY + height / 2, upperLimit: bounds.frame.maxY - height / 2)
		}
		
		// Set camera constraints
		let cameraConstraint = SKConstraint.positionX(rangeX, y: rangeY)
		cameraNode.constraints = [cameraConstraint]
		
		// Create physicsworld boundaries
		// Create cgrect with modified origin
		let rect = CGRect(origin: CGPoint(x: -bounds.frame.size.width / 2, y: -bounds.frame.size.height / 2), size: bounds.frame.size)
		bounds.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
	}
	func setupComponents() {
		// Create array of components to use later
		for child in children {
			if let component = child as? ComponentNode {
				components.append(component)
			}
		}
		
		// Constraint so that componets never move outside of canvas
		let rangeX = SKRange(lowerLimit: 0, upperLimit: canvasBounds.width)
		let rangeY = SKRange(lowerLimit: 0, upperLimit: canvasBounds.height)
		let canvasConstraint = SKConstraint.positionX(rangeX, y: rangeY)
		
		// Apple constraint to all components
		for component in components {
			component.constraints = [canvasConstraint]
		}
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
    
    func moveCamera(_ location: CGPoint) {
        // Get the delta vector
        let vector = lastTouchCam - location
        
        // Add to camera node position
        cameraNode.position += vector
    }
	
	func moveKey(_ key: KeyNode, location: CGPoint) {
		//make sure key isn't animating position
		guard !key.isEngaging else {
			return
		}
		
		if !key.isEngaged {
			key.position = location
			
			// Check if user touched centre of controller
			if controller.middleRegion.contains(location) {
				// Animate to centre
				key.isEngaged = true
				key.run(SKAction.move(to: controller.position, duration: 1), withKey: "engaging")
			}
		} else {
			// Check if user touched outside of controller
			if !controller.region.contains(location) {
				// Animate outside
				key.run(SKAction.move(to: location, duration: 1), withKey: "disengaging") {
					key.isEngaged = false
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
        } else if node is ComponentNode {
            // Check components
			for component in components {
				if component.position == point {
					return component
				}
			}
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
	
	func createComponent(type: ComponentType) {
		
	}
    
    //MARK: Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            // Get location of touch in different coordinate systems
            let location = touch.location(in: self)
			let locationCam = touch.location(in: cameraNode)
            
            // Set local variables
            lastTouchPoint = location
			lastTouchCam = locationCam
            
			currentNode = node(at: lastTouchPoint)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            // Get location of touch in different coordinate systems
            let location = touch.location(in: self)
			let locationCam = touch.location(in: cameraNode)
			
			if currentNode == controller && isInCanvas(location: location) {
				handleTouchController(location)
			} else if let component = currentNode as? ComponentNode {
				createComponent(type: component.type)
			} else if currentNode == cameraNode{
				moveCamera(locationCam)
			} else if currentNode == key {
				moveKey(key, location: location)
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
