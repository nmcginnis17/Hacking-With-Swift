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
        
        let redBox = UIView(frame: CGRect(x: -64, y: 0, width: 128, height: 128))
        redBox.translatesAutoresizingMaskIntoConstraints = false
        redBox.backgroundColor = UIColor.red
        redBox.center.y = view.center.y
        view.addSubview(redBox)
        
        animator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) { [unowned self, redBox] in
            redBox.center.x = self.view.frame.width
            redBox.transform = CGAffineTransform(rotationAngle: CGFloat.pi).scaledBy(x: 0.001, y: 0.001)
        }
        
        let play = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playTapped))
        
        let flip = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(reversedTapped))
        
        navigationItem.rightBarButtonItems = [play, flip]
    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        animator.fractionComplete = CGFloat(sender.value)
    }
    
    @objc func playTapped(_ sender: UIButton){
        // if the animation has started
        if animator.state == .active {
            // if its current in motion
            if animator.isRunning {
                // pause
                animator.pauseAnimation()
            } else {
                // continue at the same speed
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            }
        } else {
            // not started yet; start it now
            animator.startAnimation()
        }
    }

    @objc func reversedTapped(_ sender: UIButton) {
        animator.isReversed = true
    }

}

