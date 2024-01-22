//
//  HitBoxModel.swift
//  SeedsGame
//
//  Created by Gabriel Vicentin Negro on 19/01/24.
//

import Foundation
import SpriteKit

class SeedBagModel: SKSpriteNode {
    
    var numero: Int
    var incognita: Bool
    
    init(numero: Int, incognita: Bool, imageNamed: String, color: UIColor, width: Double, height: Double) {
        self.numero = numero
        self.incognita = incognita
        let texture = SKTexture(imageNamed: imageNamed)
        let size = CGSize(width: width, height: height)
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

