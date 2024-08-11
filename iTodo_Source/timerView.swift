import Foundation
import Combine
import SwiftUI

class TimerManager: ObservableObject {
    var timer: AnyCancellable?
}

struct TimerView: View {
    @State private var userInput: String = ""
    @State private var remainingTime: Int = 0
    @StateObject private var timerManager = TimerManager()

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "timer")
                Text("Timer:")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            
            Text("\(remainingTime)")
                .font(.largeTitle)
                .padding()
            HStack {
                
                TextField("Enter time in seconds", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .fixedSize()
                
                Button(action: startTimer) {
                    Text("Start")
                }
                .keyboardShortcut("a", modifiers: .command)
            }

        }
        .padding()
    }

    func startTimer() {
        guard let timeInput = Int(userInput) else {
            // Handle invalid input
            return
        }

        remainingTime = timeInput
        timerManager.timer?.cancel()

        timerManager.timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                DispatchQueue.main.async {
                    if self.remainingTime > 0 {
                        self.remainingTime -= 1
                    } else {
                        self.timerManager.timer?.cancel()
                    }
                }
            }
    }
}
