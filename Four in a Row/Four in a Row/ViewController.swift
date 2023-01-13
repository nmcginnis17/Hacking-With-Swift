//
//  ViewController.swift
//  Four in a Row
//
//  Created by Nicholas McGinnis on 1/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    var placedChips = [[UIView]]()
    var board: Board!
    
    @IBOutlet var columnButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }
        resetBoard()
    }
    
    @IBAction func makeMove(_ sender: UIButton) {
        
    }
    
    func resetBoard() {
        board = Board()
        
        for i in 0 ..< placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }
            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    


}

