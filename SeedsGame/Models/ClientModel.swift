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
	let wantsGalacticSeeds: Bool
	
	init(_ eq: String, imageNamed: String, color: UIColor, size: CGSize = CGSize(width: 130, height: 233)) {
		self.eq = eq
		
		
		// 10 clientes + Rose
		let randomTexture = Int.random(in: 1...11)
		self.clientSpriteID = randomTexture
		let texture = SKTexture(imageNamed: clientSprites[randomTexture]!)
		
		// Se for a Rose, sempre quer as sementes galáticas
		if randomTexture == 11 {
			self.wantsGalacticSeeds = true
		} else {
			let doesHeWantSeedBag = Bool.random()
			self.wantsGalacticSeeds = doesHeWantSeedBag
		}
		
		//let texture = SKTexture(imageNamed: imageNamed)
		if randomTexture <= 5 { // FÊMEA
			super.init(texture: texture, color: color, size: CGSize(width: 130, height: 233))
			self.size = CGSize(width: 130, height: 233)
		}
		else if randomTexture <= 10 { // MACHO
			super.init(texture: texture, color: color, size: CGSize(width: 141, height: 243))
			self.size = CGSize(width: 141, height: 243)
		}
		else { // ROSE
			super.init(texture: texture, color: color, size: CGSize(width: 190, height: 335))
			self.size = CGSize(width: 190, height: 335)
		}
		
	}
	
	
	
	
	
	
	
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
