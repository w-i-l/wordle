//
//  ModelViewModel.swift
//  wordle
//
//  Created by Mihai Ocnaru on 03.10.2023.
//

import Combine
import SwiftUI

class ModalViewModel: BaseViewModel {
    @Published var didGameEnded: GameState = .playing
    
    override init() {
        
        super.init()
        
        AppService.shared.didGameEnded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] didGameEnded in
                self?.didGameEnded = didGameEnded
            }
            .store(in: &bag)
        
    }
    
    func getURL() -> URL {
        let wordToGuess = AppService.shared.wordToGuess.value
        let website = "https://www.dictionary.com/browse/\(wordToGuess)"
        return URL(string: website)!
    }
    
}
