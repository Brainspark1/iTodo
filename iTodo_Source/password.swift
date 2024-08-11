//
//  password.swift
//  iTodo
//
//  Created by Nihaal Garud on 05/04/2024.
//

import Foundation
import SwiftUI

struct PassView: View {
    @State private var enteredPassword: String = ""
    @State private var resultMessage: String = ""
    @EnvironmentObject var viewModel: PreferencesViewModel
    
    
    var body: some View {
        VStack {
            
            TextField("Enter Password", text: $enteredPassword)
                .padding()
                .fixedSize()
            
            Button(action: {
                if self.enteredPassword == self.viewModel.savedPassword {
                    viewModel.passIsCorrect = true
                    ContentView(isEncryptedVisible: true)
                } else {
                    viewModel.passIsCorrect = false
                    ContentView(isEncryptedVisible: false)
                }
            }) {
                Text("Check Password")
            }
            .padding()
        }
    }
}

struct PassView_Previews: PreviewProvider {
    static var previews: some View {
        PassView()
    }
}
