//
//  ContentView.swift
//  SeedsGame
//
//  Created by Gabriel Vicentin Negro on 18/01/24.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
	
	var scene: SKScene {
		let scene = GameScene()
		scene.size = CGSize(width: 300, height: 400)
		scene.scaleMode = .fill
		return scene
	}
	
	var body: some View {
		VStack {
			SpriteView(scene: scene)
				.frame(width: 300, height: 400)
				.ignoresSafeArea()
		}
		.padding()
	}
}

#Preview {
	ContentView()
}
