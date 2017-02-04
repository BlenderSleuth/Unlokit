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
	
	private let imageName: String
	var thumbnail: UIImage?
	
	var stageNumber: Int
	
	var available: Bool
	var completed: Bool
	
	init(number: Int, stageNumber: Int, imageName: String, available: Bool, completed: Bool = false) {
		self.number = number
		self.imageName = imageName
		self.available = available
		self.completed = completed
		self.stageNumber = stageNumber
		thumbnail = UIImage(named: imageName)
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		// Decode properties
		let number = aDecoder.decodeInteger(forKey: "number")
		let stageNumber = aDecoder.decodeInteger(forKey: "stageNumber")
		let imageName = aDecoder.decodeObject(forKey: "imageName") as! String
		let available = aDecoder.decodeBool(forKey: "available")
		let completed = aDecoder.decodeBool(forKey: "completed")
		
		// Initialise with decoded properties
		self.init(number: number, stageNumber: stageNumber, imageName: imageName, available: available, completed: completed)
	}
	
	func encode(with aCoder: NSCoder) {
		// Encode properties
		aCoder.encode(number, forKey: "number")
		aCoder.encode(stageNumber, forKey: "stageNumber")
		aCoder.encode(imageName, forKey: "imageName")
		aCoder.encode(available, forKey: "available")
		aCoder.encode(completed, forKey: "completed")
	}
}
