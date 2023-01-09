//
//  ViewController.swift
//  What's that tune
//
//  Created by Nicholas McGinnis on 1/5/23.
//

import UIKit

class ViewController: UIViewController {
    
    static var isDirty = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "What's that Tune?"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTune))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
    }
    
    
    @objc func addTune() {
        let vc = RecordTuneViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


}

