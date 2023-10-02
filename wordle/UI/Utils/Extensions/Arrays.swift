//
//  Arrays.swift
//  wordle
//
//  Created by Mihai Ocnaru on 29.09.2023.
//

import Foundation

extension [[PatternType]] {
    subscript (_ row: Int, _ column: Int) -> PatternType? {
        get {
            guard row >= 0 && row < self.count else { return nil }
            
            let patternType = self[row]
            
            guard column >= 0 && column < patternType.count else { return nil}
            return patternType[column]
        }
        
        set(newValue) {
            guard row >= 0 && row < self.count else { return }
            
            var patternType = self[row]
            
            guard column >= 0 && column < patternType.count else { return }
            
            if let newValue = newValue {
                patternType[column] = newValue
                self[row] = patternType
            }
        }
    }
}

extension [String] {
    subscript (_ row: Int, _ column: Int) -> String? {
        guard row >= 0 && row < self.count else { return nil }
        
        let string = self[row]
        
        guard column >= 0 && column < string.count else { return nil}
        let index = string.index(string.startIndex, offsetBy: column)
        return String(string[index])
    }
}

extension [[Bool]] {
    
    subscript (_ row: Int, _ column: Int) -> Bool? {
        get {
            guard row >= 0 && row < self.count else { return nil }
            
            let shouldReturn = self[row]
            
            guard column >= 0 && column < shouldReturn.count else { return nil}
            return shouldReturn[column]
        }
        
        set(newValue) {
            guard row >= 0 && row < self.count else { return }
            
            var rowArray = self[row]
            
            guard column >= 0 && column < rowArray.count else { return }
            
            if let newValue = newValue {
                rowArray[column] = newValue
                self[row] = rowArray
            }
        }
    }
}
