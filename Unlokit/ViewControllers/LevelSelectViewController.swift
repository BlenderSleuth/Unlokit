//
//  LevelSelectViewController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 31/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

protocol LevelSelectDelegate: class {
	func completed(_ completed: Bool)
	func setNextLevelView(from levelView: LevelView)

	var currentLevelView: LevelView? { get set }
	var levelViews: [Int: [LevelView]] { get }
}

class LevelSelectViewController: UIViewController, LevelViewDelegate, LevelSelectDelegate {

	@IBOutlet weak var mainScrollView: UIScrollView!

	// Dict of stage views
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
		reset()
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		reset()
	}

	func reset() {
		navigationController?.isNavigationBarHidden = false

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

		// Reset current level view
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
		
		for stage in Stages.sharedInstance.stages {
			let stageView = StageView(frame: CGRect(origin: CGPoint(x: 0, y: yPos), size: size), stage: stage, delegate: self)
			mainScrollView.addSubview(stageView)
			
			stageViews[stageView.stage.number] = stageView
			
			yPos += height
		}
	}
	
	func setNextLevelView(from levelView: LevelView) {
		// Find next level view and make it avaible
		let number = levelView.level.number - 1
		
		// Check levels and stages
		if levelViews[levelView.level.stageNumber]!.endIndex == number + 1 {
			// Get max stage by key of dictionary
			let maxStage = levelViews.max { a, b in a.key < b.key }?.key
			// Last level of last stage, stay the same
			if levelView.level.stageNumber == maxStage {
				print("last level, setting next level to current")
				nextLevelView = levelViews[levelView.level.stageNumber]?[number]
			} else {
				// First level of next stage
				nextLevelView = levelViews[levelView.level.stageNumber + 1]?[0]
			}
		} else {
			// Next level in current stage
			nextLevelView = levelViews[levelView.level.stageNumber ]?[number + 1]
		}
	}
	
	func present(level: Level) {
		if let gameViewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
			
			// Animate with cross dissolve
			let transition = CATransition()
			transition.duration = 0.5
			navigationController?.view.layer.add(transition, forKey: nil)
			navigationController?.pushViewController(gameViewController, animated: false)
			
			gameViewController.level = level
			gameViewController.delegate = self
			
			// Reset
			backFromCompletion = false
		}
	}

	func completed(_ completed: Bool) {
		backFromCompletion = completed
		if completed {
			nextLevelView?.makeAvailable()
		}
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}
}
