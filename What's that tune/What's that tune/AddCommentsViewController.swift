//
//  AddCommentsViewController.swift
//  What's that tune
//
//  Created by Nicholas McGinnis on 1/7/23.
//

import UIKit

class AddCommentsViewController: UIViewController, UITextViewDelegate {

    var genre: String!
    var comments: UITextView!
    let placeholder = "If you have any additional comments that might help identify your tune, enter them here."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitTapped))
        comments.text = placeholder
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        comments = UITextView()
        comments.translatesAutoresizingMaskIntoConstraints = false
        comments.delegate = self
        comments.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(comments)
        
        comments.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        comments.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        comments.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        comments.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func submitTapped() {
        let vc = SubmitViewController()
        vc.genre = genre
        
        if comments.text == placeholder {
            vc.comments = ""
        } else {
            vc.comments = comments.text
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
