//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Franziska Werner on 22.10.21.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
            // create an instance of ContentModel and delegates to HomeView?
                .environmentObject(ContentModel())
        }
    }
}
