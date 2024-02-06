//
//  ClientModel.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/01/24.
//

import Foundation
import SpriteKit

class ClientModel: SKSpriteNode {
	var eq: String
	
	let clientSprites = [1: "F Azul - Neutro",
								2: "F Laranja - Neutro",
								3: "F Rosa - Neutro",
								4: "F Roxo - Neutro",
								5: "F Verde - Neutro",
								6: "M Azul - Neutro",
								7: "M Laranja - Neutro",
								8: "M Rosa - Neutro",
								9: "M Roxo - Neutro",
								10: "M Verde - Neutro",
								11: "Rose - Neutro"]
	
	let clientSpriteID: Int
	
	init(_ eq: String, imageNamed: String, color: UIColor, size: CGSize = CGSize(width: 364.22, height: 651.83)) {
		self.eq = eq
		
		
		// 10 clientes + Rose
		let randomTexture = Int.random(in: 1...11)
		self.clientSpriteID = randomTexture
		let texture = SKTexture(imageNamed: clientSprites[randomTexture]!)
		
		//let texture = SKTexture(imageNamed: imageNamed)
		if randomTexture <= 10 {
			super.init(texture: texture, color: color, size: CGSize(width: 364.22, height: 651.83))
			self.size = CGSize(width: 364.22, height: 651.83)
		}
		else {
			super.init(texture: texture, color: color, size: CGSize(width: 567.33, height: 1006.56))
			self.size = CGSize(width: 567.33, height: 1006.56)
		}
		
	}
	
	
	
	
	
	
	
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
