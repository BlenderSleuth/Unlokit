//
//  LevelView.swift
//  Unlokit
//
//  Created by Ben Sutherland on 31/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

protocol LevelViewDelegate: class {
	var levelViews: [Int: [LevelView]] { get set }
	var currentLevelView: LevelView? { get set }
	var nextLevelView: LevelView? { get set }
	
	func present(level: Level)
	func setNextLevelView(from levelView: LevelView)
}

class LevelView: UIView, UIGestureRecognizerDelegate {
	
	let level: Level

	// Removing this, using solid colour instead
	//let imageView: UIImageView

	// Colour constants
	let availableColour = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
	let notAvailableColour = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)

	// For darkinging the image view
	let coverLayer = CALayer()
	
	var delegate: LevelViewDelegate
	
	init(frame: CGRect, level: Level, delegate: LevelViewDelegate) {
		self.level = level
		self.delegate = delegate
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
		label.font = UIFont(name: "NeuropolXRg-Regular", size: 64)
		label.textAlignment = .center
		label.text = "\(level.number)"
		label.textColor = .white
		label.layer.zPosition = 10
		
		//imageView = UIImageView(image: level.thumbnail)
		//imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
		
		super.init(frame: frame)
		//addSubview(imageView)
		addSubview(label)

		backgroundColor = availableColour
		coverLayer.frame = self.bounds
		coverLayer.backgroundColor = UIColor.black.cgColor
		coverLayer.opacity = 0.0
		self.layer.addSublayer(coverLayer)
		
		if self.delegate.levelViews[level.stageNumber] == nil {
			self.delegate.levelViews[level.stageNumber] = [self]
		} else {
			self.delegate.levelViews[level.stageNumber]?.insert(self, at: level.number - 1)
		}
		
		// Check if level is available
		if !level.available {
			self.backgroundColor = notAvailableColour
			//self.imageView.removeFromSuperview()
		}
		
		self.layer.cornerRadius = 15
		self.layer.masksToBounds = true
		
		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
		longPressGesture.minimumPressDuration = 0.001
		longPressGesture.allowableMovement = 5
		longPressGesture.cancelsTouchesInView = false
		longPressGesture.delegate = self
		addGestureRecognizer(longPressGesture)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// Make sure scroll view gets gestures as well
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	func handleLongPress(_ sender: UIGestureRecognizer) {
		guard level.available else {
			return
		}
		
		switch (sender.state) {
		case .began: // Object pressed
			coverLayer.opacity = 0.7
		case .changed:
			// Reset sender
			sender.isEnabled = false
			sender.isEnabled = true
		case .ended: // Object released
			coverLayer.opacity = 0
			
			let convertedPosition = convert(sender.location(in: self), to: superview!)
			
			if self.frame.contains(convertedPosition) {
				delegate.currentLevelView = self
				delegate.setNextLevelView(from: self)
				
				delegate.present(level: level)
			}
			
		case .failed, .cancelled:
			coverLayer.opacity = 0
			
			
		default: // Unknown tap
			print(sender.state.rawValue);
		}
	}
	
	func makeAvailable() {
		//addSubview(imageView)
		backgroundColor = availableColour
		level.available = true
	}
	func reset() {
		// Check if level is completed or not
		if level.completed {
			layer.borderColor = UIColor.green.cgColor
		} else if level.available {
			layer.borderColor = UIColor.orange.cgColor
		}
	}
}
