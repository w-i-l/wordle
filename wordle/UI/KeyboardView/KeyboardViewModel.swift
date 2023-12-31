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
    
    private var stringValue: String {
        KeyboardService.shared.stream.value
    }
    
    private var canUserType: Bool {
        KeyboardService.shared.canUserType.value
    }
    
    func type(letter: String) {
        guard stringValue.count <= 35 && canUserType else { return }
        let canAddLetter = stringValue.count % 6 < 5
        if canAddLetter {
            KeyboardService.shared.stream.value += letter
        }
    }
    
    func delete() {
        guard stringValue.count > 0 && canUserType else { return }
        let hasNewLineChar = [0].contains(stringValue.count % 6) && stringValue.count >= 5
        if hasNewLineChar {
            return
        } else {
            let prefixCount = stringValue.count - 1
            KeyboardService.shared.stream.value = String(stringValue.prefix(prefixCount))
        }
    }
    

    
    func enter() {
        if stringValue.count % 6 == 5 && canUserType {
            KeyboardService.shared.separateWords()
            AppService.shared.hasUserTriedWordNotification.value = true
        }
    }
}
