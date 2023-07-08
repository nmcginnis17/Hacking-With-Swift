//
//  Helper.swift
//  Alarmadillo
//
//  Created by Nicholas McGinnis on 7/7/23.
//

import Foundation

struct Helper {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        return documentsDirectory
    }
}
