//
//  GameScene.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/01/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
	
	var bottomBackground = SKSpriteNode(imageNamed: "Bancada")
	var topBackground = SKSpriteNode(imageNamed: "Fundo Provisorio")
	
    var phaseMap: [Int : [(String, Float)]] = [
        1: [("9-x=4", 5), ("2x=4", 2), ("x+2=3", 1), ("9-x=4", 5), ("x+6=15", 9), ("90-x=50", 40), ("5=-x+4", -1), ("20=x-40", 60), ("8+x=17",9), ("x+3=-12", -15)],
        2: [("10+x=-30", -40), ("x+2=-4", -6), ("17-x=3", 14), ("30x-120=0", 4), ("x=15x-28", 2), ("14+2x=6", -4), ("5x-12=3", 3), ("2x+2=60", 29), ("-x+5=x+7", -2), ("6x+3=-9", -2)],
        3: [("4x-10=x-7", 1), ("x+4=2x+6", -2), ("7x-40=x+20",10), ("9x-20=x-12", 1), ("3x+2=4x-1", 3), ("3x+1=x+29", 15), ("3x+1=x-3", -2), ("6x=2x+40", 10), ("(4x)/2=x-7", -7), ("5x+2=(6-8x)/2", 2)]
       ]
	
	//let nextPhaseButton = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
	//let nextQuestionButton = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
	
	var joinSideButton = SKSpriteNode(imageNamed: "Ala - Frame 1")
	var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Alavanca")
	
	let undoButton = SKSpriteNode(imageNamed: "UndoButton")
	let undoButtonTextureAtlas = SKTextureAtlas(named: "UndoButtonAssets")
	let blackHole = SKSpriteNode(imageNamed: "BH1")
    var deliveryPlace = SKSpriteNode()
    
    var regularPoofAtlas: SKTextureAtlas = SKTextureAtlas(named: "PoofNormal")
    var regularPoof = SKSpriteNode(imageNamed: "nothing")
    
    var destructivePoofAtlas = SKTextureAtlas(named: "PoofDestrutivo")
    var destructivePoof = SKSpriteNode(imageNamed: "nothing")
    
    var purplePoofAtlas = SKTextureAtlas(named: "PoofRoxo")
    var purplePoof = SKSpriteNode(imageNamed: "nothing")
    
    var blackHoleAtlas = SKTextureAtlas(named: "FramesBuracoNegro")
	
	
	let restartEquationButton = SKSpriteNode(imageNamed: "DestructiveButton")
	var destructiveButtonTextureAtlas: SKTextureAtlas = SKTextureAtlas(named: "DestructiveButtonAssets")
	
	
	func startup() {
		if children.isEmpty {
			print("Sem filhos!")
			let width = frame.size.width
			let height = frame.size.height
			
			//nextPhaseButton.position = CGPoint(x: frame.size.width - 100, y: 50)
			//nextPhaseButton.zPosition = 12
			
			//nextQuestionButton.position = CGPoint(x: frame.size.width - 200, y: 50)
			//nextQuestionButton.zPosition = 12
			
			joinSideButton.position = CGPoint(x: frame.size.width - 80, y: frame.size.height / 3)
			joinSideButton.size = CGSize(width: 209.73, height: 160.24)
			joinSideButton.zPosition = 12
            
            regularPoof.position = CGPoint(x: 400, y: 130)
            regularPoof.size = CGSize(width: 739.88, height: 252.98)
            regularPoof.zPosition = 13
            
            destructivePoof.position = CGPoint(x: 400, y: 130)
            destructivePoof.size = CGSize(width: 739.88, height: 252.98)
            destructivePoof.zPosition = 13
			
            purplePoof.position = CGPoint(x: 400, y: 130)
            purplePoof.size = CGSize(width: 739.88, height: 252.98)
            purplePoof.zPosition = 13
			
			blackHole.position = CGPoint(x: (frame.size.width / 2)+15, y: 5)
			blackHole.size = CGSize(width: 446.45, height: 136.79)
			blackHole.zPosition = 12
            
			
			deliveryPlace.position = CGPoint(x: (width/2)-10, y: (height/2)+150)
			deliveryPlace.zPosition = 12
			deliveryPlace.size = CGSize(width: 125.71, height: 260)
			deliveryPlace.color = .clear
			
			//addChild(nextPhaseButton)
			//addChild(nextQuestionButton)
			addChild(joinSideButton)
			addChild(blackHole)
			addChild(deliveryPlace)
            addChild(regularPoof)
            addChild(destructivePoof)
            addChild(purplePoof)
			
			bottomBackground.position = CGPoint(x: width / 2, y: frame.size.height / 4)
			bottomBackground.zPosition = 11
			addChild(bottomBackground)
			
			topBackground.position = CGPoint(x: width / 2, y: frame.size.height - frame.size.height / 4)
			topBackground.zPosition = -1
			addChild(topBackground)
			
			restartEquationButton.position = CGPoint(x: 10, y: 50)
			restartEquationButton.size = CGSize(width: 170.74, height: 63.19)
			restartEquationButton.zPosition = 12
			addChild(restartEquationButton)
			
			undoButton.position = CGPoint(x: 15, y: 140)
			undoButton.size = CGSize(width: 167.66, height: 94.78)
			undoButton.zPosition = 12
			addChild(undoButton)

		}
		else {
			print("Tem filhos!:")
			for child in children {
				print("Filho: \(child.description)")
			}
		}
	}
	
	func animateLever() {
		let idleFrames: [SKTexture] = [textureAtlas.textureNamed("Ala - Frame 2"),
                                       textureAtlas.textureNamed("Ala - Frame 3"),
                                       textureAtlas.textureNamed("Ala - Frame 4"),
                                       textureAtlas.textureNamed("Ala - Frame 5"),
                                       textureAtlas.textureNamed("Ala - Frame 6"),
                                       textureAtlas.textureNamed("Ala - Frame 7"),
                                       textureAtlas.textureNamed("Ala - Frame 8"),
                                       textureAtlas.textureNamed("Ala - Frame 9"),
                                       textureAtlas.textureNamed("Ala - Frame 10"),
                                       textureAtlas.textureNamed("Ala - Frame 11"),
                                       textureAtlas.textureNamed("Ala - Frame 12"),
                                       textureAtlas.textureNamed("Ala - Frame 12"),
                                       textureAtlas.textureNamed("Ala - Frame 11"),
                                       textureAtlas.textureNamed("Ala - Frame 10"),
                                       textureAtlas.textureNamed("Ala - Frame 9"),
                                       textureAtlas.textureNamed("Ala - Frame 8"),
                                       textureAtlas.textureNamed("Ala - Frame 7"),
                                       textureAtlas.textureNamed("Ala - Frame 6"),
                                       textureAtlas.textureNamed("Ala - Frame 5"),
                                       textureAtlas.textureNamed("Ala - Frame 4"),
                                       textureAtlas.textureNamed("Ala - Frame 3"),
                                       textureAtlas.textureNamed("Ala - Frame 2"),
                                       textureAtlas.textureNamed("Ala - Frame 1"),
									]
		let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.041)
        joinSideButton.run(idleAction)
	}
    
    func animateRegularPoof() {
        let idleFrames: [SKTexture] = [regularPoofAtlas.textureNamed("poof1"),
                                       regularPoofAtlas.textureNamed("poof2"),
                                       regularPoofAtlas.textureNamed("poof3"),
                                       regularPoofAtlas.textureNamed("poof4"),
                                       regularPoofAtlas.textureNamed("poof5"),
                                       regularPoofAtlas.textureNamed("poof6"),
                                       regularPoofAtlas.textureNamed("poof7"),
                                       regularPoofAtlas.textureNamed("poof8"),
                                       regularPoofAtlas.textureNamed("poof9"),
                                       regularPoofAtlas.textureNamed("poof10"),
                                       regularPoofAtlas.textureNamed("poof11"),
                                       regularPoofAtlas.textureNamed("poof12"),
                                       regularPoofAtlas.textureNamed("poof13"),
                                       regularPoofAtlas.textureNamed("poof14"),
                                       regularPoofAtlas.textureNamed("poof15"),
                                       regularPoofAtlas.textureNamed("nothingNormal")
                                    ]
        let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.07)
        regularPoof.run(idleAction)
    }
    
    func animateDestructivePoof() {
        let idleFrames: [SKTexture] = [destructivePoofAtlas.textureNamed("poof1D"),
                                       destructivePoofAtlas.textureNamed("poof2D"),
                                       destructivePoofAtlas.textureNamed("poof3D"),
                                       destructivePoofAtlas.textureNamed("poof4D"),
                                       destructivePoofAtlas.textureNamed("poof5D"),
                                       destructivePoofAtlas.textureNamed("poof6D"),
                                       destructivePoofAtlas.textureNamed("poof7D"),
                                       destructivePoofAtlas.textureNamed("poof8D"),
                                       destructivePoofAtlas.textureNamed("poof9D"),
                                       destructivePoofAtlas.textureNamed("poof10D"),
                                       destructivePoofAtlas.textureNamed("poof11D"),
                                       destructivePoofAtlas.textureNamed("poof12D"),
                                       destructivePoofAtlas.textureNamed("poof13D"),
                                       destructivePoofAtlas.textureNamed("poof14D"),
                                       destructivePoofAtlas.textureNamed("poof15D"),
                                       destructivePoofAtlas.textureNamed("nothingDestrutivo")
                                    ]
        let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.07)
        destructivePoof.run(idleAction)
    }
	
    func animatePurplePoof() {
        let idleFrames: [SKTexture] = [purplePoofAtlas.textureNamed("poof1R"),
                                       purplePoofAtlas.textureNamed("poof2R"),
                                       purplePoofAtlas.textureNamed("poof3R"),
                                       purplePoofAtlas.textureNamed("poof4R"),
                                       purplePoofAtlas.textureNamed("poof5R"),
                                       purplePoofAtlas.textureNamed("poof6R"),
                                       purplePoofAtlas.textureNamed("poof7R"),
                                       purplePoofAtlas.textureNamed("poof8R"),
                                       purplePoofAtlas.textureNamed("poof9R"),
                                       purplePoofAtlas.textureNamed("poof10R"),
                                       purplePoofAtlas.textureNamed("poof11R"),
                                       purplePoofAtlas.textureNamed("poof12R"),
                                       purplePoofAtlas.textureNamed("poof13R"),
                                       purplePoofAtlas.textureNamed("poof14R"),
                                       purplePoofAtlas.textureNamed("poof15R"),
                                       purplePoofAtlas.textureNamed("nothingRoxo")
                                    ]
        let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.07)
        purplePoof.run(idleAction)
    }
    
    func animateBlackHole(){
        let idleFrames: [SKTexture] = [blackHoleAtlas.textureNamed("BH1"),
                                       blackHoleAtlas.textureNamed("BH2"),
                                       blackHoleAtlas.textureNamed("BH3"),
                                       blackHoleAtlas.textureNamed("BH4"),
                                       blackHoleAtlas.textureNamed("BH5"),
                                       blackHoleAtlas.textureNamed("BH6"),
                                       blackHoleAtlas.textureNamed("BH7"),
                                       blackHoleAtlas.textureNamed("BH8"),
                                       blackHoleAtlas.textureNamed("BH9")
                                    ]
        let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.1)
        blackHole.run(.repeatForever(idleAction))
    }
	
	func animateDestructiveButton() {
		let animationFrames: [SKTexture] = [destructiveButtonTextureAtlas.textureNamed("DestructiveButton - Pressed"),
											destructiveButtonTextureAtlas.textureNamed("DestructiveButton")]
		let frameAction = SKAction.animate(with: animationFrames, timePerFrame: 0.5)
		restartEquationButton.run(frameAction)
	}
	
	
	func animateUndoButton() {
		let animationFrames: [SKTexture] = [undoButtonTextureAtlas.textureNamed("UndoButton - Pressed"),
														undoButtonTextureAtlas.textureNamed("UndoButton")]
		let frameAction = SKAction.animate(with: animationFrames, timePerFrame: 0.5)
		undoButton.run(frameAction)
	}
	
}

// [2x]

// ["..", +, 5]
// [.., +, .....]
// "\(eq[].count)x"

// [.., - , 4, =, -, ....., +, 10] -> Joga
// [.., +, ..... =, +, 10, +, 4] -> Botao
// [......., =, 14] -> Joga
// [., = 14, /, 7] -> Botao
// [., =, 2] -> Joga o saco no buraco negro pro pássaro


