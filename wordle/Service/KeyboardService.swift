//
//  KeyboardService.swift
//  wordle
//
//  Created by Mihai Ocnaru on 28.09.2023.
//

import Foundation
import Combine

class KeyboardService {
    static let shared = KeyboardService()
    
    private init() {}
    
    private(set) var stream: CurrentValueSubject<String, Never> = .init("")
    var isKeyboardVisible: CurrentValueSubject<Bool, Never> = .init(false)
    var canUserType: CurrentValueSubject<Bool, Never> = .init(true)
    
    func emptyStream() {
        self.stream.value = ""
    }
}
