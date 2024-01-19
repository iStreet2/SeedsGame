//
//  GameScene.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
	
	var map: [Int : [String]] = [
		1: ["x+3=2", "4-4=x-2", "3x+2*8=0"],
		2: ["paulo", "eh", "legal", "4", "5"],
		3: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
	]
	
	let nextPhaseButton = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
	
	
	override func didMove(to view: SKView) {
		startup()
	}
	
	
	func startup() {
		nextPhaseButton.position = CGPoint(x: 200, y: 100)
		addChild(nextPhaseButton)
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		
		if nextPhaseButton.contains(touch.location(in: self)) {
			print("Before \(GameEngine.shared.currentPhase)")
			let reveal = SKTransition.reveal(with: .left, duration: 1)
			print("After \(GameEngine.shared.currentPhase)")
			
			scene?.view?.presentScene(GameEngine.shared.phases[GameEngine.shared.currentPhase], transition: reveal)
		}
		
	}
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
	}
	
	
}

