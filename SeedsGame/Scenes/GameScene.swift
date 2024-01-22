//
//  GameScene.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
	
	var phaseMap: [Int : [String]] = [
		1: ["x+3=2", "4-4=x-2", "3x+2*8=0"],
		2: ["lara", "eh", "legal", "4", "5"],
		3: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
	]
	
	let nextPhaseButton = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
	let nextQuestionButton = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
	
	override func didMove(to view: SKView) {
		startup()
	}
	
	
	func startup() {
		nextPhaseButton.position = CGPoint(x: 200, y: 100)
		nextQuestionButton.position = CGPoint(x: 300, y: 100)
		addChild(nextPhaseButton)
		addChild(nextQuestionButton)
	}
	
	
}

