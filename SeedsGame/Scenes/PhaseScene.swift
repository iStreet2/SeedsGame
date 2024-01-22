//
//  PhaseScene.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/01/24.
//

import Foundation
import SpriteKit

class PhaseScene: GameScene {
	
	var clients: [ClientModel] = []
	var currentEqLabel: SKLabelNode = SKLabelNode(text: "nil")
	var currentClientNumber = 0
	
	
	init(phase: Int, width: Double, height: Double) {
		
		super.init(size: CGSize(width: width, height: height))
		
		let clientMap: [Int: Int] = [1: phaseMap[1]!.count, 2: phaseMap[2]!.count, 3: phaseMap[3]!.count]
		let eqs = phaseMap[phase]
			
		for n in 0..<clientMap[phase]! {
			
			let client = ClientModel(eqs![n], imageNamed: "ClientSprite", color: .clear, size: CGSize(width: 135, height: 274))
			clients.append(client)
		}
		
		self.isUserInteractionEnabled = true
	}
	
	
	override func didMove(to view: SKView) {
		
		startup()
		
		currentEqLabel.position = CGPoint(x: 250, y: 250)
		addChild(currentEqLabel)
		
		for (index, client) in clients.enumerated() {
			client.position = CGPoint(x: 564+(75*index), y: 235-(25*index))
			
			if index<3 {
				addChild(client)
			}
		}
		
		currentEqLabel.text = "\(clients[currentClientNumber].eq)"
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		
		if nextQuestionButton.contains(touch.location(in: self)) {
			GameEngine.shared.nextQuestion(scene: self)
		}
		
		if nextPhaseButton.contains(touch.location(in: self)) {
			GameEngine.shared.nextPhase(scene: self)
		}
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
