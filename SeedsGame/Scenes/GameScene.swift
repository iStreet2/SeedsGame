//
//  GameScene.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene {

	var bottomBackground = SKSpriteNode(imageNamed: "bottomSceneBackground")
	var topBackground = SKSpriteNode(imageNamed: "topSceneBackground")

	var phaseMap: [Int : [(String, Float)]] = [
		1: [("4-4=x", -1), ("4-4=x-2", 2), ("3x+2*9=0", -6)],
		2: [("lara", 1.65), ("eh", 3.4), ("legal", 3.14), ("4", 4), ("5", 5)],
		3: [("1", 1), ("2", 2), ("3", 3), ("4", 4), ("5", 5), ("6", 6), ("7", 7), ("8", 8), ("9", 9), ("10", 10)]
	]
	
	// scene.phaseMap[clientNumber+1][]

	
	let nextPhaseButton = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
	let nextQuestionButton = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
	let joinSideButton = SKSpriteNode(color: .yellow, size: CGSize(width: 50, height: 50))
	let giveResponseButton = SKSpriteNode(imageNamed: "blackhole")
	
	override func didMove(to view: SKView) {
		startup()
	}
	
	
	func startup() {
		nextPhaseButton.position = CGPoint(x: 200, y: 100)
		nextPhaseButton.zPosition = 11
		
		nextQuestionButton.position = CGPoint(x: 300, y: 100)
		nextQuestionButton.zPosition = 11
		
		joinSideButton.position = CGPoint(x: frame.size.width - 100, y: frame.size.height / 3)
		joinSideButton.zPosition = 11
		
		giveResponseButton.position = CGPoint(x: frame.size.width / 2, y: 38)
		giveResponseButton.size = CGSize(width: 75, height: 75)
		giveResponseButton.zPosition = 11
		
		addChild(nextPhaseButton)
		addChild(nextQuestionButton)
		addChild(joinSideButton)
		addChild(giveResponseButton)
		
		bottomBackground.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 4)
		bottomBackground.zPosition = 10
		addChild(bottomBackground)
		
		topBackground.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - frame.size.height / 4)
		topBackground.zPosition = -1
		addChild(topBackground)
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


