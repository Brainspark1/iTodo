//
//  automaticNewDay.swift
//  iTodo
//
//  Created by Nihaal Garud on 03/04/2024.
//

/* import Foundation
import SwiftUI

struct AutoDayView: View {
    
    @State private var savedTexts: [String] = []
    @State private var completedTexts: [String] = []
    
    var body: some View {
        Text("New Day")
    }
    
    func main() {
               func runFunction() {
                   newDay()
               }
               
               func scheduleFunctionAtMidnight() {
                   let currentDate = Date()
                   let calendar = Calendar.current
                   let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
                   var triggerDate = calendar.date(from: components)!
                   triggerDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: triggerDate)!
                   let timeInterval = triggerDate.timeIntervalSinceNow
                   let timer = Timer(timeInterval: timeInterval, repeats: false) { _ in
                       runFunction()
                   }
                   
                   RunLoop.current.add(timer, forMode: .common)
               }

               scheduleFunctionAtMidnight()
           }
    
    private func newDay() {
            savedTexts.removeAll()
            completedTexts.removeAll()
        }

}
 */

