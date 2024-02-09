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
        self.score += 100
	}
	func rightAnswerWrongGalactic() {
        self.score += 75
	}
	func wrongAnswerWrongGalactic() {
        self.life -= 1
	}
	func wrongAnswerRightGalactic() {
        self.score += 25
        self.life -= 1
	}
	
	
	func rightAnswerRoseNoGalactic() {
        self.score += 200
	}
	func wrongAnswerRoseNoGalactic() {
        self.score += 25
        self.life -= 1
	}
	func gaveGalacticSeedsToRose() {
        self.life = 0
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
