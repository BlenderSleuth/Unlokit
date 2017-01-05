//
//  GameScene.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import SpriteKit
import UIKit

enum Category: UInt32 {
    case key1 = 0b1
    
    case blockStd       = 0b10
    case blockBreakable = 0b100
    case blockNonStick  = 0b1000
    case blockStick     = 0b10000
    case blockFlammable = 0b100000
}

enum NodeType {
    case Controller
    case Camera
}

class GameScene: SKScene {
    
    //MARK: Variables
    var controller: SKSpriteNode!
    var controllerRegion: SKRegion!
    
    var gun: SKNode!
    var cameraNode: SKCameraNode!
    var bounds: SKSpriteNode!
    
    var lastTouchPoint = CGPoint.zero
    var lastTouchCam = CGPoint.zero
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        // Bind controller to local variable
        controller = childNode(withName: "controller") as! SKSpriteNode
        
        // Create patch for an SKRegion to detect touches in circle, rather than square
        let regionRect = CGRect(origin: controller.frame.origin - 50, size: controller.frame.size + 100)
        
        let path = CGPath(ellipseIn: regionRect, transform: nil)
        controllerRegion = SKRegion(path: path)
        
        let debugPath = SKShapeNode(path: path)
        debugPath.strokeColor = .blue
        debugPath.lineWidth = 5
        addChild(debugPath)
        
        // Bind gun to local variable
        gun = controller.childNode(withName: "gun")!.children.first
        
        //Bind the camera to local variable
        if let cam = camera {
            cameraNode = cam
        }
        
        // Bind boundary box to local variable
        bounds = childNode(withName: "bounds") as! SKSpriteNode
        
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
            rangeX = SKRange(lowerLimit: bounds.frame.minX + size.width / 2, upperLimit: bounds.frame.maxX - size.width / 2)
            rangeY = SKRange(lowerLimit: bounds.frame.minY + height / 2 - overlapAmount() / 2, upperLimit: bounds.frame.maxY - height / 2 - overlapAmount() / 2)
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
    }
    
    func handleTouchController(location: CGPoint) {
        
        // Check if touch was on the controller
        if controller == self.atPoint(location) {
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
        }
    }
    
    func moveCamera(location: CGPoint) {
        // Get the delta vector
        let vector = lastTouchCam - location
        
        // Add to camera node position
        cameraNode.position += vector
    }
    
    func nodeTypeAt(location: CGPoint) -> NodeType {
        let type: NodeType
        
        // Check if controller region contains touch location
        if controllerRegion.contains(location) {
            type = .Controller
        } else {
            // Switch for other types of nodes
            switch atPoint(location) {
            default:
                type = .Camera
            }
        }
        
        return type
    }
    
    //MARK: Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            // Get location in two different coordinate systems
            let location = touch.location(in: self)
            let locationCam = touch.location(in: cameraNode)
            
            // Set local variables
            lastTouchPoint = location
            lastTouchCam = locationCam
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            // Get location in two different coordinate systems
            let location = touch.location(in: self)
            let locationCam = touch.location(in: cameraNode)
            
            //Handle for for different nodes
            switch nodeTypeAt(location: location) {
            case .Controller:
                handleTouchController(location: location)
            case .Camera:
                moveCamera(location: locationCam)

            }
            
            // Set local variables
            lastTouchPoint = location
            lastTouchCam = locationCam
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            // Get location in two different coordinate systems
            let location = touch.location(in: self)
            let locationCam = touch.location(in: cameraNode)
            
            //Handle for for different nodes
            switch nodeTypeAt(location: location) {
            case .Controller:
                handleTouchController(location: location)
            case .Camera:
                moveCamera(location: locationCam)
                
            }
            
            // Set local variables
            lastTouchPoint = location
            lastTouchCam = locationCam
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            // Get location in two different coordinate systems
            let location = touch.location(in: self)
            let locationCam = touch.location(in: cameraNode)
            
            //Handle for for different nodes
            switch nodeTypeAt(location: location) {
            case .Controller:
                handleTouchController(location: location)
            case .Camera:
                moveCamera(location: locationCam)
                
            }
            
            // Set local variables
            lastTouchPoint = location
            lastTouchCam = locationCam
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
