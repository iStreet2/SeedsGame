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
	
	var scene = TutorialPhase(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
	
	var body: some View {
		NavigationStack {
			ZStack {
				
				SpriteView(scene: scene)
					.ignoresSafeArea()
				
				VStack{
					HStack{
						
						LifeScore()
						
						Spacer()
						
						Button("") {
							GameEngine.shared.setGameIsPausedTRUE()
						}.buttonStyle(SquareButtonStyle(tag: .pause))
						
					}
					Spacer()
				}
				
				VStack(spacing: 0) {
					if GameEngine.shared.gameOver{
						ZStack{
							Color.black.opacity(0.5)
							EndGameView(scene: TutorialPhase(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), tag: .failed, points: userEngine.score)
						}
					}
					else if GameEngine.shared.endOfPhase {
						ZStack {
							Color.black.opacity(0.5)
							EndGameView(scene: TutorialPhase(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), tag: .win, points: userEngine.score)
						}
					}
					else if GameEngine.shared.gameIsPaused {
						ZStack {
							Color.black.opacity(0.5)
							PauseView()
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
