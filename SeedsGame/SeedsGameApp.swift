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
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(userEngine)
        }
    }
}
