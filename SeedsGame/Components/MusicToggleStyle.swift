//
//  MusicToggle.swift
//  SeedsGame
//
//  Created by André Enes Pecci on 31/01/24.
//

import Foundation
import SwiftUI
import CoreData

struct MusicToggleStyle: ToggleStyle {
//    @State var isMusicOn = true
    
    //Coisas do CoreData
    @Environment(\.managedObjectContext) var context //Contexto, DataController
    @ObservedObject var myDataController: MyDataController
    @FetchRequest(sortDescriptors: []) var myData: FetchedResults<MyData>
    
    init(context: NSManagedObjectContext){
        self.myDataController = MyDataController(context: context)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: myData[0].music
                  ? "speaker"
                  : "speaker.slash")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .frame(width: 15)
            .foregroundStyle(.black)
            
            configuration.label
            Spacer()
            (myData[0].music ? Image("Toggle On") : Image("Toggle Off")) //Se music do CoreData for true
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(width: 70, height: 36, alignment: .center)
                .overlay(Image("Bolinha do Toggle")
                    .offset(x: myData[0].music ? 21 : -21, y: 0)
                    .animation(Animation.linear(duration: 0.15))

                )
                .onTapGesture { myDataController.toggleMusic(myData: myData[0]) }
        } .frame(width: 0)
    }
}

#Preview {
    Toggle(isOn: .constant(true), label: {
        Text("")
    })
    .toggleStyle(MusicToggleStyle(context: DataController().container.viewContext))
}
