//
//  Tune.swift
//  What's that tune
//
//  Created by Nicholas McGinnis on 1/8/23.
//

import CloudKit
import UIKit

class Tune: NSObject {
    var recordID: CKRecord.ID!
    var genre: String!
    var comments: String!
    var audio: URL!
}
