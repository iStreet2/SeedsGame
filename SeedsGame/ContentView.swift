//
//  ContentView.swift
//  SeedsGame
//
//  Created by Gabriel Vicentin Negro on 18/01/24.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var gameEngine = GameEngine.shared
    
    @EnvironmentObject var userEngine: UserEngine
    
    var scene: SKScene {
        gameEngine.userEngine = userEngine
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
                    LifeScore()
                    Spacer()
                }
                Spacer()
            }
			  
			  VStack(spacing: 0) {
				  Color.blue
				  if !GameEngine.shared.endOfPhase {
					  EndGameView(tag: .win)
				  }
				  Color.red
			  }
			  .ignoresSafeArea()
			  
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserEngine())
}

