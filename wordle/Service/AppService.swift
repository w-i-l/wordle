//
//  AppService.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI
import Combine

class AppService {
    var words: Set<String> = .init()
    
    var hasUserTriedWordNotification: CurrentValueSubject<Bool, Never> = .init(false)
    var wordToGuess: String = ""
    var patterns: CurrentValueSubject<[[PatternType]], Never> = .init([])
    
    static let shared = AppService()
    
    private init() {
        self.words = fetchWords()
        wordToGuess = self.words.randomElement()!
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
}
