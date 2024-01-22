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
    var currentSeedBags: [SeedBagModel] = []
    var operators: [String] = []
    
    var currentEqLabel: SKLabelNode = SKLabelNode(text: "nil")
    var currentClientNumber = 0
    
    
    
    init(phase: Int, width: Double, height: Double) {
        
        super.init(size: CGSize(width: width, height: height))
        
        
        let clientMap: [Int: Int] = [1: phaseMap[1]!.count, 2: phaseMap[2]!.count, 3: phaseMap[3]!.count] //Inicializa as equações dos clientes
        
        let eqs = phaseMap[phase]
        
        //Para cada cliente no mapa
        for n in 0..<clientMap[phase]! {
            let client = ClientModel(eqs![n].0, imageNamed: "ClientSprite", color: .clear, size: CGSize(width: 135, height: 274))
            clients.append(client)
        }
        self.isUserInteractionEnabled = true
    }
    
    
    
    override func didMove(to view: SKView) {
        
        startup()
        
        GameEngine.shared.addSeedBags(scene: self)
        //Adiciono o pacote de sementes na cena
        seedBag.position = CGPoint(x: 500, y: 100)
        addChild(seedBag)
        
        //Para cada caracter na string da equação, eu crio um quadrado que ira receber sacos dentro dele
        GameEngine.shared.addHitBoxes(scene: self)
        
        currentEqLabel.position = CGPoint(x: 250, y: 250)
        addChild(currentEqLabel)
        
        currentEqLabel.text = "\(clients[currentClientNumber].eq)"
      
        // MARK: Renderiza os 3 clientes
		    GameEngine.shared.renderClients(scene: self)
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
        GameEngine.shared.moveNode(seedBag, touches, stage: 0, scene: self)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        GameEngine.shared.moveNode(seedBag, touches, stage: 1, scene: self)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        GameEngine.shared.moveNode(seedBag, touches, stage: 2, scene: self)
    }

}
