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
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
