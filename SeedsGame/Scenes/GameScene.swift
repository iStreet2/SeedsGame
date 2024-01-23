//
//  GameScene.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene {

	var phaseMap: [Int : [(String, Float)]] = [
		1: [("x+3=2", -1), ("4-4=x-2", 2), ("3x+2*9=0", -6)],
		2: [("lara", 1.65), ("eh", 3.4), ("legal", 3.14), ("4", 4), ("5", 5)],
		3: [("1", 1), ("2", 2), ("3", 3), ("4", 4), ("5", 5), ("6", 6), ("7", 7), ("8", 8), ("9", 9), ("10", 10)]
	]

	
	let nextPhaseButton = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
	let nextQuestionButton = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
	let joinSideButton = SKSpriteNode(color: .yellow, size: CGSize(width: 50, height: 50))
	
	override func didMove(to view: SKView) {
		startup()
	}
	
	
	func startup() {
		nextPhaseButton.position = CGPoint(x: 200, y: 100)
		nextQuestionButton.position = CGPoint(x: 300, y: 100)
		joinSideButton.position = CGPoint(x: 400, y: 100)
		addChild(nextPhaseButton)
		addChild(nextQuestionButton)
		addChild(joinSideButton)
	}

}

// [2x]

// ["..", +, 5]
// [.., +, .....]
// "\(eq[].count)x"

// [.., - , 4, =, -, ....., +, 10] -> Joga
// [.., +, ..... =, +, 10, +, 4] -> Botao
// [......., =, 14] -> Joga
// [., = 14, /, 7] -> Botao
// [., =, 2] -> Joga o saco no buraco negro pro pássaro


