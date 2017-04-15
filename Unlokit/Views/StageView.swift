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

	let progressView: ProgressView
	
	let stage: Stage
	
	let delegate: LevelViewDelegate
	
	init(frame: CGRect, stage: Stage, delegate: LevelViewDelegate) {
		self.stage = stage
		self.delegate = delegate
		
		// Setup views
		titleView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 4))
		titleView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
		
		// Create title label for stage
		let titleLabel = UILabel(frame: CGRect(x: 40, y: 0, width: frame.width, height: frame.height / 4))
		titleLabel.text = stage.name
		titleLabel.font = UIFont(name: "NeuropolXRg-Regular", size: 32)
		titleView.addSubview(titleLabel)
		
		// Create scroll view to hold levels
		let scrollViewFrame = CGRect(x: 0, y: frame.height * 0.25, width: frame.width, height: frame.height * 0.75)
		levelScrollView = UIScrollView(frame: scrollViewFrame)
		levelScrollView.showsHorizontalScrollIndicator = false

		//TODO: gradient stuff
		//let gradientView = UIView(frame: levelScrollView.bounds)
		//let scrollGradient = CAGradientLayer()
		//scrollGradient.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
		//gradientView.layer.insertSublayer(scrollGradient, at: 0)
		//levelScrollView.addSubview(gradientView)


		// Space inbetween level views
		let yPadding: CGFloat = 20
		let xPadding: CGFloat = 50

		// Height minus padding to get level height
		let height = levelScrollView.frame.height - (yPadding * 2)
		let width = height
		
		// Find full width based on padding and level width
		let fullWidth = ((width + xPadding) * CGFloat(stage.levels.count)) + xPadding
		levelScrollView.contentSize.width = fullWidth
		
		// Create progress bar
		let progressHeight = levelScrollView.frame.height / 12
		let progressYPos = (levelScrollView.frame.height / 2) - (levelScrollView.frame.height / 24)
		
		// For continuing progress view when user drags scroll view over edge
		let insetWidth: CGFloat = 1000
		
		// Make progress view shortest it will ever be, it will extend after
		let progressFrame = CGRect(x: -insetWidth, y: progressYPos, width: insetWidth + xPadding / 2, height: progressHeight)
		progressView = ProgressView(frame: progressFrame, scrollInsetWidth: insetWidth, padding: xPadding, levelScrollView: levelScrollView)
		levelScrollView.addSubview(progressView)
		
		// Iterate through levels to add them all
		var xPos = xPadding
		for level in stage.levels {
			// Size and position of levels
			let rect = CGRect(x: xPos, y: yPadding, width: width, height: height)
			
			// Create level view
			let levelView = LevelView(frame: rect, level: level, delegate: delegate)
			levelScrollView.addSubview(levelView)
			
			// Update xPos
			xPos += width + xPadding
		}

		super.init(frame: frame)

		// Add views
		addSubview(titleView)
		addSubview(levelScrollView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
