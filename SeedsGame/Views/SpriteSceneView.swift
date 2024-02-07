//
//  SpriteSceneView.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 06/02/24.
//

import Foundation
import SwiftUI
import SpriteKit

struct SpriteSceneView: View {
	
	var scene: PhaseScene
	@EnvironmentObject var userEngine: UserEngine
	
	
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
                            EndGameView(scene: scene, tag: .failed, points: userEngine.score)
						}
					}
					else if GameEngine.shared.endOfPhase {
						ZStack {
							Color.black.opacity(0.5)
                            EndGameView(scene: scene, tag: .win, points: userEngine.score)
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
		.navigationBarBackButtonHidden()
	}
}


#Preview {
	SpriteSceneView(scene: PhaseScene(phase: 1, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
		.environmentObject(UserEngine())
}
