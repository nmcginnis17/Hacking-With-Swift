//
//  Board.swift
//  Four in a Row
//
//  Created by Nicholas McGinnis on 1/12/23.
//  Model

import UIKit

enum ChipColor: Int {
    case none = 0
    case red
    case black
}

class Board: NSObject {
    static var width = 7
    static var height = 6
    
    var currentPlayer: Player
    
    var slots = [ChipColor]()
    
    override init() {
        currentPlayer = Player.allPlayers[0]
        for _ in 0 ..< Board.width * Board.height {
            slots.append(.none)
        }
        super.init()
    }
    
    func chip(inColumn column: Int, row: Int) -> ChipColor {
        return slots[row + column * Board.height]
    }
    
    func set(chip: ChipColor, in column: Int, row: Int) {
        slots[row + column * Board.height] = chip
    }
    
    func nextEmptySlot(in column: Int) -> Int? {
        for row in 0 ..< Board.height {
            if chip(inColumn: column, row: row) == .none {
                return row
            }
        }
        return nil
    }
    
    func canMove(in column: Int) -> Bool {
        return nextEmptySlot(in: column) != nil
    }
    
    func add(chip: ChipColor, in column: Int) {
        if let row = nextEmptySlot(in: column) {
            set(chip: chip, in: column, row: row)
        }
    }
    
    func isFull() -> Bool {
        for column in 0 ..< Board.width {
            if canMove(in: column) {
                return false
            }
        }
        return true
    }
    
    func isWin(for player: Player) -> Bool {
        return false
    }
    
    func squaresMatch(initialChip: ChipColor, row: Int, col: Int, moveX: Int, moveY: Int) -> Bool {
        // break early if we can not win
        if row + (moveY * 3) < 0 { return false }
        if row + (moveY * 3) >= Board.height { return false }
        if col + (moveX * 3) < 0 { return false}
        if col + (moveX * 3) >= Board.width { return false }
        
        // Check every square
        if chip(inColumn: col, row: row) != initialChip { return false }
        if chip(inColumn: col + moveX, row: row + moveY) != initialChip { return false }
        if chip(inColumn: col + (moveX * 2), row: row + (moveY * 2)) != initialChip { return false }
        if chip(inColumn: col + (moveX * 3), row: row + (moveY * 3)) != initialChip { return false }
        
        return true
    }
    
}
