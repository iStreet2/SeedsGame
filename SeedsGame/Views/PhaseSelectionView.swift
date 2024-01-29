//
//  PhaseSelectionView.swift
//  SeedsGame
//
//  Created by Laura C. Balbachan dos Santos on 24/01/24.
//

import SwiftUI

struct PhaseSelectionView: View {
    @State var index: Int = 0
    @State var gestureIsOn: Bool = true
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack{
                    
                    Text("Selecione o capítulo")
                        .padding(.bottom)
                    
                    Carousel(currentIndex: $index, gestureIsOn: $gestureIsOn){
                        VStack {
                            Rectangle().foregroundStyle(.red)
                            Text("Fase 1")
                        }
                        
                        VStack {
                            Rectangle().foregroundStyle(.blue)
                            Text("Fase 2")
                        }
                        
                        VStack {
                            Rectangle().foregroundStyle(.green)
                            Text("Fase 3")
                        }
                        
                        VStack {
                            Rectangle().foregroundStyle(.purple)
                            Text("Fase 4")
                        }
                    }
                    .frame(width: geometry.size.width/2, height: geometry.size.height/2)
                }
            }
        }
    }
}

#Preview {
    PhaseSelectionView()
}
