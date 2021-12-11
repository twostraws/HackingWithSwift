//
//  FileManager-DocumentsDirectory.swift
//  Bucketlist
//
//  Created by Paul Hudson on 11/12/2021.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
