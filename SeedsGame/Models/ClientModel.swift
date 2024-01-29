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
	
	let clientSprites = [1: "", 2: ""]
	
	init(_ eq: String, imageNamed: String, color: UIColor, size: CGSize) {
		self.eq = eq
		let texture = SKTexture(imageNamed: imageNamed)
		super.init(texture: texture, color: color, size: size)
	}
	
	
	
	
	
	
	
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
