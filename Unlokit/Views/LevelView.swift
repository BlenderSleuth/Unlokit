//
//  LevelView.swift
//  Unlokit
//
//  Created by Ben Sutherland on 31/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

protocol LevelSelectDelegate {
	func present(level: Int)
	var levels: [LevelView] { get set }
}

class LevelView: UIView {
	
	let level: Level
	
	let imageView: UIImageView
	
	var delegate: LevelSelectDelegate

	init(frame: CGRect, level: Level, delegate: LevelSelectDelegate) {
		self.level = level
		self.delegate = delegate
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
		label.font = UIFont(name: "NeuropolXRg-Regular", size: 64)
		label.textAlignment = .center
		label.text = "\(level.number)"
		label.textColor = .white
		
		imageView = UIImageView(image: level.thumbnail)
		imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

		
		
		super.init(frame: frame)
		addSubview(imageView)
		addSubview(label)
		
		self.delegate.levels.append(self)
		
		self.layer.cornerRadius = 15
		self.layer.borderColor = UIColor.orange.cgColor
		self.layer.masksToBounds = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func reset() {
		self.layer.borderWidth = 0
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for _ in touches {
			self.layer.borderWidth = 5
			delegate.present(level: level.number)
		}
	}
}
