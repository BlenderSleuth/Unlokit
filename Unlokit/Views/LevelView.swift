//
//  LevelView.swift
//  Unlokit
//
//  Created by Ben Sutherland on 31/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

class LevelView: UIView {
	
	let level: Level
	
	let imageView: UIImageView

	
	init(frame: CGRect, level: Level) {
		self.level = level
		
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
		
		self.layer.cornerRadius = 15
		self.layer.masksToBounds = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
