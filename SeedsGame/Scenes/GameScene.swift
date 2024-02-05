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
        1: [("5-4=x", 1), ("2x=4", 2), ("x+2=3", 1), ("9-x=4", 5), ("x+6=15", 9), ("90-x=50", 40), ("5=-x+4", -1), ("20=x-40", 60), ("8+x=17",9), ("x+3=-12", -15)],
        2: [("10+x=-30", -40), ("x+2=-4", -3), ("17-x=3", 7), ("30x-120=0", 4), ("2x+3x=15x-30", 3), ("14+2x=3+2", -4.5), ("5x-12=3", 3), ("3x+1=x-3", -2), ("5x+5=3x+7", 1), ("6x+3=-9", -2)],
        3: [("4x-10=3x-3-4", 3), ("3x-6+10=4x+4+2", -2), ("3x+4x-40=x+20",10), ("2x+6x-15+4=x+6x-6-6", -1), ("3x+2=4x-1", 3), ("3x+2=29", 9), ("x+(x+1)+(x+2)=60", 19), ("x+5x=2x+40", 10), ("2x/4-5/3=x-7/2", 11/3), ("(4x+2)/3-(5x-7)/6=(3-x)/2", -1/3)]
      ]
	
	//let nextPhaseButton = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
	//let nextQuestionButton = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
	
	var joinSideButton = SKSpriteNode(imageNamed: "Ala - Frame 1")
	var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Alavanca")
	
	let undoButton = SKSpriteNode(imageNamed: "UndoButton")
	let undoButtonTextureAtlas = SKTextureAtlas(named: "UndoButtonAssets")
	let blackHole = SKSpriteNode(imageNamed: "Buraco Negro Provisorio")
    var deliveryPlace = SKSpriteNode()
	
	
	let restartEquationButton = SKSpriteNode(imageNamed: "DestructiveButton")
	var destructiveButtonTextureAtlas: SKTextureAtlas = SKTextureAtlas(named: "DestructiveButtonAssets")
	
	override func didMove(to view: SKView) {
		startup()
	}
	
	
	func startup() {
        let width = frame.size.width
        let height = frame.size.height
    
		//nextPhaseButton.position = CGPoint(x: frame.size.width - 100, y: 50)
		//nextPhaseButton.zPosition = 12
		
		//nextQuestionButton.position = CGPoint(x: frame.size.width - 200, y: 50)
		//nextQuestionButton.zPosition = 12
		
        joinSideButton.position = CGPoint(x: frame.size.width - 80, y: frame.size.height / 3)
        joinSideButton.size = CGSize(width: 209.73, height: 160.24)
        joinSideButton.zPosition = 12
		

		blackHole.position = CGPoint(x: frame.size.width / 2, y: 38)
        blackHole.size = CGSize(width: 327, height: 92)
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
	
	func animateLever() {
		let idleFrames: [SKTexture] = [textureAtlas.textureNamed("Ala - Frame 1"),
												 textureAtlas.textureNamed("Ala - Frame 2"),
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
		let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.03)
		joinSideButton.run(idleAction)
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


