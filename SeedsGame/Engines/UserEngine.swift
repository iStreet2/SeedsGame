//
//  UserEngine.swift
//  SeedsGame
//
//  Created by Marina Martin on 01/02/24.
//
//  Classe que guarda as informações que o usuário tem/quer saber

import Foundation
import SpriteKit

class UserEngine: ObservableObject{
    static let shared = UserEngine()
    
    @Published var life: Int = 3
    @Published var score: Int = 0
    
//    init(life: Int = 3, score: Int = 0) {
//        self.life = life
//        self.score = score
//    }
    
    func wrongAnswer() {
        life -= 1
        print("menos uma vida \(life)")
    }
}
