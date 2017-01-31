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
	
	let levels: [Level]
	
	init(name: String) {
		self.name = name
		
		let level1 = Level(number: 1, imageName: "Thumbnail")
		let level2 = Level(number: 2, imageName: "Thumbnail")
		let level3 = Level(number: 3, imageName: "Thumbnail")
		let level4 = Level(number: 4, imageName: "Thumbnail")
		let level5 = Level(number: 5, imageName: "Thumbnail")
		let level6 = Level(number: 6, imageName: "Thumbnail")
		let level7 = Level(number: 7, imageName: "Thumbnail")
		let level8 = Level(number: 8, imageName: "Thumbnail")
		
		levels = [level1, level2, level3, level4, level5, level6, level7, level8]
	}
}

class Level {
	let number: Int
	let thumbnail: UIImage
	
	init(number: Int, imageName: String) {
		self.number = number
		thumbnail = UIImage(named: imageName)!
	}
}
