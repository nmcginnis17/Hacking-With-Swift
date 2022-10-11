//
//  WhackSlot.swift
//  Whack-A-Penguin
//
//  Created by Nicholas McGinnis on 10/10/22.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
    }
    
}
