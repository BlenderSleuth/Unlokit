//
//  InstuctionPageContentViewController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 19/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

class InstructionPageContentViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!

	var pageIndex = 0
	var imageFile: String!

	override func viewDidLoad() {
		super.viewDidLoad()

		imageView.image = UIImage(named: imageFile)
	}
	override var prefersStatusBarHidden: Bool {
		return true
	}
}
