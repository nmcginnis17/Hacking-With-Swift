//
//  ViewController.swift
//  Guess the Flag
//
//  Created by Nicholas McGinnis on 9/3/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var correctAnswer = 0
    var questionsAsked = 0
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        correctAnswer = Int.random(in: 0...2)
        questionsAsked += 1
        updateTitle()
    }
    
    func restart(action: UIAlertAction) {
        questionsAsked = 0
        score = 0
        askQuestion()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
            if sender.tag == correctAnswer {
                title = "Correct"
                score += 1
            } else {
                title = "Wrong! That flag belongs to \(countries[sender.tag].uppercased())"
//                score -= 1
            }
        
            if questionsAsked == 10 {
                let ac1 = UIAlertController(title: "Your score is \(score)/\(questionsAsked)", message: "Would you like to restart?", preferredStyle: .alert)
                print("Your score is \(score)/\(questionsAsked)")
                ac1.addAction(UIAlertAction(title: "Restart", style: .default, handler: restart))
                present(ac1, animated: true)
            } else {
                let ac2 = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
                ac2.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac2, animated:  true)
            }
    }
    
    func updateTitle() {
        title = "\(countries[correctAnswer].uppercased()) - Score: \(score)/\(questionsAsked)"
    }
    
}

