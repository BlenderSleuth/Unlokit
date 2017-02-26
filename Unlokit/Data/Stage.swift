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
	
	private class func getStagesFromPlist() -> [Stage] {
		// Get plist
		let plist = Bundle.main.path(forResource: "LevelData", ofType: "plist")!
		let stageDict = NSDictionary(contentsOfFile: plist) as! [String: Any]
		
		var stageArray = [Stage]()
		
		for (stage, _) in stageDict {
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
	
	var levels = [Level]()
	
	// File url to save to
	let levelFileURL = try! FileManager.default.url(for: .documentDirectory,
	                                                in: .userDomainMask,
	                                                appropriateFor: nil,
	                                                create: false).appendingPathComponent("LevelData")
	
	init(number: Int) {
		self.number = number
		self.name = "Stage \(number)"
		
		loadLevels()
	}
	
	func loadLevels() {
		// Check if first file is present
		if FileManager.default.fileExists(atPath: levelFileURL.appendingPathExtension("1:1").path) {
			var isNil = false
			var levelNumber = 1
			
			while !isNil {
				let fileURL = levelFileURL.appendingPathExtension("\(number):\(levelNumber)")
				
				do {
					let levelData = try Data(contentsOf: fileURL)
					let level = NSKeyedUnarchiver.unarchiveObject(with: levelData) as! Level
					
					levels.append(level)
					
					levelNumber += 1
				} catch {
					isNil = true

					// Check for any new levels in plist
					let newLevels = getDefaultLevelsFromPlist(stage: number)
					if levelNumber < newLevels.count {
						print("New levels")

						let array = newLevels.suffix(from: levelNumber-1)
						for level in array {
							levels.append(level)
						}
					}
				}
			}
		} else {
			print("loaded from plist")
			levels = getDefaultLevelsFromPlist(stage: number)
		}
	}
	func saveLevels() {
		// Archive levels
		for level in levels {
			let levelData = NSKeyedArchiver.archivedData(withRootObject: level)
			// URL with stage and level number
			let fileURL = levelFileURL.appendingPathExtension("\(number):\(level.number)")
			
			do {
				try levelData.write(to: fileURL)
			} catch {
				print("Couldn't write to file")
			}
		}
	}
}
