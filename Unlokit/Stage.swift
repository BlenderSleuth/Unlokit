//
//  Stage.swift
//  Unlokit
//
//  Created by Ben Sutherland on 31/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import SpriteKit

class Stages {
	static let sharedInstance = Stages()
	
	let stages: [Stage]
	
	init() {
		// Stub stages
		let stage1 = Stage(name: "Stage 1")
		let stage2 = Stage(name: "Stage 2")
		let stage3 = Stage(name: "Stage 3")
		let stage4 = Stage(name: "Stage 4")
		stages = [stage1, stage2, stage3, stage4]
	}
}

class Stage {
	let name: String
	
	let levels: [level]
	
	init(name: String) {
		self.name = name
		
		let level1 = level(number: 1)
		let level2 = level(number: 2)
		let level3 = level(number: 3)
		let level4 = level(number: 4)
		let level5 = level(number: 5)
		let level6 = level(number: 6)
		let level7 = level(number: 7)
		let level8 = level(number: 8)
		
		levels = [level1, level2, level3, level4, level5, level6, level7, level8]
	}
}

class level {
	let number: Int
	
	init(number: Int) {
		self.number = number
	}
}
