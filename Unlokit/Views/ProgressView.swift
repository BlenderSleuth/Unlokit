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
	let originalWidth: CGFloat
	let circle: UIView
	let levelScrollView: UIScrollView
	
	var xPos: CGFloat
	
	init(frame: CGRect, scrollInsetWidth: CGFloat, padding: CGFloat, levelScrollView: UIScrollView) {
		self.scrollInsetWidth = scrollInsetWidth
		self.padding = padding
		self.originalWidth = frame.width
		self.levelScrollView = levelScrollView
		
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
		
		// Set position here, easier
		circle.center.y = yPos
		circle.center.x = scrollInsetWidth + padding / 2
		
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
		return true
	}
	
	func animateToNextLevel(x: CGFloat, levelView: LevelView) {
		// Get delta position to move by
		let deltaX = x - frame.width
		
		// get max offset for scroll view, if less than zero make it zero
		var maxOffset = levelScrollView.contentSize.width - levelScrollView.frame.width
		if maxOffset <= 0 {
			maxOffset = 0
		}
		
		// Set the content offset of the view
		let contentOffset: CGFloat
		if deltaX >= maxOffset {
			contentOffset = maxOffset
		// If the progress view is smaller than half the scroll view, don't move to centre
		} else if (self.frame.width + deltaX - scrollInsetWidth) < levelScrollView.frame.width / 2 {
			contentOffset = 0
		// If the delta is too small, don't centre it
		} else if deltaX <= levelView.frame.width + padding {
			contentOffset = deltaX
		} else {
			// Animate to centre
			contentOffset = deltaX - levelScrollView.frame.width / 2
		}
		
		// Animate to new position
		UIView.animate(withDuration: 1.5) {
			self.frame.size.width += deltaX
			self.circle.center.x += deltaX
			self.levelScrollView.contentOffset.x += contentOffset
		}
	}
	
	func update(levelViews: [LevelView]) {
		// Reset
		xPos = scrollInsetWidth + padding / 2
		
		// Iterate through levels
		for levelView in levelViews {
			// Add levels until it reaches a completed one
			if addLevel(levelView) {
				animateToNextLevel(x: xPos, levelView: levelView)
				return
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
