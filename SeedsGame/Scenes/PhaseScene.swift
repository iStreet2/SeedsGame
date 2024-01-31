//
// PhaseScene.swift
// SeedsGame
//
// Created by Paulo Sonzzini Ribeiro de Souza on 19/01/24.
//
import Foundation
import SpriteKit
class PhaseScene: GameScene {
	
	var clients: [ClientModel] = []
	
	//Vetor que vai armazenar todos os as hitboxes invisiveis
	var hitBoxes: [SKShapeNode] = []
	
	//Instancio um saco e um movableNode, que vai ser usado para mexer o saco
	var movableNode: SKNode?
	
	//Vetor que armazena a equação atual
	var currentSeedBags: [SeedBagModel] = []
	
	var currentEqLabel: SKLabelNode = SKLabelNode(text: "nil")
	var eqLabelBackground = SKSpriteNode(color: .gray, size: CGSize(width: 400, height: 50))
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
		
		currentEqLabel.position = CGPoint(x: 250, y: 320)
		currentEqLabel.zPosition = 1
		eqLabelBackground.position = currentEqLabel.position
		eqLabelBackground.position.y = currentEqLabel.position.y + 10
		eqLabelBackground.zPosition = 0
		
		addChild(currentEqLabel)
		addChild(eqLabelBackground)
		
		currentEqLabel.text = "\(clients[currentClientNumber].eq)"
		
		// MARK: Renderiza os 3 clientes
		GameEngine.shared.renderClients(scene: self)
	 //Adiciono o pacote de sementes na cena
	 GameEngine.shared.addSeedBags(scene: self)
	 //Para cada caracter na string da equação, eu crio um quadrado que ira receber sacos dentro dele
	 GameEngine.shared.addHitBoxesFromEquation(scene: self)
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		let hapticAction = HapticAction(1, 1)
		GameEngine.shared.receiveAction(hapticAction)
		
		guard let touch = touches.first else { return }
		
		if nextQuestionButton.contains(touch.location(in: self)) {
			GameEngine.shared.nextQuestion(scene: self)
		}
		if nextPhaseButton.contains(touch.location(in: self)) {
			GameEngine.shared.nextPhase(scene: self)
		}
		
		if joinSideButton.contains(touch.location(in: self)) {
			let opAction = OperationAction(eq: currentEqLabel.text!.contains("!") ? "" : currentEqLabel.text!)
			GameEngine.shared.receiveAction(opAction)
			animateLever()
		}
		
		if giveResponseButton.contains(touch.location(in: self)) {
			print("Equação deve ser avaliada!")
			GameEngine.shared.renderClientResponse(self)
		}
		
		//movimento do sprite de semente
		for (index,seedBag) in currentSeedBags.enumerated(){
			if !GameEngine.shared.operators.contains(seedBag.label.text!){ //Se não for um operador
				if seedBag.label.text! != "="{ //Se não for um igual
					if seedBag.label.text! != "0"{ //Se não for zero
						GameEngine.shared.moveSeedBag(seedBag, touches, stage: 0,initialPosition: index, scene: self)
					}
				}
			}
		if GameEngine.shared.operators.contains(seedBag.label.text!){ //Se for um operador
		  GameEngine.shared.invertOperator(seedBag,touches, index, self)
		}
		}
		
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for (index,seedBag) in currentSeedBags.enumerated(){
			GameEngine.shared.moveSeedBag(seedBag, touches, stage: 1, initialPosition: index, scene: self)
		}
		
	}
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for (index,seedBag) in currentSeedBags.enumerated(){
			GameEngine.shared.moveSeedBag(seedBag, touches, stage: 2, initialPosition: index, scene: self)
		}
		
	}
	
	
}
