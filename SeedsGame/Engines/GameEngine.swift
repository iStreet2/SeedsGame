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
	
	
	func nextPhase(scene: PhaseScene) {
		let reveal = SKTransition.reveal(with: .left, duration: 1)
		
		if currentPhase != phases.count - 1 {
			currentPhase += 1
			
			scene.scene?.view?.presentScene(GameEngine.shared.phases[GameEngine.shared.currentPhase], transition: reveal)
		}
		else {
			// cena após as 3 fases
			scene.currentEqLabel.text = "All phases done!"
		}
	}
	
	func nextQuestion(scene: PhaseScene) {
		
		let nQuestions = scene.clients.count
		
		for client in scene.clients {
			
			let scaleAction = SKAction.scale(by: 1.15, duration: 0.5)
			client.run(scaleAction)
			
			let moveAction = SKAction.moveTo(x: client.position.x - 75, duration: 0.5)
			client.run(moveAction)
			
			if client.eq == scene.clients[scene.currentClientNumber].eq {
				// Cliente da pergunta atual é despachado
				scene.removeChildren(in: [client])
			}
		}
		
		// renderiza o sprite do próximo cliente no final da fila
		if (scene.currentClientNumber + 3) <= (nQuestions - 1) {
			scene.addChild(scene.clients[scene.currentClientNumber + 3])
		}
		
		// não deixa o número do cliente atual ser maior do que o número de clientes
		if scene.currentClientNumber != nQuestions - 1 {
			scene.currentClientNumber += 1
			scene.currentEqLabel.text = "\(scene.clients[scene.currentClientNumber].eq)"
		}
		
		// se todos os clientes tiverem as suas perguntas resolvidas
		else {
			scene.currentEqLabel.text = "All questions done!"
		}
	}
	
	
	func renderClients(scene: PhaseScene) {
		for (index, client) in scene.clients.enumerated() {
			client.position = CGPoint(x: 564+(75*index), y: 235)
			client.size = CGSize(width: client.size.width - CGFloat(index*(15)), height: client.size.height - CGFloat(index*(30)))
			client.zPosition = CGFloat(scene.clients.count - index)
			
			if index<3 {
				scene.addChild(client)
			}
		}
		
		scene.currentEqLabel.text = "\(scene.clients[scene.currentClientNumber].eq)"
	}
	
	
	// Função para mexer algum nó
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
