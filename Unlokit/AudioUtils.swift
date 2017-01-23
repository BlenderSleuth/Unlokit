//
//  AudioController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 23/1/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import AVFoundation

/**
* Audio player that uses AVFoundation to play looping background music and
* short sound effects. For when using SKActions just isn't good enough.
*/
public class SKTAudio {
	public var backgroundMusicPlayer: AVAudioPlayer?
	public var soundEffectPlayer: AVAudioPlayer?
	
	public class func sharedInstance() -> SKTAudio {
		return SKTAudioInstance
	}
	
	public func playBackgroundMusic(filename: String) {
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
	
	public func resumeBackgroundMusic() {
		if let player = backgroundMusicPlayer {
			if !player.isPlaying {
				player.play()
			}
		}
	}
	
	public func playSoundEffect(filename: String) {
		let url = Bundle.main.url(forResource: filename, withExtension: nil)
		if (url == nil) {
			print("Could not find file: \(filename)")
			return
		}
		
		var error: NSError? = nil
		do {
			soundEffectPlayer = try AVAudioPlayer(contentsOf: url!)
		} catch let error1 as NSError {
			error = error1
			soundEffectPlayer = nil
		}
		if let player = soundEffectPlayer {
			player.numberOfLoops = 0
			player.prepareToPlay()
			player.play()
		} else {
			print("Could not create audio player: \(error!)")
		}
	}
}

private let SKTAudioInstance = SKTAudio()
