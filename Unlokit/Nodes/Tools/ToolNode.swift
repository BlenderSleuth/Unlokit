//
//  ToolNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 13/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

enum ToolType {
    case Time
    case Wave
    case Light
    case Sticky
}

// Only use this for subclassing...
class ToolNode: SKSpriteNode {
    
    var type: ToolType!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        //physicsBody?.isDynamic = false
    }
    
}
