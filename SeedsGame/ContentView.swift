//
// ContentView.swift
// SeedsGame
//
// Created by Gabriel Vicentin Negro on 18/01/24.
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
		NavigationStack {
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
					if GameEngine.shared.gameOver{
						ZStack{
							Color.black.opacity(0.5)
							EndGameView(tag: .failed, points: userEngine.score)
						}
					}
					else if GameEngine.shared.endOfPhase {
						ZStack {
							Color.black.opacity(0.5)
							EndGameView(tag: .win, points: userEngine.score)
						}
					}
				}
				.animation(.bouncy)
				.ignoresSafeArea()
				
			}
		}
	}
}


#Preview {
	ContentView()
		.environmentObject(UserEngine())
}
