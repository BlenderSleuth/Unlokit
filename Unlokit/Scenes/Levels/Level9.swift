//
//  Level9.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import SpriteKit

class Level9: Level {
	// Set number of tools for level
	override func setupToolsForLevel() {
		for (type, tool) in toolIcons {
			switch type {
			case .spring:
				tool.number = 15
			case .bomb:
				tool.number = 10
			case .glue:
				tool.number = 0
			case .fan:
				tool.number = 0
			case .gravity:
				tool.number = 0
			}
		}
	}
}