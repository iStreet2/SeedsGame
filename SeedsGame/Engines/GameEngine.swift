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
		let response = action.execute()
		print(response)
		phases[currentPhase].currentEqLabel.text = response
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
		//Remover e readicionar as hitBoxes da equação
		addHitBoxes(scene: scene)
		addSeedBags(scene: scene)
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
					//Antes de deixar o movableNode em nil, eu chamo o grabNode, para que se o nó que o usuário estiver movendo, se prenda ao quadrado, se esse nó estive em cima do quadrado
					grabNode(node: node, touches: touches, scene: scene)
					scene.movableNode = nil
				}
			}
		}
	}
	
	func addHitBoxes(scene: PhaseScene){
		//Remover as hitBoxes da questão anterior
		if scene.hitBoxes.count != 0{
			for hitBox in scene.hitBoxes{
				scene.removeChildren(in: [hitBox])
			}
			scene.hitBoxes.removeAll()
		}
		
		//Adicionar no vetor novamente os nos dos quadrados
		for _ in scene.clients[scene.currentClientNumber].eq{
			let node = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
			scene.hitBoxes.append(node)
		}
		//Adicionar na cena as hitBoxes
		for (index,hitBox) in scene.hitBoxes.enumerated(){
			hitBox.position = CGPoint(x: 100+(50*index), y: 200)
			hitBox.strokeColor = .red
			scene.addChild(hitBox)
		}
	}
	
	func addSeedBags(scene: PhaseScene){
		
		if scene.currentSeedBags.count != 0{
			for seedBag in scene.currentSeedBags{
				scene.removeChildren(in: [seedBag])
				scene.removeChildren(in: [seedBag.label])
			}
			scene.currentSeedBags.removeAll()
		}
		for char in scene.clients[scene.currentClientNumber].eq{
			if char.isNumber{
				scene.currentSeedBags.append(SeedBagModel(numero: Int(String(char)) ?? 0, incognita: false, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: 50, height: 70))
				
			}else if char == "x"{
				scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: true, isOperator: false, operatorr: "", imageNamed: "seedbag", color: .clear, width: 50, height: 70))
			}else{
				scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: false, isOperator: true, operatorr: String(char), imageNamed: "nothing", color: .clear, width: 50, height: 70))
			}
		}
		
		for (index,seedBag) in scene.currentSeedBags.enumerated(){
			seedBag.position = CGPoint(x: 100+(50*index), y: 200) //Posicao da sacola com o numero, mexo com o index para colocar na posição certa da equação
			seedBag.label.position.x = seedBag.position.x
			seedBag.label.position.y = seedBag.position.y - 20
			
			scene.addChild(seedBag)
			scene.addChild(seedBag.label)
		}
		
	}
	
	
	func grabNode(node: SKSpriteNode, touches: Set<UITouch>, scene: PhaseScene){
		if let touch = touches.first{
			if scene.movableNode != nil{
				let location = touch.location(in: scene.self)
				for hitBox in scene.hitBoxes{
					if hitBox.contains(location){
						node.position = hitBox.position
					}
				}
			}
		}
	}
	
}
