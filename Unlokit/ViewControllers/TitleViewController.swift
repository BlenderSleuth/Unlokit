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
func report(achievement: Achievement, percentComplete: Double = 100) {
	if GKLocalPlayer.localPlayer().isAuthenticated {
		let achievement = GKAchievement(identifier: achievement.rawValue)
		achievement.percentComplete = percentComplete
		GKAchievement.report([achievement], withCompletionHandler: nil)
	}
}

class TitleViewController: UIViewController, GKGameCenterControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticatePlayer(showVc: isFirstAppLaunch)
		
		// TODO: Music
		//SoundFX.sharedInstance.playBackgroundMusic(filename: "")
    }
	
	func authenticatePlayer(showVc: Bool) {
		let localPlayer = GKLocalPlayer.localPlayer()
		localPlayer.authenticateHandler = { viewController, error in
			if let vc = viewController, showVc {
				self.present(vc, animated: true, completion: nil)
			} else if let description = error?.localizedDescription, showVc {
                self.noGameCenter(error: description)
			}
		}
	}
	
    func noGameCenter(error: String) {
		// Tell user to log into game center
		let alert = UIAlertController(title: "Game Center",
		                              message: "Error with Game Centre: \(error)",
                                        preferredStyle: .alert)
        
		let ok = UIAlertAction(title: "OK",
		                       style: UIAlertActionStyle.default) { _ in alert.dismiss(animated: true,
		                                                                               completion: nil) }
		
		alert.addAction(ok)
		self.present(alert, animated: true, completion: nil)
	}

	@IBAction func gameCenterButton(_ sender: UIButton) {
		if GKLocalPlayer.localPlayer().isAuthenticated {
			let gc = GKGameCenterViewController()
			gc.gameCenterDelegate = self
			present(gc, animated: true, completion: nil)
		} else {
			authenticatePlayer(showVc: true)
            //noGameCenter(error: "Player is not authenticated")
		}
	}
	func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
		gameCenterViewController.dismiss(animated: true, completion: nil)
	}
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		// Unhide
		navigationController?.viewControllers[0].view.isHidden = false
	}
	
	// From the instructions view
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if sender is InstructionPageContentViewController {
			if let levelSelect = segue.destination as? LevelSelectViewController {
				levelSelect.doTutorial = true
				// Hide title view controller and go back, before the seque is performed
				navigationController?.navigationBar.isHidden = true
				navigationController?.viewControllers[0].view.isHidden = true
				navigationController?.popToRootViewController(animated: false)
				
			}
		}
	}
}
