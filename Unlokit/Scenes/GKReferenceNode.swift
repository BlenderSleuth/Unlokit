//
//  GKReferenceNode.swift
//  Unlokit
//
//  Created by Ben Sutherland on 27/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GKReferenceNode: SKReferenceNode {
	
	let gkScene: GKScene
	
	init?(with file: String?) {
		if file == nil {
			return nil
		}
		
		gkScene = GKScene(fileNamed: file!)!
		
		super.init(fileNamed: file)
	}
	
	override func didLoad(_ node: SKNode?) {
		super.didLoad(node)
	}
	
	required init?(coder aDecoder: NSCoder) {
		gkScene = GKScene(fileNamed: "")!
		super.init(coder: aDecoder)
	}
}
