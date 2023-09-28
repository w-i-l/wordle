//
//  AppService.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI
import Combine

class AppService: BaseViewModel {
    var words: Set<String> = .init()
    
    var hasUserTriedWordNotification: CurrentValueSubject<Bool, Never> = .init(false)
    var wordToGuess: CurrentValueSubject<String, Never> = .init("")
    var patterns: CurrentValueSubject<[[PatternType]], Never> = .init([])
    var didGameEnded: CurrentValueSubject<Bool, Never> = .init(false)
    
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
        patterns.value = []
        
        KeyboardService.shared.stream.value = ""
    }
}
