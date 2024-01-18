//
//  SoundActionModel.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import AVFoundation

class SoundAction: Action {
	
	private var systemSoundID: Int
	
	
	init(_ systemSoundID: Int) {
		self.systemSoundID = systemSoundID
	}
	
	
	func execute() {
		let id = UInt32(systemSoundID)
		AudioServicesPlaySystemSound(id)
	}
	
	
}
