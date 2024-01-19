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
    
    //Teste para mexer 1 saco de semente
    let seedBag = SeedBagModel(numero: 3, incognita: false, imageNamed: "seedbag", color: .clear, width: 50, height: 70)
    var movableNode: SKNode?
    
    override func didMove(to view: SKView) {
        startup()
    }
    
    //Função para mexer algum nó
    func moveNode(_ node: SKSpriteNode, _ touches: Set<UITouch>, stage: Int){
        if stage == 0{
            if let touch = touches.first{
                let location = touch.location(in: self)
                if node.contains(location){
                    movableNode = node
                    movableNode!.position = location
                }
            }
        }else if stage == 1{
            if let touch = touches.first {
                if movableNode != nil{
                    movableNode!.position = touch.location(in: self)
                }
            }
        }else if stage == 2{
            if let touch = touches.first {
                if movableNode != nil{
                    movableNode!.position = touch.location(in: self)
                    movableNode = nil
                }
            }
        }
    }
    
    
    func startup() {
//        nextPhaseButton.position = CGPoint(x: 200, y: 100)
//        addChild(nextPhaseButton)
        
        //Testes com hitBox
        seedBag.position = CGPoint(x: 500, y: 100)
        addChild(seedBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //botão trocar de fase
        guard let touch = touches.first else { return }
        
        if nextPhaseButton.contains(touch.location(in: self)) {
            GameEngine.shared.currentPhase += 1
            print("Before \(GameEngine.shared.currentPhase)")
            let reveal = SKTransition.reveal(with: .left, duration: 1)
            print("After \(GameEngine.shared.currentPhase)")
            
            scene?.view?.presentScene(GameEngine.shared.phases[GameEngine.shared.currentPhase], transition: reveal)
        }
        
        //movimento do sprite de semente
        moveNode(seedBag, touches, stage: 0)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveNode(seedBag, touches, stage: 1)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveNode(seedBag, touches, stage: 2)
    }
    
    
}

