//
//  SeedsGameApp.swift
//  SeedsGame
//
//  Created by Gabriel Vicentin Negro on 18/01/24.
//

import SwiftUI

@main
struct SeedsGameApp: App {
    @StateObject var userEngine: UserEngine = UserEngine()
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            MenuView(context: dataController.container.viewContext)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(userEngine)
                .persistentSystemOverlays(.hidden)
        }
    }
}
