//
//  AudioController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import AVFoundation
import SpriteKit

class SoundFX {
	static let sharedInstance = SoundFX()
	
	private let soundActions: [String : SKAction]
	
	private var backgroundMusicPlayer: AVAudioPlayer?
	
	subscript(index: String) -> SKAction? {
		return soundActions[index]
	}
	
	private init() {
		// Load sounds into memory
		let lock = SKAction.playSoundFileNamed("Lock.caf", waitForCompletion: false)
		let smash = SKAction.playSoundFileNamed("Smash.caf", waitForCompletion: false)
		let explosion = SKAction.playSoundFileNamed("Explosion.caf", waitForCompletion: false)
		let block = SKAction.playSoundFileNamed("Block.caf", waitForCompletion: false)
		let blockShatter = SKAction.playSoundFileNamed("BlockShatter.caf", waitForCompletion: false)
		let cannon = SKAction.playSoundFileNamed("Cannon", waitForCompletion: false)
		let rumble = SKAction.playSoundFileNamed("Rumble", waitForCompletion: false)
		
		let bounce1 = SKAction.playSoundFileNamed("Bounce1.caf", waitForCompletion: false)
		let bounce2 = SKAction.playSoundFileNamed("Bounce2.caf", waitForCompletion: false)
		let bounce3 = SKAction.playSoundFileNamed("Bounce3.caf", waitForCompletion: false)
		let bounce4 = SKAction.playSoundFileNamed("Bounce4.caf", waitForCompletion: false)
		
		// Dictionary for sounds to be preloaded
		soundActions = ["lock":lock,
		                "smash":smash,
		                "block": block,
		                "blockShatter": blockShatter,
		                "explosion": explosion,
		                "cannon": cannon,
		                "rumble": rumble,
		                "bounce1": bounce1,
		                "bounce2": bounce2,
		                "bounce3": bounce3,
		                "bounce4": bounce4]
	}
	
	func playBackgroundMusic(filename: String) {
		let url = Bundle.main.url(forResource: filename, withExtension: nil)
		if (url == nil) {
			print("Could not find file: \(filename)")
			return
		}
		
		var error: NSError? = nil
		do {
			backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
		} catch let error1 as NSError {
			error = error1
			backgroundMusicPlayer = nil
		}
		if let player = backgroundMusicPlayer {
			player.numberOfLoops = -1
			player.prepareToPlay()
			player.play()
		} else {
			print("Could not create audio player: \(error!)")
		}
	}
	public func pauseBackgroundMusic() {
		if let player = backgroundMusicPlayer {
			if player.isPlaying {
				player.pause()
			}
		}
	}
	public func resumeBackgroundMusic() -> Bool {
		if let player = backgroundMusicPlayer {
			if !player.isPlaying {
				player.play()
				return true
			}
		}
		return false
	}
}
