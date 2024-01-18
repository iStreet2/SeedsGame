//
//  GameEngine.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation

@Observable class GameEngine {
	
	var actions: [Action] = []
	
	
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
