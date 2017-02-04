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
	
	var available: Bool
	
	init(number: Int, imageName: String, available: Bool = false) {
		self.number = number
		self.imageName = imageName
		self.available = available
		thumbnail = UIImage(named: imageName)
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		// Decode properties
		let number = aDecoder.decodeInteger(forKey: "number")
		let imageName = aDecoder.decodeObject(forKey: "imageName") as! String
		let available = aDecoder.decodeBool(forKey: "available")
		
		// Initialise with decoded properties
		self.init(number: number, imageName: imageName, available: available)
	}
	
	func encode(with aCoder: NSCoder) {
		// Encode properties
		aCoder.encode(number, forKey: "number")
		aCoder.encode(imageName, forKey: "imageName")
		aCoder.encode(available, forKey: "available")
	}
}
