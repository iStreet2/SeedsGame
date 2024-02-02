//
//  PhaseViewer.swift
//  SeedsGame
//
//  Created by Laura C. Balbachan dos Santos on 31/01/24.
//

import Foundation
import SwiftUI
import SpriteKit

// Para ver como está ficando
struct uPhaseViewer: View {
    var body: some View {
        PhaseViewer(phasesName: ["fase1", "fase2"])
    }
}

#Preview {
    uPhaseViewer()
}


var gameEngine = GameEngine.shared


// MARK: Códido do Carrosel
struct PhaseViewer: View {
    var phases: [PhaseScene] = GameEngine.shared.phases
    var phasesName: [String]
    
    @State private var phaseIndex: Int = 0
    
    func getScene(phaseIndex: Int) -> PhaseScene {
        let scene = phases[phaseIndex]
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                
                TabView(selection: $phaseIndex) {
                    // Aqui só dá para ter duas fases porque o jogo em si só tem duas fases
                    ForEach(0..<phases.count, id: \.self) { index in
                        ZStack {
                            NavigationLink {
                                SpriteView(scene: getScene(phaseIndex: phaseIndex))
                                    .navigationBarBackButtonHidden(true)
                                    .ignoresSafeArea()
                                
                            } label: {
                                Image("\(phasesName[index])")
                                    .resizable()
                                    .frame(width: 315, height: 198)
                                
                                    .overlay {
                                        Image("Moldura do  Nivel")
                                            .resizable()
                                            .tag(index)
                                            .frame(width: 342.73, height: 221.46)
                                    }
                            }
                        }
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea()
                
                VStack {
                    Text("Fase \(phaseIndex + 1)")
                        .font(.custom("troika", size: 40))
                        .foregroundStyle(.fontLightBrown)
                        .offset(y: 160)
                    
                    HStack {
                        ForEach(0..<phasesName.count, id: \.self) { index in
                            Circle()
                                .fill(phaseIndex == index ? Color.fontLightBrown : Color.indexDarkBrown)
                                .frame(width: 10)
                                .onTapGesture {
                                    phaseIndex = index
                                }
                        }
                        .offset(y: 140)
                    }
                }
            }
        }
    }
}

