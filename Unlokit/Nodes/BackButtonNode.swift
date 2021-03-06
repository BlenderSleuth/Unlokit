//
//  BackButtonNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 1/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class BackButtonNode: SKSpriteNode {
	// MARK: Variable
	// Initialised as implicitly-unwrapped optionals for file archive compatability
	var label: SKLabelNode!
	var redCircle: SKShapeNode!
	var blueCircle: SKShapeNode!
	
	var pressed = false
	
	// Must be initalised from scene
	weak var delegate: LevelController!
	
	// Used for initialising from file
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		redCircle = SKShapeNode(circleOfRadius: size.width / 2)
		redCircle.fillColor = .red
		redCircle.strokeColor = .red
		redCircle.alpha = 0.2
		
		blueCircle = SKShapeNode(circleOfRadius: size.width / 2)
		blueCircle.fillColor = .blue
		blueCircle.strokeColor = .blue
		blueCircle.isHidden = true
		
		label = SKLabelNode(text: "Back")
		label.position = CGPoint(x: 40, y: -40)
		label.fontName = neuropolFont
		label.fontSize = 26
		label.zPosition = 10
		
		self.position = position
		
		addChild(redCircle)
		addChild(blueCircle)
		addChild(label)
		
		isUserInteractionEnabled = true
	}
	
	private func press() {
		pressed = !pressed
		redCircle.isHidden = pressed
		blueCircle.isHidden = !pressed
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		press()
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		press()
		delegate.returnToLevelSelect()
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		press()
	}
}
