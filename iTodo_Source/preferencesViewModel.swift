import Foundation
import SwiftUI

class PreferencesViewModel: ObservableObject {
    @Published var showPreferenceNote: Bool = UserDefaults.standard.bool(forKey: "showPreferenceNote")
    @Published var savedAutoDay: Bool = UserDefaults.standard.bool(forKey: "savedAutoDay")
    @Published var savedName: String = UserDefaults.standard.string(forKey: "savedName") ?? ""
    @Published var savedPassword: String = UserDefaults.standard.string(forKey: "savedPassword") ?? ""
    @Published var passIsCorrect: Bool = UserDefaults.standard.bool(forKey: "passIsCorrect")
    @Published var backgroundColor: String = UserDefaults.standard.string(forKey: "backgroundColor") ?? ""
    @Published var default1: String = UserDefaults.standard.string(forKey: "backgroundColor") ?? ""
    @Published var default2: String = UserDefaults.standard.string(forKey: "backgroundColor") ?? ""
    @Published var default3: String = UserDefaults.standard.string(forKey: "backgroundColor") ?? ""
    @Published var cateogry1: String = UserDefaults.standard.string(forKey: "backgroundColor") ?? ""
    @Published var cateogry2: String = UserDefaults.standard.string(forKey: "backgroundColor") ?? ""
    @Published var encryptHide: Bool = UserDefaults.standard.bool(forKey: "encryptHide")

    func savedAutoDayInWindow(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "savedAutoDay")
        self.savedAutoDay = value
    }
    
    func showPreferenceNoteInWindow(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "showPreferenceNote")
        self.showPreferenceNote = value
    }
    
    func savedNameInWindow(_ value: String) {
        UserDefaults.standard.set(value, forKey: "savedName")
        self.savedName = value
    }
    
    func savedPasswordInWindow(_ value: String) {
        UserDefaults.standard.set(value, forKey: "savedPassword")
        self.savedPassword = value
    }
    
    func passIsCorrectInWindow(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "passIsCorrect")
        self.passIsCorrect = value
    }
    
    func backgroundColorSaved(_ value: String) {
        UserDefaults.standard.set(value, forKey: "backgroundColor")
        self.backgroundColor = value
    }
    
    func default1InWindow(_ value: String) {
        UserDefaults.standard.set(value, forKey: "default1")
        self.default1 = value
    }
    
    func default2InWindow(_ value: String) {
        UserDefaults.standard.set(value, forKey: "default2")
        self.default2 = value
    }
    
    func default3InWindow(_ value: String) {
        UserDefaults.standard.set(value, forKey: "default3")
        self.default3 = value
    }
    
    func cateogry1InWindow(_ value: String) {
        UserDefaults.standard.set(value, forKey: "category1")
        self.cateogry1 = value
    }
    
    func category2InWindow(_ value: String) {
        UserDefaults.standard.set(value, forKey: "category2")
        self.cateogry2 = value
    }
    
    func encryptHideInWindow(_ value: Bool) {
           UserDefaults.standard.set(value, forKey: "encryptHide")
           self.encryptHide = value
       }
}

