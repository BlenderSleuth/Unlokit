//
//  TitleViewController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 18/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit
import GameKit

enum Achievement: String {
	case stage1Secret = "stage1_secret"
	case stage2Secret = "stage2_secret"
}
func report(achievement: Achievement) {
	if GKLocalPlayer.localPlayer().isAuthenticated {
		let achievement = GKAchievement(identifier: achievement.rawValue)
		GKAchievement.report([achievement], withCompletionHandler: nil)
	}
}

class TitleViewController: UIViewController, GKGameCenterControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		if isAppFirstLaunch() {
			authenticatePlayer()
		}
		
		// TODO: Music
		//SoundFX.sharedInstance.playBackgroundMusic(filename: "")
    }
	
	func authenticatePlayer() {
		let localPlayer = GKLocalPlayer()
		localPlayer.authenticateHandler = { viewController, error in
			if let vc = viewController {
				self.present(vc, animated: true, completion: nil)
			}
			if error != nil {
				self.noGameCenter()
			}
		}
	}
	
	func noGameCenter() {
		// Tell user to log into game center
		let alert = UIAlertController(title: "Game Center", message: "Please enable game center", preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { _ in alert.dismiss(animated: true, completion: nil) }
		
		alert.addAction(ok)
		self.present(alert, animated: true, completion: nil)
	}

	@IBAction func gameCenterButton(_ sender: UIButton) {
		if GKLocalPlayer.localPlayer().isAuthenticated {
			print(GKLocalPlayer.localPlayer().isAuthenticated)
			let gc = GKGameCenterViewController()
			gc.gameCenterDelegate = self
			present(gc, animated: true, completion: nil)
		} else {
			noGameCenter()
		}
	}
	func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
		gameCenterViewController.dismiss(animated: true, completion: nil)
	}
	override var prefersStatusBarHidden: Bool {
		return true
	}
}
