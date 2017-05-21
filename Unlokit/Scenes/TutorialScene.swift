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
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        startTutorial()
    }
    
    func startTutorial() {
        let current = HelpNode(circlePosition: convert(key.position, from: key.parent!),
                               size: self.size)
        current.zPosition = 200
        
        //cameraNode.addChild(current)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
