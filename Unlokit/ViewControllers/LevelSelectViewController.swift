//
//  LevelSelectViewController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 31/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController {

	@IBOutlet weak var mainScrollView: UIScrollView!
	
	var selectedLevel = 1
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupScroll(frame: view.frame)
    }
	
	func setupScroll(frame: CGRect) {
		// Each stage view is the width of the screen, and 1/4 of the width in height
		let width = frame.width
		let height = width / 4
		let size = CGSize(width: width, height: height)
		
		// Find out the full height of the scroll view
		let fullHeight = height * CGFloat(Stages.sharedInstance.stages.count)
		
		mainScrollView.contentSize.height = fullHeight
		
		// To find the y position of each stage view
		var yPos: CGFloat = 0
		
		for stage in Stages.sharedInstance.stages {
			let stageView = StageView(frame: CGRect(origin: CGPoint(x: 0, y: yPos), size: size), stage: stage)
			mainScrollView.addSubview(stageView)
			
			yPos += height
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let gameVC = segue.destination as! GameViewController
		gameVC.level = selectedLevel
    }
}
