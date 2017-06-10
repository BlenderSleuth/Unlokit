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
	var tutorial = false

	override func viewDidLoad() {
		super.viewDidLoad()
		if tutorial {
			// Remove the image view
			imageView.removeFromSuperview()
			// Ceate tutorial button
			let buttonSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
			let button = UIButton(frame: CGRect(origin: CGPoint(x: view.frame.width/2 - buttonSize.width/2,
			                                                    y: view.frame.height/2 - buttonSize.width/2),
			                                    size: buttonSize))
			
			button.setBackgroundImage(#imageLiteral(resourceName: "Play"), for: .normal)
			button.addTarget(self, action: #selector(runTutorial), for: .touchUpInside)
			button.adjustsImageWhenHighlighted = true
			view.addSubview(button)
			
			// Add a label
			let labelSize = CGSize(width: view.frame.width, height: view.frame.width/3)
			let labelPos = CGPoint(x: 0, y: view.frame.height/2 - buttonSize.width - 15)
			
			let label = UILabel(frame: CGRect(origin: labelPos, size: labelSize))
			if iPhone {
				label.font = UIFont(name: neuropolFont, size: 32)
			} else {
				label.font = UIFont(name: neuropolFont, size: 60)
			}
			
			label.textColor = .white
			label.textAlignment = .center
			label.text = "TUTORIAL"
			view.addSubview(label)
		} else {
			imageView.image = UIImage(named: imageFile)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	func runTutorial() {
		navigationController?.viewControllers[0].performSegue(withIdentifier: "goToLevelSelect", sender: self)
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}
