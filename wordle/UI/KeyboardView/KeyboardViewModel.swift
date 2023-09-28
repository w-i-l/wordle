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
    func type(letter: String) {
        KeyboardService.shared.stream.value += letter
    }
    
    func delete() {
        let stringValue = KeyboardService.shared.stream.value
        KeyboardService.shared.stream.value = String(stringValue.prefix(stringValue.count - 1))
    }
}
