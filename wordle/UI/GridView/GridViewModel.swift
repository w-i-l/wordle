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
    
    func getColor() -> Color {
        switch self {
        case .matched:
            return .green
        case .found:
            return .yellow
        case .notFound:
            return .gray
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
                    if AppService.shared.self.doesWordExist(word: lastWord) {
                        
                        // we append the pattern
                        self?.lastRow = KeyboardService.shared.stream.value.split(separator: "\n").count - 1
                        let patternToAppend = self!.matchWord(row: self!.lastRow)
                        AppService.shared.patterns.value.append(patternToAppend)
                        
                        // check for the end of game
                        if patternToAppend == Array(repeating: PatternType.matched, count: 5) {
                            AppService.shared.didGameEnded.value = true
                        }
                    // if the word doesn't exist
                    } else {
                        AppService.shared.invalidWordEntered.value = true
                        
                        // remove the last word
                        let string = KeyboardService.shared.stream.value
                        let newArrayOfString = string.split(separator: "\n").dropLast(1)
                        let newString = String(newArrayOfString.joined(separator: "\n"))
                        KeyboardService.shared.stream.value = newString
                        
                        // remove its pattern too
                        let patterns = AppService.shared.patterns.value
                        AppService.shared.patterns.value = patterns.dropLast(1)
                        
                        return
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
