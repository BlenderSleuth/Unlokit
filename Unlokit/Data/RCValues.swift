//
//  RCValues.swift
//  Unlokit
//
//  Created by Ben Sutherland on 18/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import Foundation

class RCValues {
	static let sharedInstance = RCValues()

	let cameraTime: TimeInterval = 1.5
	let toolTime: TimeInterval = 7
	let cameraWait: TimeInterval = 0.3
	let cameraLerp: TimeInterval = 0.11

	private init() {
		loadDefaultValues()
	}
	func loadDefaultValues() {
		// Haven't done anything here yet...
	}
}
