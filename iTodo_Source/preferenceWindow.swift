import SwiftUI
import Cocoa

struct VisualEffect: NSViewRepresentable {
   func makeNSView(context: Self.Context) -> NSView { return NSVisualEffectView() }
   func updateNSView(_ nsView: NSView, context: Context) { }
}

struct Preferences: View {
    @EnvironmentObject var viewModel: PreferencesViewModel
    @State private var isShowingPreferencesSubWindow = false

    var body: some View {
        Button(action: {
            self.isShowingPreferencesSubWindow.toggle()
        }) {
            Image(systemName: "gear")
            Text("Preferences")
            Image(systemName: "command")
            Text(",")
        }
        .keyboardShortcut(",", modifiers: .command)
        .sheet(isPresented: $isShowingPreferencesSubWindow) {
            SubOtherWindowView()
                .background(VisualEffect())
        }
    }
}

struct SubOtherWindowView: View {
    @EnvironmentObject var viewModel: PreferencesViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Toggle(isOn: $viewModel.savedAutoDay) {
                Text("Automatically clear to-do list at the start of a new day")
            }
            .padding()

            Toggle(isOn: $viewModel.showPreferenceNote) {
               Text("Show recent Quick Note")
            }
            .padding()
            
            TextField("Name", text: $viewModel.savedName)
                .padding()
            
            SecureField("Password", text: $viewModel.savedPassword)
                .padding()
            
            Toggle(isOn: $viewModel.encryptHide) {
                Text("Show encrypted tasks list")
            }
            .padding()
            
            Text ("Background Color:")
            
            Text("Enter a color, or none to remove the color")
            
            TextField("Background Color", text: $viewModel.backgroundColor)
            
            Text("Default Tasks:")
                .padding()
            TextField("Default Task 1", text: $viewModel.default1)
            TextField("Default Task 2", text: $viewModel.default2)
            TextField("Default Task 3", text: $viewModel.default3)
            
            Text("Categories:")
                .padding()
            TextField("Category 1", text: $viewModel.cateogry1)
            TextField("Category 2", text: $viewModel.cateogry2)

            Button("Save & Dismiss") {
                viewModel.savedAutoDayInWindow(viewModel.savedAutoDay)
                viewModel.savedNameInWindow(viewModel.savedName)
                viewModel.savedPasswordInWindow(viewModel.savedPassword)
                viewModel.backgroundColorSaved(viewModel.backgroundColor)
                viewModel.default1InWindow(viewModel.default1)
                viewModel.default2InWindow(viewModel.default2)
                viewModel.default3InWindow(viewModel.default3)
                viewModel.cateogry1InWindow(viewModel.cateogry1)
                viewModel.category2InWindow(viewModel.cateogry2)
                viewModel.encryptHideInWindow(viewModel.encryptHide)
                UserDefaults.standard.set(viewModel.showPreferenceNote, forKey: "showPreferenceNote")
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
    }
    
}

