//
//  WinView.swift
//  SeedsGame
//
//  Created by Laura C. Balbachan dos Santos on 01/02/24.
//

import Foundation
import SwiftUI
import CoreData

struct EndGameView: View {
    
    //Coisas do CoreData
    @Environment(\.managedObjectContext) var context //Contexto, DataController
    @ObservedObject var myDataController: MyDataController
    @FetchRequest(sortDescriptors: []) var myData: FetchedResults<MyData>
    
    var scene: PhaseScene
    var tag: PhasesFrases
    var points: Int
    
    init(context: NSManagedObjectContext, scene: PhaseScene, tag: PhasesFrases, points: Int) {
        self.myDataController = MyDataController(context: context)
        self.scene = scene
        self.tag = tag
        self.points = points
    }
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 70) {
            VStack {
                // Lado esquerdo do Pop Up
                Image("Foto")
                    .resizable()
                    .frame(width: 263, height: 264)
                    .overlay {
                        Image("Moldura - Fim de Fase")
                            .resizable()
                            .frame(width: 280, height: 282)
                    }
            }
            
            // Lado direito do Pop Up
            VStack {
                VStack(spacing: 0) {
                    Text("\(tag.rawValue)")
                        .multilineTextAlignment(.center)
                        .font(.custom("troika", size: 36))
                        .frame(width: 220, height: 85)
                    
                    // Texto de High Score
                    // Aqui teria que ter a lógica de ver se é New High Score mesmo
                    HStack(spacing: 5) {
                        if points > Int(myData[scene.phase].highscores){ //Se a minha pontuação recebida for maior que a do core data
                            HStack{
                                Text("NEW")
                                    .font(.custom("AlegreyaSans-Medium", size: 24))
                                
                                Text("High Score: \(points)")
                                    .font(.custom("AlegreyaSans-Medium", size: 20))
                            }
                        }else{
                            Text("High Score: \(Int(myData[scene.phase].highscores))")
                                .font(.custom("AlegreyaSans-Medium", size: 20))
                        }
                    }
                }
                                
                // Botões
                VStack(spacing: 60) {
                    HStack(spacing: 140) {
							  NavigationLink {
								  MenuView(context: context)
							  } label: {
								  Text("")
							  }
							  .buttonStyle(SquareButtonStyle(tag: .home))
                        
                        
                        Button("") {
                            print("aaa")
                        }
                        .buttonStyle(SquareButtonStyle(tag: .gameCenter))
                    }
                    
                    if scene.phase < 3{
                        NavigationLink {
                            SpriteSceneView(context: context, scene: PhaseScene(phase: scene.phase+1, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                        } label: {
                            if scene.phase == 3{
                                Text("Fases concluidas")
                            }else{
                                Text("Proxima Fase")
                            }
                        }
                        .buttonStyle(RectangleButtonStyle(tag: .type2))
                    }
                }
                .padding(.top, 25)
                
            }
        }
        .padding(.trailing, 40)
        .background(Image("Fundo Fase"))
        .frame(width: 673, height: 322)
    }
}

//#Preview {
//    EndGameView(context: DataController().container.viewContext,scene: PhaseScene(phase: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), tag: .failed, points: 0)
//}
