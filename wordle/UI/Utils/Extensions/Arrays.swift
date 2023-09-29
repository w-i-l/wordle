//
//  Arrays.swift
//  wordle
//
//  Created by Mihai Ocnaru on 29.09.2023.
//

import Foundation

extension [[PatternType]] {
    func index(row: Int, column: Int) -> PatternType? {
        guard row >= 0 && row < self.count else { return nil }
        
        let patternType = self[row]
        
        guard column >= 0 && column < patternType.count else { return nil}
        return patternType[column]
    }
}

extension [String] {
    func index(row: Int, column: Int) -> String? {
        guard row >= 0 && row < self.count else { return nil }
        
        let string = self[row]
        
        guard column >= 0 && column < string.count else { return nil}
        let index = string.index(string.startIndex, offsetBy: column)
        return String(string[index])
    }
}
