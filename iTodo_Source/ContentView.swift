import Foundation
import SwiftUI
import Combine

struct ContentView: View {
    @State private var stringExpense: String = ""
    @State private var savedTexts: [String] = []
    @State private var completedTexts: [String] = []
    @State private var encryptedTasks: [String] = []
    @State private var hoveredIndex: Int? = nil
    @State private var personalTaskIndex: Int? = nil
    @State private var workTaskIndex: Int? = nil
    @State private var encryptedTaskIndex: Int? = nil
    @State private var completedHoveredIndex: Int? = nil
    @State private var isHovered = false
    @State private var deletedItem: String? = nil
    @State private var changedTerm: String = ""
    @State private var isEditing: Bool = false
    @State private var editingIndex: Int?
    @State private var defaultTask1: String = "Task 1"
    @State private var defaultTask2: String = "Task 2"
    @State private var defaultTask3: String = "Task 3"
    @State private var personalTasks: [String] = []
    @State private var workTasks: [String] = []
    @State private var personalName: String = ""
    @State private var workName: String = ""
    @State private var currentTime = Date()
    @State private var searchText: String = ""
    @State private var filteredItems: [String] = []
    @State private var timeElapsed: TimeInterval = 0
    @State private var timerIsRunning = false
    @State private var automaticNewDay = false
    @EnvironmentObject var viewModel: PreferencesViewModel
    @State var isEncryptedVisible = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        let backgroundColorForm = colorFromString(viewModel.backgroundColor)
        
        ScrollView {
            
            VStack {
                
                Preferences()
                    .padding()
                
                Image(systemName: "checkmark.seal")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .padding()
                    .font(.title)
                
                HStack {
                    Text("iTodo")
                        .bold()
                        .padding()
                        .font(.largeTitle)
                    Image(systemName: "info.circle")
                        .contextMenu {
                            Text("iTodo v1, 2024")
                            Text("Keyboard Shortcuts:")
                                .foregroundColor(.green)
                            Text("1. Command + D - New Day, erase all tasks")
                            Text("2. Command + Enter - Complete all pending tasks")
                            Text("        2a. Command + Shift + Enter - Complete all pending tasks in category 1")
                            Text("        2b. Command + Alt + Enter - Complete all pending tasks in category 2")
                            Text("3. Command + Delete - Clear all completed tasks")
                            Text("4, 5, 6. Command + 1, 2, 3 - Populate to-do tasks with prewritten essentials")
                            Text("7, 8. Command + S, R - Start/pause the stopwatch and reset it at the bottom of the screen")
                            Text("9. Command + A - Start the timer at the bottom of the screen")
                        }
                }
                
                VStack {
                    
                    Text("Hi \(viewModel.savedName)")
                        .padding()
                        .font(.title2)
                        .foregroundColor(.yellow)
                    
                    if isEvening() {
                        Image(systemName: "moon.fill")
                            .imageScale(.large)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .padding()
                    } else if isPastNoon() {
                        Image(systemName: "sun.haze")
                            .imageScale(.large)
                            .foregroundColor(.orange)
                            .font(.largeTitle)
                            .padding()
                    } else {
                        Image(systemName: "sun.max")
                            .imageScale(.large)
                            .foregroundColor(.yellow)
                            .font(.largeTitle)
                            .padding()
                    }
                    
                    Text("Current Time:")
                        .font(.largeTitle)
                    Text(currentTimeFormatted())
                        .font(.title)
                        .padding()
                }
                .onAppear {
                    startClock()
                    if isNewDay() && automaticNewDay == true {
                        main()
                    }
                }
                
                MainView(showPreferenceNote: false)
                
                HStack {
                    
                    Button(action: {
                        newDay()
                    }, label: {
                        Text("New Day")
                        Image(systemName: "sun.max")
                            .foregroundColor(.yellow)
                        Image(systemName: "command")
                        Text("D")
                    })
                    .keyboardShortcut("d", modifiers: .command)
                    
                }
                
                HStack {
                    Button(action: {
                        addTask(viewModel.default1)
                    }) {
                        Text(viewModel.default1)
                        Image(systemName: "command")
                        Text("1")
                    }
                    .keyboardShortcut("1", modifiers: .command)
                    Button(action: {
                        addTask(viewModel.default2)
                    }) {
                        Text(viewModel.default2)
                        Image(systemName: "command")
                        Text("2")
                    }
                    .keyboardShortcut("2", modifiers: .command)
                    Button(action: {
                        addTask(viewModel.default3)
                    }) {
                        Text(viewModel.default3)
                        Image(systemName: "command")
                        Text("3")
                    }
                    .keyboardShortcut("3", modifiers: .command)
                }
                TextField("Enter Your Task", text: $stringExpense, onCommit: {
                    saveExpense()
                })
                .padding()
                
                HStack {
                    
                    VStack {
                        HStack {
                            Text("To-do List:")
                                .font(.title2)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            Button(action: {
                                removeAllExpense()
                            }, label: {
                                Text("Mark All as Complete")
                                Image(systemName: "command")
                                Image(systemName: "return")
                            })
                            .padding()
                            .keyboardShortcut(.return, modifiers: .command)
                            
                            Button(action: {
                                removePersonal()
                            }, label: {
                                Text("")
                            })
                            .opacity(0)
                            .keyboardShortcut(.return, modifiers: [.command, .shift])
                            
                            Button(action: {
                                removeWork()
                            }, label: {
                                Text("")
                            })
                            .opacity(0)
                            .keyboardShortcut(.return, modifiers: [.command, .option])
                            
                            
                        }
                        ForEach(savedTexts.indices, id: \.self) { index in
                            HStack {
                                if index == editingIndex && isEditing {
                                    TextField("Edit", text: $changedTerm, onCommit: {
                                        saveChanges()
                                    })
                                    .padding()
                                    .background(hoveredIndex == index ? Color.blue.opacity(0.2) : Color.clear)
                                    .onHover { hovering in
                                        hoveredIndex = hovering ? index : nil
                                    }
                                } else {
                                    let pinned = index == 0
                                    Button(action: {
                                        removeExpense(at: index, from: &savedTexts)
                                    }) {
                                        HStack {
                                            if pinned {
                                                Image(systemName: "pin.fill")
                                            }
                                            Text(savedTexts[index])
                                                .padding()
                                                .background(hoveredIndex == index ? Color.blue.opacity(0.2) : Color.clear)
                                        }
                                    }
                                    .contextMenu {
                                        Button("Pin to Top") {
                                            pinItemToTop(index)
                                        }
                                        Button("Edit") {
                                            beginEditing(at: index)
                                        }
                                        Button("Complete") {
                                            removeExpense(at: index, from: &savedTexts)
                                        }
                                        Button("Add to \(viewModel.cateogry1)") {
                                            removeExpenseToPersonal(at: index, from: &savedTexts)
                                        }
                                        Button("Add to \(viewModel.cateogry2)") {
                                            removeExpenseToWork(at: index, from: &savedTexts)
                                        }
                                        Button("Encrypt") {
                                            removeExpenseToEncrypted(at: index, from: &savedTexts)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        Text(viewModel.cateogry1)
                            .font(.title3)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .padding(personalTasks.count > 0 ? 10 : 0)
                        ForEach(personalTasks.indices, id:\.self) { index in
                            HStack {
                                Text(personalTasks[index])
                                    .padding()
                                    .onHover { hovering in
                                        personalTaskIndex = hovering ? index : nil
                                        isHovered = true
                                    }
                                    .onTapGesture {
                                        removeExpense(at: index, from: &personalTasks)
                                    }
                            }
                        }
                        
                        Text(viewModel.cateogry2)
                            .font(.title3)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .padding(workTasks.count > 0 ? 10 : 0)
                        ForEach(workTasks.indices, id:\.self) { index in
                            HStack {
                                Text(workTasks[index])
                                    .padding()
                                    .onHover { hovering in
                                        workTaskIndex = hovering ? index : nil
                                        isHovered = true
                                    }
                                    .onTapGesture {
                                        removeExpense(at: index, from: &workTasks)
                                    }
                            }
                        }
                        
                        var savedDefaults = UserDefaults.standard.set(savedTexts, forKey: "savedTexts")
                        
                        let encryptedList = {
                            ForEach(encryptedTasks.indices, id:\.self) { index in
                                HStack {
                                    Text(encryptedTasks[index])
                                        .padding()
                                        .onHover { hovering in
                                            encryptedTaskIndex = hovering ? index : nil
                                            isHovered = true
                                        }
                                        .onTapGesture {
                                            removeExpense(at: index, from: &encryptedTasks)
                                        }
                                    }
                                }
                        }
                        
                        HStack {
                            Image(systemName: "lock.fill")
                            Text("Encrypted Tasks")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        PassView()
                        
                        if viewModel.passIsCorrect == true && isEncryptedVisible == true {
                            encryptedList()
                                .opacity(1)
                            
                            Button(action: {
                                closeEncryptedWindow()
                            }) {
                                Image(systemName: "x.circle")
                            }
                            
                        } else if isEncryptedVisible == false {
                            encryptedList()
                                .opacity(0)
                        }
                                        
                        HStack {
                            Text("Completed Tasks:")
                                .font(.title2)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            Button(action: {
                                removeAllComplete()
                            }, label: {
                                Text("Delete All")
                                Image(systemName: "command")
                                Image(systemName: "delete.left.fill")
                            })
                            .padding()
                            .keyboardShortcut(.delete, modifiers: .command)
                        }
                        
                        ForEach(completedTexts.indices, id: \.self) { index in
                            HStack {
                                Text(completedTexts[index])
                                    .padding()
                                    .background(completedHoveredIndex == index ? Color.blue.opacity(0.2) : Color.clear)
                                    .onHover { hovering in
                                        completedHoveredIndex = hovering ? index : nil
                                        isHovered = true
                                    }
                                    .onTapGesture {
                                        removeExpense(at: index, from: &completedTexts)
                                    }
                                if completedHoveredIndex == index {
                                    Button(action: {
                                        removeExpense(at: index, from: &completedTexts)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                        
                        var completedDefaults = UserDefaults.standard.set(completedTexts, forKey: "completedTexts")
                    }
                }
                
                Divider()
                    .padding()
                
            }
            .onAppear {
                printLists()
            }
            .background(backgroundColorForm)
        }
        
        
        HStack {
            
            VStack {
                
                HStack {
                    
                    Image(systemName: "stopwatch")
                    Text("Stopwatch:")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Text("\(timeElapsed, specifier: "%.0f")")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    
                    Button(action: {
                        timerIsRunning.toggle()
                    }, label: {
                        Text(timerIsRunning ? "Pause" : "Start")
                    })
                    .padding()
                    .keyboardShortcut("s", modifiers: .command)
                    
                    Button(action: {
                        timeElapsed = 0
                    }, label: {
                        Text("Reset")
                    })
                    .padding()
                    .keyboardShortcut("r", modifiers: .command)
                }
            }
            .onReceive(timer) { _ in
                if timerIsRunning {
                    timeElapsed += 1
                }
            }
            
            TimerView()
        }
    }
    
    private func saveExpense() {
        guard !stringExpense.isEmpty else { return }
        savedTexts.append(stringExpense)
        stringExpense = ""
    }
    
    private func removeExpense(at index: Int, from array: inout [String]) {
        guard array.indices.contains(index) else { return }
        deletedItem = array[index] // Record the deleted item
        array.remove(at: index)
        completedTexts.append(deletedItem!) // Append deleted item to completed tasks
        hoveredIndex = nil
    }
    
    private func removeExpenseToPersonal(at index: Int, from array: inout [String]) {
        guard array.indices.contains(index) else { return }
        deletedItem = array[index] // Record the deleted item
        array.remove(at: index)
        personalTasks.append(deletedItem!) // Append deleted item to completed tasks
        hoveredIndex = nil
    }
    
    private func removeExpenseToWork(at index: Int, from array: inout [String]) {
        guard array.indices.contains(index) else { return }
        deletedItem = array[index] // Record the deleted item
        array.remove(at: index)
        workTasks.append(deletedItem!) // Append deleted item to completed tasks
        hoveredIndex = nil
    }
    
    private func removeExpenseToEncrypted(at index: Int, from array: inout [String]) {
        guard array.indices.contains(index) else { return }
        deletedItem = array[index]
        array.remove(at: index)
        encryptedTasks.append(deletedItem!)
        hoveredIndex = nil
    }
    
    private func removeAllExpense() {
        completedTexts.append(contentsOf: savedTexts)
        completedTexts.append(contentsOf: personalTasks)
        completedTexts.append(contentsOf: workTasks)
        savedTexts.removeAll()
        personalTasks.removeAll()
        workTasks.removeAll()
    }
    
    private func removeAllComplete() {
        completedTexts.removeAll()
    }
    
    private func removePersonal() {
        completedTexts.append(contentsOf: personalTasks)
        personalTasks.removeAll()
    }
    
    private func removeWork() {
        completedTexts.append(contentsOf: workTasks)
        workTasks.removeAll()
    }
    
    private func newDay() {
        savedTexts.removeAll()
        completedTexts.removeAll()
    }
    
    private func printLists() {
        print("To-do List: \(savedTexts)")
        print("Completed Tasks: \(completedTexts)")
    }
    
    private func beginEditing(at index: Int) {
        isEditing = true
        editingIndex = index
        changedTerm = savedTexts[index]
    }
    
    private func saveChanges() {
        if let index = editingIndex {
            savedTexts[index] = changedTerm
            isEditing = false
            editingIndex = nil
        }
    }
    
    private func pinItemToTop(_ index: Int) {
        if index != 0 && index < savedTexts.count {
            let itemToPin = savedTexts.remove(at: index)
            savedTexts.insert(itemToPin, at: 0)
        }
    }
    
    private func addTask(_ task: String) {
        savedTexts.append(task)
    }
    
    func startClock() {
        // Start a timer to update the current time every second
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            currentTime = Date()
        }
    }
    
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            currentTime = Date()
        }
    }
    
    func currentTimeFormatted() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: currentTime)
    }
    
    func isPastNoon() -> Bool {
        let calendar = Calendar.current
        let noon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: currentTime)!
        let evening = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: currentTime)!
        return currentTime > noon && currentTime < evening
    }
    
    func isEvening() -> Bool {
        let calendar = Calendar.current
        let evening = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: currentTime)!
        return currentTime > evening
    }
    
    func isNewDay() -> Bool {
        let calendar = Calendar.current
        let evening = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentTime)!
        return currentTime > evening
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
    
    private func closeEncryptedWindow() {
        if self.isEncryptedVisible == true {
            self.isEncryptedVisible = false
        }
    }
    
    func colorFromString(_ string: String) -> Color? {
        switch string.lowercased() {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        case "white": return .white
        case "black": return .black
        case "gray": return .gray
        case "mint": return .mint
        case "teal": return .teal
        case "cyan": return .cyan
        case "indigo": return .indigo
        case "turquoise": return Color(red: 0.25098, green: 0.99686, blue: 0.90254)
        
        default: return .clear
            
        }
    }

}

    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
