//
//  String_Extenstion.swift
//  NetflixClone
//
//  Created by Agata Menes on 06/02/2023.
//

import Foundation
import UIKit
extension String {
    var capitalizedSentence: String {
        // 1
        let firstLetter = self.prefix(1).capitalized
        // 2
        let remainingLetters = self.dropFirst().lowercased()
        // 3
        return firstLetter + remainingLetters
    }
}
