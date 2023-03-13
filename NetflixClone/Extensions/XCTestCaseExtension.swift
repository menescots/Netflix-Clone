//
//  XCTestCaseExtension.swift
//  NetflixClone
//
//  Created by Agata Menes on 10/03/2023.
//

import Foundation
import XCTest

extension XCTestCase {
    func dataFrom(filename: String) -> Data {
        let path = Bundle(for: Title.self).path(forResource: filename, ofType: "json")!
        return NSData(contentsOfFile: path)! as Data
    }
}
