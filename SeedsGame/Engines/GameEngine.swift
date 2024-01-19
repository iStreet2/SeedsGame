//
//  GameEngine.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import SwiftUI
import SpriteKit


@Observable class GameEngine {
	static let shared = GameEngine()
	
	let width = UIScreen.main.bounds.width
	let height = UIScreen.main.bounds.height
	
	var actions: [Action] = []
	var phases: [PhaseScene] = []
//	var scene: SKScene
	var currentPhase = 0
	
	
	init() {
		let phases = [PhaseScene(phase: 1, width: width, height: height), PhaseScene(phase: 2, width: width, height: height)]
		self.phases = phases
//		self.scene = phases[0]
	}
	
	
	func receiveAction(_ action: Action) {
		actions.append(action)
		action.execute()
	}
	
	
	func clearActions() {
		actions.removeAll()
	}
	
	
	func getActions() -> [Action] {
		return actions
	}
	
	
	
	
}
