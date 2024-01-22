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
    
    
    
    //Vetor que vai armazenar todos os as hitboxes invisiveis
    var hitBoxes: [SKShapeNode] = []
    
    //Teste para mexer 1 saco de semente, instancio um saco e um movableNode, que vai ser usado para mexer o saco
    let seedBag = SeedBagModel(numero: 3, incognita: false, imageNamed: "seedbag", color: .clear, width: 50, height: 70)
    var movableNode: SKNode?
    
    var currentEqLabel: SKLabelNode = SKLabelNode(text: "nil")
    var currentClientNumber = 0
    
    
    
    init(phase: Int, width: Double, height: Double) {
        
        super.init(size: CGSize(width: width, height: height))
        
        
        let clientMap: [Int: Int] = [1: phaseMap[1]!.count, 2: phaseMap[2]!.count, 3: phaseMap[3]!.count] //Inicializa as equações dos clientes
        
        let eqs = phaseMap[phase]
        
        //Para cada cliente no mapa
        for n in 0..<clientMap[phase]! {
            
            
            
            //Para cada caracter na string da equação, eu crio um quadrado que ira receber sacos dentro dele
            for _ in eqs![n]{
                let node = SKShapeNode(rectOf: CGSize(width: 10, height: 10))
                hitBoxes.append(node)
            }
            //PROXIMO PASSO: DIMINUIR O TAMANHO DOS QUADRADOS E CRIAR FUNCAO PARA O SACO GRUDAR NELES! E TAMBEM SEMPRE ACOMPANHAR A QUANTIDADE DE ELEMENTOS DA EQUACAO!!! ACHO QUE TA MOSTRANDO A QUANTIDADE DE QUADRADOS A QUANTIDADE DE CARACTERES DA FASE, NAO DA EQUACAO ATUAL
            let client = ClientModel(eqs![n], imageNamed: "ClientSprite", color: .clear, size: CGSize(width: 135, height: 274))
            clients.append(client)
            
        }
        
        
        self.isUserInteractionEnabled = true
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
    
    override func didMove(to view: SKView) {
        
        startup()
        
        //		for (index, client) in clients.enumerated() {
        //			client.position = CGPoint(x: 100, y: 100+(150*index))
        //
        //			let label = SKLabelNode(text: client.eq)
        //			label.position.x = client.position.x
        //			label.position.y = client.position.y + 50
        //			addChild(label)
        //		}
        //Testes com hitBox
        seedBag.position = CGPoint(x: 500, y: 100)
        addChild(seedBag)
        
        for (index,hitBox) in hitBoxes.enumerated(){
            hitBox.position = CGPoint(x: 100+(15*index), y: 100)
            hitBox.strokeColor = .red
            addChild(hitBox)
        }
        
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if nextQuestionButton.contains(touch.location(in: self)) {
            GameEngine.shared.nextQuestion(scene: self)
        }
        if nextPhaseButton.contains(touch.location(in: self)) {
            GameEngine.shared.nextPhase(scene: self)
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
