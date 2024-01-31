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
                VStack(alignment: .trailing) {
                    PhaseViewer(phasesName: ["fase1",
                                             "fase2"])
                }
            }
        }
    }
}

#Preview {
    PhaseSelectionView()
}
