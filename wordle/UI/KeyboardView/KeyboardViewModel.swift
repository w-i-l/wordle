//
//  KeyboardViewModel.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    var bag = Set<AnyCancellable>()
}


class KeyboardViewModel: BaseViewModel {
    
    var stringValue: String {
        KeyboardService.shared.stream.value
    }
    
    func type(letter: String) {
        guard stringValue.count <= 35 else { return }
        KeyboardService.shared.stream.value += letter
    }
    
    func delete() {
        guard stringValue.count > 0 else { return }
        let hasNewLineChar = [0, 1].contains(stringValue.count % 6) && stringValue.count >= 5
        let prefixCount = stringValue.count - (hasNewLineChar ? 2 : 1)
        KeyboardService.shared.stream.value = String(stringValue.prefix(prefixCount))
    }
    
    func enter() {
        if stringValue.count % 6 == 5 {
            type(letter: "\n")
        }
    }
}
