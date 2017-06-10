//
//  LevelSelectViewController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 31/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

protocol LevelSelectDelegate: class {
	func completeLevel()
	func saveLevels()
	func setNextLevelView(from levelView: LevelView)

	var currentLevelView: LevelView? { get set }
	var levelViews: [Int: [LevelView]] { get }
}
// This is so that you only do the tutorial once
var doneTutorial = false

class LevelSelectViewController: UIViewController, LevelViewDelegate, LevelSelectDelegate {

	@IBOutlet weak var mainScrollView: UIScrollView!
	
	// Dict of stage views
	var stageViews = [Int: StageView]()
	
	// Set this to true to run the tutorial
	var doTutorial = false

	// Level views based on stage
	var levelViews = [Int: [LevelView]]()
	
	var stages = [Int: Stage]()
	var levels = [Level]()
	
	// So that we can tell which level views to make available
	var currentLevelView: LevelView?
	var nextLevelView: LevelView?
	
	// Whether to reset the scroll views or not
	var notLoaded = true
	
    override func viewDidLoad() {
        super.viewDidLoad()
		// Load stages
		let _ = Stages.sharedInstance.stages
		
		// Run the tutorial if it is the first time or specified
		if (isFirstGameLaunch && !doneTutorial) || doTutorial {
			// Hide navigation bar
			navigationController?.navigationBar.isHidden = true
			
			// Present the tutorial
			present(level: Stages.sharedInstance.tutorial)
			// First game launch is over.
			setValueFor(key: .isFirstGameLaunch)
		} else {
			setupScroll(frame: view.frame)
			reset()
			
			notLoaded = false
		}
    }
	override func viewDidDisappear(_ animated: Bool) {
		if doTutorial || (isFirstGameLaunch && !doneTutorial) {
			// Put the naviagtion bar back
			navigationController?.navigationBar.isHidden = false
			
			// Run this after the tutorial loaded
			setupScroll(frame: view.frame)
			reset(hideNavBar: true)
			doTutorial = false
			notLoaded = true
		}
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if notLoaded {
			reset()
		} else {
			navigationController?.isNavigationBarHidden = false
		}
	}

	func reset(hideNavBar: Bool = false) {
		navigationController?.isNavigationBarHidden = hideNavBar

		// Iterate through stages
		for (_, stageView) in stageViews {
			// Save levels
			stageView.stage.saveLevels()
			
			// Check if there is a levelView
			if let levelViews = levelViews[stageView.stage.number] {
				// Update progress view with stage
				stageView.progressView.update(levelViews: levelViews)
			}
		}

		// Reset current level view
		nextLevelView = nil
	}
	func saveLevels() {
		for (_, stageView) in stageViews {
			// Save levels
			stageView.stage.saveLevels()
		}
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
		}
	}

	func completeLevel() {
		nextLevelView?.makeAvailable()
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}
}
