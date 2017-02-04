//
//  ProgressView.swift
//  Unlokit
//
//  Created by Ben Sutherland on 3/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

class ProgressView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = .orange
	}
	
	var circles = [UIView]()
	
	func addLevel(levelView: LevelView, padding: CGFloat) {
		let yPos = frame.height / 2
		let xPos =  levelView.frame.origin.x - (padding/2) - 10
		
		let point = CGPoint(x: xPos, y: yPos)
		
		// Size of circle indicator
		let size: CGFloat = 20
		
		// Create new circle
		let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size)))
		view.backgroundColor = .red
		view.layer.cornerRadius = size / 2
		view.layer.masksToBounds = true
		view.layer.zPosition = 10
		
		// Set position here, easier
		view.center = point
		addSubview(view)
		
		circles.append(view)
		
		if levelView.level.available {
			
		}
	}
	func animateToLevel() {
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
