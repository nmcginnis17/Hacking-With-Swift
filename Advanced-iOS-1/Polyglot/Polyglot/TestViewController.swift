//
//  TestViewController.swift
//  Polyglot
//
//  Created by Nicholas McGinnis on 7/4/23.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var prompt: UILabel!
    
    var words: [String]!
    var questionCounter = 0
    var showingQuestion = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(nextTapped))
        
        words.shuffle()
        title = "Test"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // the view was just shown, start asking questions now
        askQuestion()
    }
    
    func askQuestion() {
        // move question counter 1
        questionCounter += 1
        if questionCounter == words.count {
            // wrap it back to 0 if we've gone beyond size of array
            questionCounter = 0
        }
        
        // pull French word at the current question position
        prompt.text = words[questionCounter].components(separatedBy: "::")[1]
    }

    @objc func nextTapped() {
        // move between showing question and answer
        showingQuestion = !showingQuestion
        
        if showingQuestion {
            // show question - reset!
            prepareForNextQuestion()
        } else {
            // we should be showing answer, show it now, set the color to green
            prompt.text = words[questionCounter].components(separatedBy: "::")[0]
            prompt.textColor = UIColor(red: 0, green: 0.7, blue: 0, alpha: 1)
        }
    }
    
    func prepareForNextQuestion() {
        // reset prompt to black
        prompt.textColor = UIColor.black
        
        // proceed with next question
        askQuestion()
    }
    
}
