//
// PhaseScene.swift
// SeedsGame
//
// Created by Paulo Sonzzini Ribeiro de Souza on 19/01/24.
//
import Foundation
import SpriteKit
import SwiftUI
import CoreData

class PhaseScene: GameScene {
    
    var phase: Int = 0
    
    var clients: [ClientModel] = []
    
    //Vetor que vai armazenar todos os as hitboxes invisiveis
    var hitBoxes: [SKShapeNode] = []
    
    //Instancio um saco e um movableNode, que vai ser usado para mexer o saco
    var movableNode: SKNode?
    
    //Vetor que armazena a equação atual
    var currentSeedBags: [SeedBagModel] = []
    
    var currentEqLabel: SKLabelNode = SKLabelNode(text: "nil")
    var eqLabelBackground = SKSpriteNode(imageNamed: "equationLabelBackground")
    //var eqLabelBackground = SKSpriteNode(color: .gray, size: CGSize(width: 400, height: 50))
    var currentClientNumber = 0
    
    var openedEquation = false
    
    let brilhinho = SKSpriteNode(imageNamed: "Brilhinho")
    
    var rightAnswerEqLabel: [SeedBagModel] = []
    var rightAnswerEqBackground = SKSpriteNode(imageNamed: "rightAnswerEqBackground")
    var rightAnswerShowed = false
    
    
    init(phase: Int, width: Double, height: Double) {
        
        super.init(size: CGSize(width: width, height: height))
        
        self.phase = phase
        
        eqLabelBackground.size = CGSize(width: 330, height: 110)
        brilhinho.size = CGSize(width: 159.68, height: 42.1)
        
        let clientMap: [Int: Int] = [1: phaseMap[1]!.count, 2: phaseMap[2]!.count, 3: phaseMap[3]!.count] //Inicializa as equações dos clientes
        
        let eqs = phaseMap[phase]
        
        //Para cada cliente no mapa
        for n in 0..<(clientMap[phase] ?? 0){
            let client = ClientModel(eqs![n].0, imageNamed: "ClientSprite", color: .clear) //CGSize(width: 135, height: 274) -> Size antigo
            clients.append(client)
        }
        self.isUserInteractionEnabled = true
    }
    
    

    override func didMove(to view: SKView) {
        
        startup()
        animateBlackHole()
        
        currentEqLabel.position = CGPoint(x: frame.size.width / 2, y: 325)
        currentEqLabel.zPosition = 1
        eqLabelBackground.position = currentEqLabel.position
        eqLabelBackground.position.y = currentEqLabel.position.y - 5
        eqLabelBackground.zPosition = 0
        
        if clients[0].wantsGalacticSeeds {
            eqLabelBackground.texture = SKTexture(imageNamed: "GalacticEquationLabelBackground")
        }
        addChild(currentEqLabel)
        addChild(eqLabelBackground)
        
        currentEqLabel.text = "\(clients[currentClientNumber].eq)"
        currentEqLabel.fontName = "AlegreyaSans-Medium"
        currentEqLabel.fontSize = 32
        currentEqLabel.fontColor = UIColor(Color("FontDarkBrown"))
        
        // MARK: Renderiza os 3 clientes
        GameEngine.shared.renderClients(scene: self)
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let hapticAction = HapticAction(1, 1)
        GameEngine.shared.receiveAction(hapticAction,self)
        
        guard let touch = touches.first else { return }
        
        //		if nextQuestionButton.contains(touch.location(in: self)) {
        //			GameEngine.shared.nextQuestion(scene: self)
        //		}
        //		if nextPhaseButton.contains(touch.location(in: self)) {
        //			GameEngine.shared.nextPhase(scene: self)
        //		}
        
        if rightAnswerShowed{ //Se a resposta corriga pelo cliente estiver aparecendo
            if let _ = touches.first?.location(in: view){ //ao tocar na tela
                //Remover o circulo de resposta e ir para a proxima questao
                GameEngine.shared.removeRightAnswer(self)
                GameEngine.shared.nextQuestion(scene: self, isTutorial: false)
            }
        }
        
        if openedEquation && !GameEngine.shared.finalSeedCreated{
            if joinSideButton.contains(touch.location(in: self)) {
                let oldEquation = currentEqLabel.text
                
                let opAction = OperationAction(eq: currentEqLabel.text!.contains("!") ? "" : currentEqLabel.text!)
                GameEngine.shared.mementoStack.push(currentEqLabel.text!)
                if GameEngine.shared.resultIsReady(self){
                    GameEngine.shared.createFinalSeedBag(self)
                }else{
                    GameEngine.shared.receiveAction(opAction,self)
                }
                animateLever()
                if oldEquation != currentEqLabel.text{
                    animateRegularPoof()
                }
            }
        }
        
        if eqLabelBackground.contains(touch.location(in: self)) {
            openedEquation = true
            GameEngine.shared.moveFirstClientToFront(self)
            GameEngine.shared.addSeedBags(scene: self)
            GameEngine.shared.addHitBoxesFromEquation(scene: self)
        }
        
        if restartEquationButton.contains(touch.location(in: self)) {
            GameEngine.shared.resetCurrentEquation(self)
            animateDestructiveButton()
            animateDestructivePoof()
            GameEngine.shared.finalSeedCreated = false
        }
        
        if undoButton.contains(touch.location(in: self)) {
            if GameEngine.shared.mementoStack.top() != "" {
                self.currentEqLabel.text = GameEngine.shared.mementoStack.pop()
                GameEngine.shared.finalSeedTransformed = false
                GameEngine.shared.addSeedBags(scene: self)
                GameEngine.shared.addHitBoxesFromEquation(scene: self)
                GameEngine.shared.finalSeedCreated = false
            }
            animateUndoButton()
            animateDestructivePoof()
        }
        
        //movimento do sprite de semente
        for (index,seedBag) in currentSeedBags.enumerated(){
            if seedBag.contains(touch.location(in: self)){ //Se a localização do touch estiver em algum saco de semente do vetor
                if !GameEngine.shared.operators.contains(seedBag.label.text!){ //Se não for um operador
                    if seedBag.label.text! != "="{ //Se não for um igual
                        if seedBag.label.text! != "0"{ //Se não for zero
									GameEngine.shared.moveSeedBag(seedBag, touches, stage: 0,initialPosition: index, scene: self, isTutorial: false)
                        }
                    }
                }
            }
            if GameEngine.shared.operators.contains(seedBag.label.text!){ //Se for um operador, inverto o operador
                GameEngine.shared.invertOperator(seedBag,touches, index, self)
            }
            
        }
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for (index,seedBag) in currentSeedBags.enumerated(){
			  GameEngine.shared.moveSeedBag(seedBag, touches, stage: 1, initialPosition: index, scene: self, isTutorial: false)
        }
	}
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for (index,seedBag) in currentSeedBags.enumerated(){
			GameEngine.shared.moveSeedBag(seedBag, touches, stage: 2, initialPosition: index, scene: self, isTutorial: false)
		}
		
	}
	
	

}
