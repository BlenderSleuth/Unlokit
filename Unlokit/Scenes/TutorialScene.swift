//
//  TutorialScene.swift
//  Unlokit
//
//  Created by Ben Sutherland on 5/5/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit
import UIKit

class TutorialScene: GameScene {
	
	var current: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        startTutorial()
    }
    
    func startTutorial() {
        current = HelpNode(circlePosition: convert(key.position, from: key.parent!),
                               size: self.size)
		
		key.zPosition = 210
        current.zPosition = 200
		current.position = CGPoint(x: 0, y: 0)
        addChild(current)
		
        /*
        let current = SKShapeNode(circleOfRadius: 200)
        current.strokeColor = .black
        current.fillColor = .black
        current.zPosition = 150
        
        let texture = view!.texture(from: current)!
        
        let invertedTexture = invertTexture(texture)
        let tutorialNode = SKSpriteNode(texture: invertedTexture)
        
        tutorialNode.size = self.size
        cameraNode.addChild(tutorialNode)
        
        //let cover = SKSpriteNode(texture: nil, color: .darkGray, size: self.size)
        //cover.alpha = 0.8
        
        //let cropNode = SKCropNode()
        //cropNode.maskNode = current
        //cropNode.addChild(cover)
        //cropNode.zPosition = 150
        
        let selectKey = SKShapeNode(circleOfRadius: key.size.width / 2 + 25)
        selectKey.position = convert(key.position, from: key.parent!)
        selectKey.fillColor = .darkGray
        selectKey.strokeColor = .green
        selectKey.lineWidth = 3
        selectKey.alpha = 0.6
        addChild(selectKey)
 */
    }
	
	func goNext(to node: SKSpriteNode, text: String) {
		let fadeOut = SKAction.sequence([SKAction.fadeOut(withDuration: 0.2),
		                              SKAction.removeFromParent()])
		current.run(fadeOut)
		
		current = HelpNode(circlePosition: convert(node.position, from: node.parent!),
		                   size: self.size)
		addChild(current)
		
		let fadeIn = SKAction.fadeIn(withDuration: 0.2)
		current.run(fadeIn)
	}
	
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}

class HelpNode: SKSpriteNode {
    
    
    init(circlePosition: CGPoint, size: CGSize) {
        let texture = generateTextureWithHole(size: size,
                                              radius: 200,
                                              position: circlePosition,
                                              backgroundColour: .purple)
        
        super.init(texture: texture, color: .clear, size: size)
		
		anchorPoint = CGPoint.zero
		
		isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		print("touch")
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
	}
}
