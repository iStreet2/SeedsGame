//
//  TutorialPhase.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 08/02/24.
//

import Foundation
import SpriteKit
import SwiftUI

class TutorialPhase: PhaseScene {
	
	static let shared = TutorialPhase(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
	
	var tutorialClient = TutorialClientModel()
	
	var currentFala: Int = 0
	var isPlaying: Bool = false
	
	var equation: String = ""
	
	
	init(width: Double, height: Double) {
		super.init(phase: 0, width: width, height: height)
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func didMove(to view: SKView) {
		startup()
		animateBlackHole()
		currentEqLabel.position = CGPoint(x: frame.size.width / 2, y: 300)
		currentEqLabel.zPosition = 1
		eqLabelBackground.position = currentEqLabel.position
		eqLabelBackground.position.y = currentEqLabel.position.y + 20
		eqLabelBackground.zPosition = 0
		
		addChild(currentEqLabel)
		addChild(eqLabelBackground)
		
		currentEqLabel.text = "\(tutorialClient.falas[currentFala])"
		equation = currentEqLabel.text!
		currentEqLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
		currentEqLabel.numberOfLines = 2
		currentEqLabel.fontName = "AlegreyaSans-Medium"
		currentEqLabel.fontSize = 24
		currentEqLabel.fontColor = UIColor(Color("FontDarkBrown"))
		
		let positionX = Int(0.786 * UIScreen.main.bounds.width)
		let positionY = Int(0.602 * UIScreen.main.bounds.height)
		
		tutorialClient.position = CGPoint(x: positionX, y: positionY)
		addChild(tutorialClient)
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		
		if eqLabelBackground.contains(touch.location(in: self)) {
			if !isPlaying && currentFala < tutorialClient.falas.count - 1 {

				currentFala += 1
				currentEqLabel.text = "\(tutorialClient.falas[currentFala])"
				
				// adiciona as seedbags da equação do tutorial
				if currentFala == 4 {
					GameEngine.shared.tutorialAddSeedBags(scene: self, isTutorial: true)
					GameEngine.shared.addHitBoxesFromEquation(scene: self)
				}
				
				// Fala de "leve o tempo que for preciso para resolver essa equação"
				// precisa habilitar o movimento dos sacos
				if currentFala == 11 || currentFala == 17 {
					isPlaying = true
				} else {
					isPlaying = false
				}
				
				if currentFala == 16 {
					eqLabelBackground.texture = SKTexture(imageNamed: "GalacticEquationLabelBackground")
					currentEqLabel.fontColor = UIColor(Color("FontLightBrown"))
				}
                
                if currentFala == tutorialClient.falas.count-1{
                    GameEngine.shared.setEndOfPhaseTRUE()
                    GameEngine.shared.finalSeedCreated = false
                    GameEngine.shared.mementoStack.clear()
                }
				
				
			}
//			else if seedBagWasGiven {
//				currentEqLabel.text = TutorialClientModel.shared.rightAnswerFala
//			}
		}
		
		// Alavanca só funciona quando o pintinho chegou na fala 11
		if joinSideButton.contains(touch.location(in: self)) {
			
			if isPlaying {
				let opAction = OperationAction(eq: self.tutorialClient.eq)
				GameEngine.shared.mementoStack.push(self.tutorialClient.eq)
				if GameEngine.shared.resultIsReady(self){
					GameEngine.shared.tutorialCreateFinalSeedBag(scene: self)
					if currentFala == 11 {
						GameEngine.shared.tutorialRenderClientResponse(self, node: self.tutorialClient)
						isPlaying = false
					} else {
						GameEngine.shared.tutorialRenderGalacticClientResponse(self, node: self.tutorialClient)
						isPlaying = false
					}
					isPlaying = false
				}else{
					GameEngine.shared.tutorialReceiveAction(opAction, self, isTutorial: true)
				}
			}
			animateLever()
            animateRegularPoof()
		}
		
		
		if undoButton.contains(touch.location(in: self)) {
			if isPlaying {
				if GameEngine.shared.mementoStack.top() != "" {
					self.tutorialClient.eq = GameEngine.shared.mementoStack.pop()
					GameEngine.shared.finalSeedTransformed = false
					GameEngine.shared.tutorialAddSeedBags(scene: self, isTutorial: true)
					GameEngine.shared.addHitBoxesFromEquation(scene: self)
				}
			}
			animateUndoButton()
            animateDestructivePoof()
		}
		
		if restartEquationButton.contains(touch.location(in: self)) {
			if isPlaying {
				GameEngine.shared.tutorialResetCurrentEquation(scene: self, isTutorial: true)
			}
			animateDestructiveButton()
            animateDestructivePoof()
		}
		
		//movimento do sprite de semente
		if isPlaying {
			for (index,seedBag) in currentSeedBags.enumerated(){
				if seedBag.contains(touch.location(in: self)) { //Se a localização do touch estiver em algum saco de semente do vetor
					if !GameEngine.shared.operators.contains(seedBag.label.text!){ //Se não for um operador
						if seedBag.label.text! != "="{ //Se não for um igual
							if seedBag.label.text! != "0"{ //Se não for zero
								GameEngine.shared.tutorialMoveSeedBag(seedBag, touches, stage: 0,initialPosition: index, scene: self, isTutorial: true)
							}
						}
					}
				}
				if GameEngine.shared.operators.contains(seedBag.label.text!){ //Se for um operador, inverto o operador
					GameEngine.shared.tutorialInvertOperator(seedBag,touches, index, self, isTutorial: true)
				}
				
			}
		}
		
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		  for (index,seedBag) in currentSeedBags.enumerated(){
			  GameEngine.shared.tutorialMoveSeedBag(seedBag, touches, stage: 1, initialPosition: index, scene: self, isTutorial: true)
		  }
	}
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for (index,seedBag) in currentSeedBags.enumerated(){
			GameEngine.shared.tutorialMoveSeedBag(seedBag, touches, stage: 2, initialPosition: index, scene: self, isTutorial: true)
		}
		
	}
	
	
	func gotRightResponse() {
		self.currentEqLabel.text = "\(TutorialClientModel.shared.rightAnswerFala)"
		self.isPlaying = false
	}
	
	
	func gotWrongResponse() {
		self.currentEqLabel.text = "\(TutorialClientModel.shared.wrongAnswerFala)"
		self.isPlaying = false
	}
	
	
}
