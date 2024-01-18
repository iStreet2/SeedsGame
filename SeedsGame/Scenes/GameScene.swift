//
//  GameScene.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
	var blueBox = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
	
	override func didMove(to view: SKView) {
		startup()
	}
	
	
	func startup() {
		blueBox.position = CGPoint(x: 150, y: 200)
		addChild(blueBox)
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		
		if blueBox.contains(touch.location(in: self)) {
			print("Me tocou!")
		}
	}
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
	}
	
	
}

