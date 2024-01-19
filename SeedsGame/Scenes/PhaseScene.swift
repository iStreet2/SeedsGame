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
    var hitBoxes: [SKShapeNode] = []
	
	
	init(phase: Int, width: Double, height: Double) {
		
		super.init(size: CGSize(width: width, height: height))
		
		let clientMap: [Int: Int] = [1: map[1]!.count, 2: map[2]!.count, 3: map[3]!.count] //Inicializa as equações dos clientes
		let eqs = map[phase]
			
		for n in 0..<clientMap[phase]! {
			
			let client = ClientModel(eqs![n], imageNamed: "Client", color: .blue, size: CGSize(width: 100, height: 100))
            print(eqs![n])
			clients.append(client)
			addChild(client)
            
            
            //Para cada caracter na string da equação, eu crio um quadrado que ira receber sacos dentro dele
            for _ in eqs![n]{
                let node = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
                hitBoxes.append(node)
            }
            //PROXIMO PASSO: DIMINUIR O TAMANHO DOS QUADRADOS E CRIAR FUNCAO PARA O SACO GRUDAR NELES! E TAMBEM SEMPRE ACOMPANHAR A QUANTIDADE DE ELEMENTOS DA EQUACAO!!! ACHO QUE TA MOSTRANDO A QUANTIDADE DE QUADRADOS A QUANTIDADE DE CARACTERES DA FASE, NAO DA EQUACAO ATUAL
		}
		
		self.isUserInteractionEnabled = true
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
        
        for (index,hitBox) in hitBoxes.enumerated(){
            hitBox.position = CGPoint(x: 100+(150*index), y: 100)
            hitBox.strokeColor = .red
            addChild(hitBox)
        }
		
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
