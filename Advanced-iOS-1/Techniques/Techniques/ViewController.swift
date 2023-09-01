//
//  ViewController.swift
//  Techniques
//
//  Created by Nicholas McGinnis on 7/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    var animator: UIViewPropertyAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        view.addSubview(slider)
        
        slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        slider.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(boxTapped))
        let redBox = UIView(frame: CGRect(x: -64, y: 0, width: 128, height: 128))
        redBox.translatesAutoresizingMaskIntoConstraints = false
        redBox.backgroundColor = UIColor.red
        redBox.center.y = view.center.y
        redBox.addGestureRecognizer(recognizer)
        view.addSubview(redBox)
        
        animator = UIViewPropertyAnimator(duration: 20, dampingRatio: 0.5) { [unowned self, redBox] in
            redBox.center.x = self.view.frame.width
            redBox.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        
        let play = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playTapped))
        
        let flip = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(reversedTapped))
        
        navigationItem.rightBarButtonItems = [play, flip]
    }
    
    @objc func boxTapped() {
        print("BOX TAPPED!")
    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        animator.fractionComplete = CGFloat(sender.value)
    }
    
    @objc func playTapped(_ sender: UIButton){
        // if the animation has started
        if animator.state == .active {
            // stop animation
            animator.stopAnimation(false)
            animator.finishAnimation(at: .end)
        } else {
            // not started yet; start it now
            animator.startAnimation()
        }
    }

    @objc func reversedTapped(_ sender: UIButton) {
        animator.isReversed = true
    }

}

