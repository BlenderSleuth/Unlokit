//
//  ProgressView.swift
//  Unlokit
//
//  Created by Ben Sutherland on 3/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

class ProgressView: UIView {
	let padding: CGFloat
	let scrollInsetWidth: CGFloat
	
	var xPos: CGFloat
	
	let circle: UIView
	
	let originalWidth: CGFloat
	
	init(frame: CGRect, scrollInsetWidth: CGFloat, padding: CGFloat) {
		self.scrollInsetWidth = scrollInsetWidth
		self.padding = padding
		self.originalWidth = frame.width
		xPos = padding / 2 + scrollInsetWidth
		
		// Size of circle indicator
		let size: CGFloat = 20
		
		// Create new circle
		circle = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size)))
		circle.backgroundColor = .red
		circle.layer.cornerRadius = size / 2
		circle.layer.masksToBounds = true
		circle.layer.zPosition = 10
		
		let yPos = frame.height / 2
		let point = CGPoint(x: xPos, y: yPos)
		
		// Set position here, easier
		circle.center = point
		
		super.init(frame: frame)
		
		addSubview(circle)
		backgroundColor = .orange
	}
	
	/** Returns true if completed, false if not. */
	func addLevel(_ levelView: LevelView) -> Bool {
		// Check if level is available
		if levelView.level.available {
			levelView.layer.borderWidth = 5
			
			// If not completed, highlight in green
			if !levelView.level.completed {
				levelView.layer.borderColor = UIColor.green.cgColor
				return true
			} else {
				// Otherwise, highlight in orange
				levelView.layer.borderColor = UIColor.orange.cgColor
			}
			
			xPos += levelView.frame.width + padding
			return false
		}
		xPos = 0
		return true
	}
	
	func animateToNextLevel(x: CGFloat) {
		let convertedX = convert(CGPoint(x: x, y: 0), to: self)
		
		// Animate to new position
		UIView.animate(withDuration: 3) {
			
			self.frame.size.width += x
			self.circle.center.x += convertedX.x
		}
	}
	
	func update(levelViews: [LevelView]) {
		// Reset
		self.frame.size.width = originalWidth
		circle.center.x = scrollInsetWidth + padding / 2
		xPos = 0
		
		// Iterate through levels
		for levelView in levelViews {
			// Add levels until it reaches a completed one
			if addLevel(levelView) {
				animateToNextLevel(x: xPos)
				return
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
