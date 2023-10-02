//
//  AppService.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI
import Combine

enum GameState {
    case win
    case lose
    case playing
}

class AppService: BaseViewModel {
    var words: Set<String> = .init()
    
    var hasUserTriedWordNotification: CurrentValueSubject<Bool, Never> = .init(false)
    var wordToGuess: CurrentValueSubject<String, Never> = .init("")
    var patterns: CurrentValueSubject<[[PatternType]], Never> = .init(
        (0..<6).map { _ in
            return Array(repeating: PatternType.none, count: 5)
    })
    var didGameEnded: CurrentValueSubject<GameState, Never> = .init(.playing)
    var invalidWordEntered: CurrentValueSubject<Bool, Never> = .init(false)
    
    static let shared = AppService()
    
    override private init() {
        super.init()
        
        self.words = fetchWords()
        wordToGuess.value = self.words.randomElement()!
    }
    
    func fetchWords() -> Set<String> {
        if let fileURL = Bundle.main.url(forResource: "wordle-words", withExtension: "txt") {
            do {
                let content = try String(contentsOf: fileURL)
                let words = content.split(separator: "\n").map {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                return Set(words)
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
        return []
    }
    
    func newGame() {
        wordToGuess.value = self.words.randomElement()!
        
        hasUserTriedWordNotification.value = false
        didGameEnded.value = .playing
        patterns.value = .init(
            (0..<6).map { _ in
                return Array(repeating: PatternType.none, count: 5)
        })
        
        KeyboardService.shared.stream.value = ""
        KeyboardService.shared.canUserType.value = true
    }
    
    func doesWordExist(word: String) -> Bool {
        return self.words.contains(word)
    }
}
