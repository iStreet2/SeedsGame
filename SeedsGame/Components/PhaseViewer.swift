//
//  PhaseViewer.swift
//  SeedsGame
//
//  Created by Laura C. Balbachan dos Santos on 31/01/24.
//

import Foundation
import SwiftUI
import SpriteKit
import CoreData

// Para ver como está ficando
//struct uPhaseViewer: View {
//    var body: some View {
//        PhaseViewer(phasesName: ["fase1", "fase2", "fase3"])
//    }
//}
//
//#Preview {
//    uPhaseViewer()
//}


var gameEngine = GameEngine.shared


// MARK: Códido do Carrosel
struct PhaseViewer: View {
    
    //Coisas do CoreData
    @Environment(\.managedObjectContext) var context //Contexto, DataController
    @ObservedObject var myDataController: MyDataController
    @FetchRequest(sortDescriptors: []) var myData: FetchedResults<MyData>
    
    var phasesName: [String]
    @State private var phaseIndex: Int = 0
    
    init(context: NSManagedObjectContext, phasesName: [String]) {
        self.myDataController = MyDataController(context: context)
        self.phasesName = phasesName
        self.phaseIndex = 0
    }
    
    var body: some View {
		 NavigationStack {
			 GeometryReader { geometry in
				 ZStack {
					 Color.clear
						 .ignoresSafeArea()
					 
					 TabView(selection: $phaseIndex) {
						 ForEach(0..<3, id: \.self) { index in //0,1,2
							 ZStack {
								 NavigationLink {
                                     SpriteSceneView(context: context, scene: PhaseScene(phase: index+1, width:  UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)) //1,2,3
                                         
                                 } label: {
                                     if myData[0].phase < Double(index){
                                         ZStack{
                                             Image("\(phasesName[index])")
                                                 .resizable()
                                                 .frame(width: 315, height: 198)
                                             
                                                 .overlay {
                                                     Image("Moldura do  Nivel")
                                                         .resizable()
                                                         .tag(index)
                                                         .frame(width: 342.73, height: 221.46)
                                                 }
                                             Image(systemName: "lock.fill")
                                                 .font(.system(size: 50))
                                                 .foregroundStyle(Color("FontDarkBrown"))
                                         }
                                     }else{
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
                                 .disabled(myData[0].phase < Double(index))
							 }
						 }
					 }
					 .frame(height: 250)
					 .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
					 .ignoresSafeArea()
					 
					 // Nome de cada fase
					 VStack {
						 if phaseIndex == 0 {
							 Text("Tutorial")
								 .font(.custom("troika", size: 40))
								 .foregroundStyle(.fontLightBrown)
								 .offset(y: 160)
							 
						 } else {
							 Text("Fase \(phaseIndex)")
								 .font(.custom("troika", size: 40))
								 .foregroundStyle(.fontLightBrown)
								 .offset(y: 160)
						 }
						 
						 
						 HStack {
							 ForEach(0..<phasesName.count, id: \.self) { index in
								 Circle()
                                     .fill(phaseIndex == index ? Color("FontLightBrown") : Color("IndexDarkBrown"))
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
}

