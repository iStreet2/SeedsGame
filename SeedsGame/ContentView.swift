//
//  ContentView.swift
//  SeedsGame
//
//  Created by Gabriel Vicentin Negro on 18/01/24.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State var life = 3
    @State var points = 1
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var gameEngine = GameEngine.shared
    
    var scene: SKScene {
        let scene = gameEngine.phases[gameEngine.currentPhase]
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    LifeScore(life: $life, points: $points)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}

