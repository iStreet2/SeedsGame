//
//  PhaseSelectionView.swift
//  SeedsGame
//
//  Created by Laura C. Balbachan dos Santos on 24/01/24.
//

import SwiftUI
import SpriteKit

struct PhaseSelectionView: View {
    @State var index: Int = 0
    @State var gestureIsOn: Bool = true
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: -60) {
                    
                    HStack(alignment: .center) {
                        Button(action: {}, label: {
                            Text("")
                        })
                        .buttonStyle(SquareButtonStyle(tag: .back))
                        Spacer()
                        Text("Selecione o Capítulo")
                            .font(.custom("AlegreyaSans-Black", size: 32))
                            .foregroundStyle(Color("FontLightBrown"))
                            .padding(.trailing, geometry.size.width/3)
                    }
                    .padding(.top, geometry.size.height * 0.1)
                    
                    PhaseViewer(phasesName: ["fase3", "fase2"])
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                }
                .background(Color("BGDarkGreen"))
            }
        }
    }
}

#Preview {
    PhaseSelectionView()
}
