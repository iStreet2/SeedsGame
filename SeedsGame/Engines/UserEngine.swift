//
//  UserEngine.swift
//  SeedsGame
//
//  Created by Marina Martin on 01/02/24.
//
//  Classe que guarda as informações que o usuário tem/quer saber

import Foundation
import SpriteKit

class UserEngine: ObservableObject{
	
	static let shared = UserEngine()
	
	@Published var life: Int = 3
	@Published var score: Int = 0
	@Published var lost: Bool = false
	
	
	func rightAnswerRightGalactic() {
		score += 100
	}
	func rightAnswerWrongGalactic() {
		score += 75
	}
	func wrongAnswerWrongGalactic() {
		life -= 1
	}
	func wrongAnswerRightGalactic() {
		score += 25
		life -= 1
	}
	
	
	func rightAnswerRoseNoGalactic() {
		score += 200
	}
	func wrongAnswerRoseNoGalactic() {
		score += 25
		life -= 1
	}
	func gaveGalacticSeedsToRose() {
		life = 0
	}
	
	
	func bhasIsLost() {
		self.lost = true
	}
	
	
	func resetUser() {
		self.life = 3
		self.score = 0
		self.lost = false
	}

	
}
