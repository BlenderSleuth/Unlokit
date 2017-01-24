//
//  Level6.swift
//  Unlokit
//
//  Created by Ben Sutherland on 29/12/2016.
//  Copyright © 2016 Ben Sutherland. All rights reserved.
//

import SpriteKit

class Level6: Level {
	// Set number of tools for level
	override func setupToolsForLevel() {
		for tool in toolIcons {
			switch tool.type! {
			case .spring:
				tool.number = 0
			case .glue:
				tool.number = 0
			case .fan:
				tool.number = 0
			case .gravity:
				tool.number = 0
			case .time:
				tool.number = 0
			}
		}
	}
}
