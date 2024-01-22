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
        
        //Remover e readicionar as hitBoxes da equação
        addHitBoxes(scene: scene)
        addSeedBags(scene: scene)
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
                scene.hitBoxes.removeAll()
            }
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
            scene.currentSeedBags.removeAll()
        }
        //eu to armazenando em dois vetores diferentes valores e operandos, nao sabendo como eu vou ter controle sobre isso para adicionar nos quadrados que eu mostro na tela!
        
        //O for faz isso:
        //3x+2*9=0 (exemplo de equação de cliente)
        // [3] [x] [2] [9] [0]
        // [+] [*] [=]
        for (index,char) in scene.clients[scene.currentClientNumber].eq.enumerated(){
            if char.isNumber{
                scene.currentSeedBags.append(SeedBagModel(numero: Int(String(char)) ?? 0, incognita: false, imageNamed: "seedbag", color: .clear, width: 50, height: 70))
            }else if char == "x"{
                scene.currentSeedBags.append(SeedBagModel(numero: 0, incognita: true, imageNamed: "seedbag", color: .clear, width: 50, height: 70))
            }else{
                scene.operators.append(String(char))
            }
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
