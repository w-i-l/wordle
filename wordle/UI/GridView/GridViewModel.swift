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
    @Published private var lastRow: Int = 0
    
    @Published var patterns: [[PatternType]] = []
    
    override init() {
        
        super.init()
        
        AppService.shared.hasUserTriedWordNotification
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasUserTriedWordNotification in
                if hasUserTriedWordNotification {
                    self?.lastRow = KeyboardService.shared.stream.value.split(separator: "\n").count - 1
                    let patternToAppend = self!.matchWord(row: self!.lastRow)
                    AppService.shared.patterns.value.append(patternToAppend)
                    if patternToAppend == Array(repeating: PatternType.matched, count: 5) {
                        AppService.shared.didGameEnded.value = true
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
