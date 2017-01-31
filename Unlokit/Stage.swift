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
		stages = Stages.getStagesFromPlist()
	}
	
	private class func getStagesFromPlist() -> [Stage]{
		// Get plist
		let plist = Bundle.main.path(forResource: "LevelData", ofType: "plist")!
		let stageDict = NSDictionary(contentsOfFile: plist) as! [String: Any]
		
		var stageArray = [Stage]()
		
		for (stage, _)in stageDict {
			// Get stage number
			let number = Int("\(stage.characters.last!)")!
			let stage = Stage(number: number)
			stageArray.append(stage)
		}

		// Sort array to be in the correct order
		stageArray.sort {
			$0.number < $1.number
		}
		
		return stageArray
	}
}

class Stage {
	let name: String
	let number: Int
	
	let levels: [Level]
	
	init(number: Int) {
		self.number = number
		self.name = "Stage \(number)"
		
		levels = Stage.getLevelsFromPlist(number: number)
	}
	
	private class func getLevelsFromPlist(number: Int) -> [Level]{
		// Get plist
		let plist = Bundle.main.path(forResource: "LevelData", ofType: "plist")!
		let stageDict = NSDictionary(contentsOfFile: plist) as! [String: [String: Any]]
		let levelDict = stageDict["Stage\(number)"]!
		
		var levelArray = [Level]()
		
		// Iterate through levels in plist
		for (levelNumberStr, _) in levelDict {
			let levelNumber = levelNumberStr.numbers() ?? 0
			
			let level = Level(number: levelNumber, imageName: "Thumbnail")
			levelArray.append(level)
		}
		// Sort array to be in the correct order
		levelArray.sort {
			$0.number < $1.number
		}
		
		return levelArray
	}
}

class Level {
	let number: Int
	var thumbnail: UIImage?
	
	init(number: Int, imageName: String) {
		self.number = number
		thumbnail = UIImage(named: imageName)
	}
}
