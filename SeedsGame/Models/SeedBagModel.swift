//
//  HitBoxModel.swift
//  SeedsGame
//
//  Created by Gabriel Vicentin Negro on 19/01/24.
//

import Foundation
import SpriteKit
import SwiftUI

class SeedBagModel: SKSpriteNode {
	
	var numero: Int
	var incognita: Bool
	var isOperator: Bool
	var label: SKLabelNode
	
	init(numero: Int, incognita: Bool, isOperator: Bool, operatorr: String, imageNamed: String, color: UIColor, width: Double, height: Double) {
		self.numero = numero
		self.incognita = incognita
		self.isOperator = isOperator
		if isOperator == false{
			self.label = SKLabelNode(text: self.incognita == false ? String(self.numero) : "?")
			
		}else{
			self.label = SKLabelNode(text: operatorr)
		}
		self.label.fontName = "AlegreyaSans-Medium"
		self.label.fontSize = 25
		self.label.fontColor = UIColor(Color("FontDarkBrown"))
		
		let texture = SKTexture(imageNamed: imageNamed)
		let size = CGSize(width: width, height: height)
		
		super.init(texture: texture, color: color, size: size)
		self.addChild(label)
		
		setLabelPosition()
	}
	
	
	func invertOperator(_ node: SeedBagModel, _ touches: Set<UITouch>, _ position: Int, _ scene: PhaseScene) {
		
		let inverseMap: [String: String] = ["+": "-",
														"-": "+",
														"*": "/",
														"/": "*"]
		
		if let touch = touches.first {
			let location = touch.location(in: scene.self)
			if node.contains(location) {
				scene.currentSeedBags[position].label.text = inverseMap[node.label.text!]
				scene.currentSeedBags[position].resetLabelPosition()
			}
		}
	}
	
	
	func setLabelPosition() {
		if !self.isOperator {
			self.label.position.y = self.label.position.y - 20
		}
		else if self.isOperator && self.label.text == "*" {
			self.label.position.y = self.label.position.y - 15
		}
		else if self.isOperator && self.label.text == "/" {
			self.label.position.y = self.label.position.y - 7
		}
		else {
			self.label.position.y = self.label.position.y - 7
		}
	}
    
    func resetLabelPosition() {
        if self.isOperator && self.label.text == "*"{
            self.label.position.y = self.label.position.y + 7
            self.label.position.y = self.label.position.y - 15
        }
        else if self.isOperator && self.label.text == "/"{
            self.label.position.y = self.label.position.y + 15
            self.label.position.y = self.label.position.y - 7
        }
    }
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
}

