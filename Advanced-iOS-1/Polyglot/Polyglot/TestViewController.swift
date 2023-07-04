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
        
        stackView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        stackView.alpha = 0
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
        
        let animation = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5) {
            self.stackView.alpha = 1
            self.stackView.transform = CGAffineTransform.identity
        }
        
        animation.startAnimation()
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
        let animation = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { [unowned self] in
            self.stackView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.stackView.alpha = 0
        }
        
        animation.addCompletion { [unowned self] position in
            self.prompt.textColor = UIColor.black
            self.askQuestion()
        }
        
        animation.startAnimation()
    }
    
}
