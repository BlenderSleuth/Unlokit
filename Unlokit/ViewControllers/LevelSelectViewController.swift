//
//  LevelSelectViewController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 31/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController, LevelViewDelegate {

	@IBOutlet weak var mainScrollView: UIScrollView!
	
	var stageViews = [Int: StageView]()
	// Level views based on stage
	var levelViews = [Int: [LevelView]]()
	
	var stages = [Int: Stage]()
	var levels = [Level]()
	
	var currentLevelView: LevelView?
	var nextLevelView: LevelView?
	
	// Start off true for when the game starts
	var backFromCompletion = true
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupScroll(frame: view.frame)
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// Reset colours
		for (_, stage) in levelViews {
			for _/*levelView*/ in stage {
				//levelView.reset()
			}
		}
		
		// Iterate through stages
		for (_, stageView) in stageViews {
			// Save levels
			stageView.stage.saveLevels()
			
			// If there it is back from completing, update levels
			if backFromCompletion {
				// Check if levelViews
				if let levelViews = levelViews[stageView.stage.number] {
					// Update progress view with stage
					stageView.progressView.update(levelViews: levelViews)
				}
			}
		}
		
		// reset current level view
		nextLevelView = nil
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
		
		// Local variable, cleaner
		
		
		for stage in Stages.sharedInstance.stages {
			let stageView = StageView(frame: CGRect(origin: CGPoint(x: 0, y: yPos), size: size), stage: stage, delegate: self)
			mainScrollView.addSubview(stageView)
			
			stageViews[stageView.stage.number] = stageView
			
			yPos += height
		}
	}
	
	func setNextLevelView(from levelView: LevelView) {
		// Find next level view and make it avaible
		let number = levelView.level.number
		// Zero indexing of array means that returning the number
		nextLevelView = levelViews[levelView.level.stageNumber]?[number]
	}
	
	func present(level: Level) {
		if let gameViewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
			navigationController?.pushViewController(gameViewController, animated: true)
			gameViewController.level = level
			
			// Reset
			backFromCompletion = false
		}
	}
	
	@IBAction func unwindToList(sender: UIStoryboardSegue) {		
		if let gameVC = sender.source as? GameViewController {
			if gameVC.completed {
				backFromCompletion = true
				nextLevelView?.makeAvailable()
			}
		}
	}
	override var prefersStatusBarHidden: Bool {
		return true
	}
}
