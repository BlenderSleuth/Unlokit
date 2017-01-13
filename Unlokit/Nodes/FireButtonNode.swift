//
//  FireButtonNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 11/01/2017.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

protocol ButtonDelegate {
    func pressed()
}

class FireButtonNode: SKNode {
    
    let label: SKLabelNode
    let redCircle: SKShapeNode
    let blueCircle: SKShapeNode
    
    var pressed = false
    
    let bulletTemp: SKSpriteNode
    
    var angle: Float = Float(π/2)
    
    var bulletColours: [UIColor] = [.orange, .purple, .green, .blue, .red, .yellow, .white, .black, .brown, .darkGray]
    
    init(size: CGSize, position: CGPoint) {
        
        redCircle = SKShapeNode(circleOfRadius: size.width / 2)
        redCircle.fillColor = .red
        redCircle.strokeColor = .red
        
        blueCircle = SKShapeNode(circleOfRadius: size.width / 2)
        blueCircle.fillColor = .blue
        blueCircle.strokeColor = .blue
        blueCircle.isHidden = true
        
        label = SKLabelNode(text: "Fire!")
        label.position = CGPoint(x: 0, y: -30)
        label.fontName = "Helvetica Neue Thin"
        label.fontSize = 100
        label.zPosition = 10
        
        bulletTemp = SKSpriteNode(color: .purple, size: size / 4)
        bulletTemp.physicsBody = SKPhysicsBody(rectangleOf: size / 4)
        bulletTemp.position = position
        
        super.init()
        self.position = position
        
        addChild(redCircle)
        addChild(blueCircle)
        addChild(label)
        
        isUserInteractionEnabled = true
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
    }
    
    //used if initialising from file
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func press() {
        pressed = !pressed
        redCircle.isHidden = pressed
        blueCircle.isHidden = !pressed
    }
    
    private func fire(radians angle: Float) {
        
        let speed: CGFloat = 750
        
        let bullet = bulletTemp.copy() as! SKSpriteNode
        bullet.color = bulletColours[Int(arc4random_uniform(9))]
        bullet.zRotation = CGFloat(angle)
        
        let dx = CGFloat(cosf(angle)) * speed
        let dy = CGFloat(sinf(angle)) * speed
        
        scene?.addChild(bullet)
        
        bullet.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
        fire(radians: angle)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        press()
    }
}
