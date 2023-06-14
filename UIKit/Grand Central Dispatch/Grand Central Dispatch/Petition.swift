//
//  Petition.swift
//  Grand Central Dispatch
//
//  Created by Nicholas McGinnis on 9/12/22.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
