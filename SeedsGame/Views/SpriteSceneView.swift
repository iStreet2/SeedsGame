//
//  SpriteSceneView.swift
//  SeedsGame
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 06/02/24.
//

import Foundation
import SwiftUI
import SpriteKit
import CoreData

struct SpriteSceneView: View {
    
    //Coisas do CoreData
    @Environment(\.managedObjectContext) var context //Contexto, DataController
    @ObservedObject var myDataController: MyDataController
    @FetchRequest(sortDescriptors: []) var myData: FetchedResults<MyData>
	
	var scene: PhaseScene
	@EnvironmentObject var userEngine: UserEngine
	
    init(context: NSManagedObjectContext, scene: PhaseScene) {
        self.myDataController = MyDataController(context: context)
        self.scene = scene
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
                            EndGameView(context: context, scene: scene, tag: .failed, points: userEngine.score)
						}
					}
					else if GameEngine.shared.endOfPhase {
						ZStack {
							Color.black.opacity(0.5)
                            EndGameView(context: context, scene: scene, tag: .win, points: userEngine.score)
                                .onAppear{
                                    myDataController.unlockNextPhase(myData: myData[0])
                                    if userEngine.score > Int(myData[scene.phase].highscores){ //Se o que o usuário marcou agora for maior que o que ja existe no core data, ele salva esse novo valor
                                        myDataController.saveHighScore(myData: myData[scene.phase], score: Double(userEngine.score))
                                    }
                                    //TALVEZ TENHA QUE SER ALTERADO COM O TUTORIAL
                                }
						}
					}
					else if GameEngine.shared.gameIsPaused {
						ZStack {
							Color.black.opacity(0.5)
							PauseView(context: context)
						}
					}
				}
				.animation(.bouncy)
				.ignoresSafeArea()
				
			}
		}
        .onAppear {
            GameEngine.shared.setGameIsPausedFALSE()
            GameEngine.shared.setEndOGPhaseFALSE()
            GameEngine.shared.userEngine = self.userEngine
            userEngine.resetUser()
        }
		.navigationBarBackButtonHidden()
	}
}


//#Preview {
//	SpriteSceneView(context: DataController().container.viewContext, scene: PhaseScene(phase: 1, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//		.environmentObject(UserEngine())
//}
