//
//  GridViewModel.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI

enum PatternType {
    case matched
    case found
    case notFound
    case none
    
    func getColor() -> Color {
        switch self {
        case .matched:
            return .green
        case .found:
            return .yellow
        case .notFound:
            return .gray
        case .none:
            return .clear
        }
    }
}

class GridViewModel: BaseViewModel {
    @Published var lastRow: Int = 0
    var currentRow: Int {
        let noWords = KeyboardService.shared.stream.value.contains("\n")
        if lastRow == 0 && !noWords {
            return 0
        } else if lastRow < 5 {
            return lastRow + 1
        }
        
        return 0
    }
    
    @Published var patterns: [[PatternType]] = []
    @Published var invalidWordEntered: Bool = false
    @Published var shouldRotateMatrix: [[Bool]] = (0..<6).map { _ in
        return Array(repeating: false, count: 5)
    }
    override init() {
        
        super.init()
        
        AppService.shared.invalidWordEntered
            .receive(on: DispatchQueue.main)
            .sink { [weak self] invalidWordEntered in
                self?.invalidWordEntered = invalidWordEntered
            }
            .store(in: &bag)
        
        AppService.shared.hasUserTriedWordNotification
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasUserTriedWordNotification in
                
                // if we entered a row
                guard hasUserTriedWordNotification else { return }
                
                if let lastWord = KeyboardService.shared.stream.value.split(separator: "\n").last {
                    
                    // we verify that the user entered a real word from list
                    let lastWord = String(lastWord.lowercased())
                    guard !lastWord.isEmpty else { return }
                    if AppService.shared.self.doesWordExist(word: lastWord) {
                        
                        DispatchQueue.main.async {
                            // block user from writing
                            KeyboardService.shared.canUserType.send(false)
                        }
                        
                        // we append the pattern
                        self?.lastRow = KeyboardService.shared.stream.value.split(separator: "\n").count - 1
                        let patternToAppend = self!.matchWord(row: self!.lastRow)
                        for column in 0..<5 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(column)) {
                                self?.shouldRotateMatrix[self!.lastRow, column] = true
                                AppService.shared.patterns.value[self!.lastRow, column] = patternToAppend[column]
                                print(KeyboardService.shared.canUserType.value)
                            }
                        }
                        
                        // block hardcoded since using DispatchQueue.main will execute before this line
                        // ask for help
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            // block user from writing
                            KeyboardService.shared.canUserType.send(true)
                            // check for the end of game
                            if patternToAppend == Array(repeating: PatternType.matched, count: 5) {
                                
                                AppService.shared.didGameEnded.value = .win
                            }
                        }
                        
                        
                        // if the word doesn't exist
                    } else {
                        AppService.shared.invalidWordEntered.value = true
                        
                        // remove the last word
                        let string = KeyboardService.shared.stream.value
                        let newArrayOfString = string.split(separator: "\n").dropLast(1)
                        let newString = String(newArrayOfString.joined(separator: "\n"))
                        if let lastChar = newString.last, lastChar != "\n" {
                            KeyboardService.shared.stream.value = newString + "\n"
                        } else {
                            KeyboardService.shared.stream.value = newString
                        }
                        
                        // remove its pattern too
                        let row = string.count.quotientAndRemainder(dividingBy: 6).quotient
                        AppService.shared.patterns.value[row] = Array(repeating: PatternType.none, count: 5)
                    }
                    
                }
            }
            .store(in: &bag)
        
        AppService.shared.patterns
            .receive(on: DispatchQueue.main)
            .sink { [weak self] patterns in
                self?.patterns = patterns
            }
            .store(in: &bag)
        
        AppService.shared.didGameEnded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] didGameEnded in
                self?.lastRow = 0
                self?.invalidWordEntered = false
                self?.shouldRotateMatrix = (0..<6).map { _ in
                    return Array(repeating: false, count: 5)
                    
                }
            }
            .store(in: &bag)
    }
    
    private func matchWord(row: Int) -> [PatternType] {
        
        AppService.shared.hasUserTriedWordNotification.value = false
        
        let string = KeyboardService.shared.stream.value
        let words = string.split(separator: "\n")
        let wordToMatch = words[row]
        
        let wordToGuess = AppService.shared.wordToGuess.value.uppercased()
        
        return wordToMatch.enumerated().map {
            if $0.element == wordToGuess[wordToGuess.index(wordToGuess.startIndex, offsetBy: $0.offset)] {
                return PatternType.matched
            } else if wordToGuess.contains($0.element) {
                return PatternType.found
            } else {
                return PatternType.notFound
            }
        }
    }
}
