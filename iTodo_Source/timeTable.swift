import SwiftUI

/* struct MainView: View {
    @State private var isShowingSubWindow = false
    @State private var savedText: String = UserDefaults.standard.string(forKey: "savedText") ?? ""
    
    let showPreferenceNote = UserDefaults.standard.bool(forKey: "showPreferenceNote")

    var body: some View {
        VStack {
            
            if UserDefaults.standard.bool(forKey: "showPreferenceNote") {
                Text("Last Note Entry: \(savedText)")
            }
            
            Button("Quick Note") {
                self.isShowingSubWindow.toggle()
            }
            .sheet(isPresented: $isShowingSubWindow) {
                SubWindowView(text: self.$savedText)
            }
        }
        .padding()
    }
}
 */

import SwiftUI

struct MainView: View {
    @State private var isShowingSubWindow = false
    @State private var savedText: String = UserDefaults.standard.string(forKey: "savedText") ?? ""
    @EnvironmentObject var viewModel: PreferencesViewModel
    var showPreferenceNote: Bool
    
    var body: some View {
        VStack {
            if viewModel.showPreferenceNote == true {
                Text("Last Note Entry: \(savedText)")
            }
            
            Button(action: {
                self.isShowingSubWindow.toggle()
            }) {
                Text("Quick Note")
                Image(systemName: "command")
                Image(systemName: "shift.fill")
                Text("N")
            }
            .sheet(isPresented: $isShowingSubWindow) {
                SubWindowView(text: self.$savedText)
            }
            .keyboardShortcut("n", modifiers: [.command, .shift])
        }
        .padding()
    }
}

struct SubWindowView: View {
    @Binding var text: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("Enter text", text: $text)
                .padding()
            
            Button("Save & Dismiss") {
                UserDefaults.standard.set(self.text, forKey: "savedText")
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
        .frame(width: 300, height: 200)
    }
}
