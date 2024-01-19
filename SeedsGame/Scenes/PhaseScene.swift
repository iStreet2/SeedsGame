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
	
	
	init(phase: Int, width: Double, height: Double) {
		
		super.init(size: CGSize(width: width, height: height))
		
		let clientMap: [Int: Int] = [1: map[1]!.count, 2: map[2]!.count, 3: map[3]!.count]
		let eqs = map[phase]
			
		for n in 0..<clientMap[phase]! {
			
			let client = ClientModel(eqs![n], imageNamed: "Client", color: .blue, size: CGSize(width: 100, height: 100))
			clients.append(client)
			addChild(client)
		}
		
		self.isUserInteractionEnabled = true
	}
	
	
	override func didMove(to view: SKView) {
		
		startup()
		
		for (index, client) in clients.enumerated() {
			client.position = CGPoint(x: 100, y: 100+(150*index))
			
			let label = SKLabelNode(text: client.eq)
			label.position.x = client.position.x
			label.position.y = client.position.y + 50
			addChild(label)
		}
		
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
