//
//  MainViewModel.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI

class MainViewModel: BaseViewModel {
    @Published var stream: String = ""
    @Published var wordToGuess: String
    
    override init() {
        self.wordToGuess = AppService.shared.wordToGuess
        super.init()
        
        KeyboardService.shared.stream
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stream in
                self?.stream = stream
                if stream.count % 6 == 5 {
                    KeyboardService.shared.stream.value += "\n"
                    AppService.shared.hasUserTriedWordNotification.value = true
                }
            }
            .store(in: &bag)
    }
}
