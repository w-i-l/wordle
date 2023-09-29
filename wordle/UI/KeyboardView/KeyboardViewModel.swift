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
    
    private var canUserType: Bool {
        KeyboardService.shared.canUserType.value
    }
    
    func type(letter: String) {
        guard stringValue.count <= 35 && canUserType else { return }
        KeyboardService.shared.stream.value += letter
    }
    
    func delete() {
        guard stringValue.count > 0 && canUserType else { return }
        let hasNewLineChar = [0].contains(stringValue.count % 6) && stringValue.count >= 5
        if hasNewLineChar {
            return
//            let prefixCount = stringValue.count - 2
//            KeyboardService.shared.stream.value = String(stringValue.prefix(prefixCount))
//            
//            AppService.shared.hasUserTriedWordNotification.value = false
//            let patterns = AppService.shared.patterns.value
//            AppService.shared.patterns.value = (0..<(patterns.count - 1)).map {
//                patterns[$0]
//            }
        } else {
            let prefixCount = stringValue.count - 1
            KeyboardService.shared.stream.value = String(stringValue.prefix(prefixCount))
        }
    }
    
    func enter() {
        if stringValue.count % 6 == 5 && canUserType {
            type(letter: "\n")
            AppService.shared.hasUserTriedWordNotification.value = true
        }
    }
}
