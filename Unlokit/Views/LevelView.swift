//
//  LevelView.swift
//  Unlokit
//
//  Created by Ben Sutherland on 31/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

protocol LevelViewDelegate: class {
	var levelViews: [String: LevelView] { get set }
	var currentLevelView: LevelView? { get set }
	var nextLevelView: LevelView? { get set }
	
	func present(level: Level)
	func setNextLevelView(from levelView: LevelView)
}

class LevelView: UIView {
	
	let level: Level
	
	let imageView: UIImageView
	// For darkinging the image view
	let coverLayer = CALayer()
	
	var delegate: LevelViewDelegate
	
	var pressed = false
	
	init(frame: CGRect, level: Level, delegate: LevelViewDelegate) {
		self.level = level
		self.delegate = delegate
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
		label.font = UIFont(name: "NeuropolXRg-Regular", size: 64)
		label.textAlignment = .center
		label.text = "\(level.number)"
		label.textColor = .white
		label.layer.zPosition = 10
		
		imageView = UIImageView(image: level.thumbnail)
		imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
		coverLayer.frame = imageView.bounds;
		coverLayer.backgroundColor = UIColor.black.cgColor
		coverLayer.opacity = 0.0
		imageView.layer.addSublayer(coverLayer)
		
		super.init(frame: frame)
		addSubview(imageView)
		addSubview(label)
		
		self.delegate.levelViews["\(level.stageNumber):\(level.number)"] = self
		
		// Check if level is available
		if !level.available {
			self.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
			self.imageView.removeFromSuperview()
		}
		
		self.layer.cornerRadius = 15
		self.layer.borderColor = UIColor.orange.cgColor
		self.layer.masksToBounds = true
		
		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(_:)))
		longPressGesture.minimumPressDuration = 0.1
		longPressGesture.allowableMovement = 5
		addGestureRecognizer(longPressGesture)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func makeAvailable() {
		addSubview(imageView)
		level.available = true
	}
	func reset() {
		if !level.completed {
			layer.borderWidth = 0
		} else {
			layer.borderWidth = 5
		}
	}
	func press() {
		pressed = !pressed
		if pressed {
			self.imageView.backgroundColor = .darkGray
		} else {
			self.imageView.backgroundColor = nil
		}
	}
	func handleLongTap(_ sender: UIGestureRecognizer) {
		guard level.available else {
			return
		}
		
		switch (sender.state) {
		case .began: // Object pressed
			coverLayer.opacity = 0.7
		case .changed:
			return
		case .ended: // Object released
			coverLayer.opacity = 0
			
			let convertedPosition = convert(sender.location(in: self), to: superview!)
			
			if self.frame.contains(convertedPosition) {
				delegate.currentLevelView = self
				delegate.setNextLevelView(from: self)
				
				delegate.present(level: level)
			}
			
		case .failed:
			coverLayer.opacity = 0
		default: // Unknown tap
			print(sender.state);
		}
	}
}
