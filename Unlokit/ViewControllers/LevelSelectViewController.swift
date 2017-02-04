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
	var levelViews = [Int: LevelView]()
	var levels = [Level]()
	
	var nextLevelView: LevelView?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupScroll(frame: view.frame)
    }
	override func viewWillAppear(_ animated: Bool) {
		// Reset colour
		for (_, levelView) in levelViews {
			levelView.reset()
		}
		// Save levels
		for (_, stageView) in stageViews {
			stageView.stage.saveLevels()
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
		
		for stage in Stages.sharedInstance.stages {
			let stageView = StageView(frame: CGRect(origin: CGPoint(x: 0, y: yPos), size: size), stage: stage, delegate: self)
			mainScrollView.addSubview(stageView)
			
			stageViews[stageView.stage.number] = stageView
			
			yPos += height
		}
	}
	func setCurrentLevel(levelView: LevelView) {
		nextLevelView = levelView
	}
	
	func setNextLevelView(from levelView: LevelView) {
		// Find next level view and make it avaible
		let number = levelView.level.number
		nextLevelView = levelViews[number + 1]
	}
	
	func present(level: Level) {
		if let gameViewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
			navigationController?.pushViewController(gameViewController, animated: true)
			gameViewController.level = level
		}
	}
	
	@IBAction func unwindToList(sender: UIStoryboardSegue) {
		if let game = sender.source as? GameViewController {
			if game.nowAvailable {
				nextLevelView?.makeAvailable()
			}
		}
	}
	override var prefersStatusBarHidden: Bool {
		return true
	}
}
