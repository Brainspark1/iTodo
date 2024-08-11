//
//  iTodoApp.swift
//  iTodo
//
//  Created by Nihaal Garud on 29/03/2024.
//

import SwiftUI

@main
struct iTodoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PreferencesViewModel())
        }
    }
}
