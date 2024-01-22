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
	
	var scene: SKScene {
		let scene = gameEngine.phases[gameEngine.currentPhase]
		scene.scaleMode = .fill
		return scene
	}
	
	var body: some View {
		VStack {
			SpriteView(scene: scene)
		}
		.ignoresSafeArea()
	}
}

#Preview {
	ContentView()
}
      
