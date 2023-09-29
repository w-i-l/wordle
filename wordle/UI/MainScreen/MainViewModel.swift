//
//  MainViewModel.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI

class MainViewModel: BaseViewModel {
    @Published var stream: String = ""
    @Published var wordToGuess: String = ""
    @Published var didGameEnded: Bool = false

    override init() {
        super.init()
        
        KeyboardService.shared.stream
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stream in
                self?.stream = stream
                if stream.count == 35 && AppService.shared.didGameEnded.value == .playing {
                    AppService.shared.didGameEnded.value = .lose
                }
            }
            .store(in: &bag)
        
        AppService.shared.wordToGuess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] wordToGuess in
                self?.wordToGuess = wordToGuess
            }
            .store(in: &bag)
        
        AppService.shared.didGameEnded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] didGameEnded in
                self?.didGameEnded = didGameEnded != .playing
            }
            .store(in: &bag)
        
    }
}
