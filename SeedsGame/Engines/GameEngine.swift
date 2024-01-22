//
//  GameEngine.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import SwiftUI
import SpriteKit


@Observable class GameEngine {
	static let shared = GameEngine()
	
	let width = UIScreen.main.bounds.width
	let height = UIScreen.main.bounds.height
	
	var actions: [Action] = []
	var phases: [PhaseScene] = []
	var currentPhase = 0
	
	
	init() {
		let phases = [PhaseScene(phase: 1, width: width, height: height), PhaseScene(phase: 2, width: width, height: height)]
		self.phases = phases
	}
	
	
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
	
	
	func nextPhase(scene: SKScene) {
		currentPhase += 1
		let reveal = SKTransition.reveal(with: .left, duration: 1)
		scene.scene?.view?.presentScene(GameEngine.shared.phases[GameEngine.shared.currentPhase], transition: reveal)
	}
	
	func nextQuestion(scene: PhaseScene) {
		for client in scene.clients {
			if client.eq == scene.clients[scene.currentClientNumber].eq {
				// Cliente da pergunta atual é despachado
				scene.removeChildren(in: [client])
			}
		}
		
		scene.currentClientNumber += 1
		scene.currentEqLabel.text = "\(scene.clients[scene.currentClientNumber].eq)"
        
        
        //Remover as hitBoxes da questão anterior
        for hitBox in scene.hitBoxes{
            scene.removeChildren(in: [hitBox])
            scene.hitBoxes.removeAll()
        }
        
        //Adicionar no vetor novamente os nos dos quadrados
        for _ in scene.clients[scene.currentClientNumber].eq{
            let node = SKShapeNode(rectOf: CGSize(width: 10, height: 10))
            scene.hitBoxes.append(node)
        }
        //Adicionar na cena as hitBoxes
        for (index,hitBox) in scene.hitBoxes.enumerated(){
            hitBox.position = CGPoint(x: 100+(15*index), y: 200)
            hitBox.strokeColor = .red
            scene.addChild(hitBox)
        }
        
	}
	
	
	//Função para mexer algum nó
	func moveNode(_ node: SKSpriteNode, _ touches: Set<UITouch>, stage: Int, scene: PhaseScene){
		if stage == 0{
			if let touch = touches.first{
				let location = touch.location(in: scene.self)
				if node.contains(location){
					scene.movableNode = node
					scene.movableNode!.position = location
				}
			}
		}else if stage == 1{
			if let touch = touches.first {
				if scene.movableNode != nil{
					scene.movableNode!.position = touch.location(in: scene.self)
				}
			}
		}else if stage == 2{
			if let touch = touches.first {
				if scene.movableNode != nil{
					scene.movableNode!.position = touch.location(in: scene.self)
					scene.movableNode = nil
				}
			}
		}
	}
	
	
}
