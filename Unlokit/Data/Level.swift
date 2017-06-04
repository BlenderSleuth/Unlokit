//
//  Level.swift
//  Unlokit
//
//  Created by Ben Sutherland on 4/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

class Level: NSObject, NSCoding {
	let number: Int
	
	var stageNumber: Int
	
	var available: Bool
	var isCompleted: Bool
	var isSecret: Bool
	
	var isTutorial: Bool
	
	init(number: Int, stageNumber: Int, available: Bool, isCompleted: Bool = false, isTutorial: Bool = false) {
		self.number = number
		self.available = available
		self.isCompleted = isCompleted
		self.stageNumber = stageNumber
		self.isTutorial = isTutorial
		
		// Not to be encoded
		self.isSecret = false
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		// Decode properties
		let number = aDecoder.decodeInteger(forKey: "number")
		let stageNumber = aDecoder.decodeInteger(forKey: "stageNumber")
		let available = aDecoder.decodeBool(forKey: "available")
		let isCompleted = aDecoder.decodeBool(forKey: "isCompleted")
		
		// Initialise with decoded properties
		self.init(number: number, stageNumber: stageNumber, available: available, isCompleted: isCompleted)
	}
	
	func encode(with aCoder: NSCoder) {
		// Encode properties
		aCoder.encode(number, forKey: "number")
		aCoder.encode(stageNumber, forKey: "stageNumber")
		aCoder.encode(available, forKey: "available")
		aCoder.encode(isCompleted, forKey: "isCompleted")
	}
}
