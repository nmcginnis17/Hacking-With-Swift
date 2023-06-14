//
//  Move.swift
//  Four in a Row
//
//  Created by Nicholas McGinnis on 1/14/23.
//

import GameplayKit
import UIKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
}
