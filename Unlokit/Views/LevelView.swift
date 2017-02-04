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
		
		imageView = UIImageView(image: level.thumbnail)
		imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
		
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
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		// Check if it is available
		guard level.available else {
			return
		}
		delegate.currentLevelView = self
		delegate.setNextLevelView(from: self)
		
		for _ in touches {
			self.layer.borderWidth = 5
			delegate.present(level: level)
		}
	}
}
