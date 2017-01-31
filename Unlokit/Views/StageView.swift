//
//  StageView.swift
//  Unlokit
//
//  Created by Ben Sutherland on 31/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

class StageView: UIView {
	
	let titleView: UIView
	let levelScrollView: UIScrollView
	
	let stage: Stage
	
	init(frame: CGRect, stage: Stage) {
		self.stage = stage
		
		// Setup views
		titleView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 4))
		titleView.backgroundColor = .blue
		
		let titleLabel = UILabel(frame: CGRect(x: 40, y: 0, width: frame.width, height: frame.height / 4))
		titleLabel.text = stage.name
		titleLabel.font = UIFont(name: "NeuropolXRg-Regular", size: 32)
		
		let scrollViewFrame = CGRect(x: 0, y: frame.height * 0.25, width: frame.width, height: frame.height * 0.75)
		
		levelScrollView = UIScrollView(frame: scrollViewFrame)
		levelScrollView.backgroundColor = .black
		levelScrollView.showsHorizontalScrollIndicator = false
		
		super.init(frame: frame)
		
		addSubview(titleView)
		titleView.addSubview(titleLabel)
		addSubview(levelScrollView)
		
		setupLevels()
	}
	
	func setupLevels() {
		// Space inbetween level views
		let padding: CGFloat = 20
		// Height minus padding to get level height
		let height = levelScrollView.frame.height - (padding * 2)
		let width = height
		
		// Find full width based on padding and level width
		let fullWidth = ((width + padding) * CGFloat(stage.levels.count)) + padding
		
		levelScrollView.contentSize.width = fullWidth
		
		var xPos = padding
		
		for level in stage.levels {
			let rect = CGRect(x: xPos, y: padding, width: width, height: height)
			
			let levelView = LevelView(frame: rect, level: level)
			levelView.backgroundColor = .red
			levelScrollView.addSubview(levelView)
			
			xPos += width + padding
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
