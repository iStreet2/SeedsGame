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
        ZStack {
            Color.gray
                .ignoresSafeArea()
            
            TabView(selection: $phaseIndex) {
                ForEach(0..<phases.count, id: \.self) { index in
                    ZStack {
                        NavigationLink {
                            SpriteView(scene: getScene(phaseIndex: phaseIndex))
                                .navigationBarBackButtonHidden(true)
                                .ignoresSafeArea()
                            
                        } label: {
                            Image("\(phasesName[index])")
                                .resizable()
                                .tag(index)
                                .frame(width: 350, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
                        
                    }
                }
            }
            .frame(height: 300)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            
            
            HStack {
                ForEach(0..<phasesName.count, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(phaseIndex == index ? 1 : 0.30))
                        .frame(width: 10)
                        .onTapGesture {
                            phaseIndex = index
                        }
                }
                .offset(y: -120)
            }
        }
    }
}

