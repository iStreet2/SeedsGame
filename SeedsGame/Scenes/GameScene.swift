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
		1: [("x+10=10+3", 3), ("x+10=2x", 9), ("3x+2*9=0", -6)],
		2: [("17-2x=3", 7), ("30x-120=0", 4), ("2x+3x=15x-30", 3), ("14+2x=3+2", -4.5), ("5", 5)],
		3: [("1", 1), ("2", 2), ("3", 3), ("4", 4), ("5", 5), ("6", 6), ("7", 7), ("8", 8), ("9", 9), ("10", 10)]

	]
	
	
	let nextPhaseButton = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
	let nextQuestionButton = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
	var joinSideButton = SKSpriteNode(imageNamed: "Ala - Frame 1")
	var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Alavanca")
	let giveResponseButton = SKSpriteNode(imageNamed: "blackhole")
	
	override func didMove(to view: SKView) {
		startup()
	}
	
	
	func startup() {
    
		nextPhaseButton.position = CGPoint(x: frame.size.width - 100, y: 50)
		nextPhaseButton.zPosition = 12
		
		nextQuestionButton.position = CGPoint(x: frame.size.width - 200, y: 50)
		nextQuestionButton.zPosition = 12
		
		joinSideButton.position = CGPoint(x: frame.size.width - 100, y: frame.size.height / 3)
		joinSideButton.size = CGSize(width: 37.5, height: 160)
		joinSideButton.zPosition = 12
		
		giveResponseButton.position = CGPoint(x: frame.size.width / 2, y: 38)
		giveResponseButton.size = CGSize(width: 75, height: 75)
		giveResponseButton.zPosition = 12
		
		addChild(nextPhaseButton)
		addChild(nextQuestionButton)
		addChild(joinSideButton)
		addChild(giveResponseButton)
		
		bottomBackground.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 4)
		bottomBackground.zPosition = 11
		addChild(bottomBackground)
		
		topBackground.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - frame.size.height / 4)
		topBackground.zPosition = -1
		addChild(topBackground)
	}
	
	func animateLever() {
		let idleFrames: [SKTexture] = [textureAtlas.textureNamed("Ala - Frame 1"),
												 textureAtlas.textureNamed("Ala - Frame 2"),
												 textureAtlas.textureNamed("Ala - Frame 3"),
												 textureAtlas.textureNamed("Ala - Frame 4"),
												 textureAtlas.textureNamed("Ala - Frame 5"),
												 textureAtlas.textureNamed("Ala - Frame 6"),
												 textureAtlas.textureNamed("Ala - Frame 7"),
												 textureAtlas.textureNamed("Ala - Frame 8"),
												 textureAtlas.textureNamed("Ala - Frame 9"),
												 textureAtlas.textureNamed("Ala - Frame 10"),
												 textureAtlas.textureNamed("Ala - Frame 11"),
												 textureAtlas.textureNamed("Ala - Frame 12"),
												 textureAtlas.textureNamed("Ala - Frame 11"),
												 textureAtlas.textureNamed("Ala - Frame 10"),
												 textureAtlas.textureNamed("Ala - Frame 9"),
												 textureAtlas.textureNamed("Ala - Frame 8"),
												 textureAtlas.textureNamed("Ala - Frame 7"),
												 textureAtlas.textureNamed("Ala - Frame 6"),
												 textureAtlas.textureNamed("Ala - Frame 5"),
												 textureAtlas.textureNamed("Ala - Frame 4"),
												 textureAtlas.textureNamed("Ala - Frame 3"),
												 textureAtlas.textureNamed("Ala - Frame 2"),
												 textureAtlas.textureNamed("Ala - Frame 1"),
									]
		let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.03)
		joinSideButton.run(idleAction)
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


