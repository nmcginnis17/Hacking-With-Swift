//
//  SubmitViewController.swift
//  What's that tune
//
//  Created by Nicholas McGinnis on 1/8/23.
//

import CloudKit
import UIKit

class SubmitViewController: UIViewController {
    
    var genre: String!
    var comments: String!
    
    var stackView: UIStackView!
    var status: UILabel!
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "You're all set!"
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        doSubmission()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.gray
        
        stackView = UIStackView()
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Submitting..."
        status.textColor = UIColor.white
        status.font = UIFont.preferredFont(forTextStyle: .title1)
        status.numberOfLines = 0
        status.textAlignment = .center
        
        spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        stackView.addArrangedSubview(status)
        stackView.addArrangedSubview(spinner)
    }
    
    func doSubmission() {
        let tuneRecord = CKRecord(recordType: "Tunes")
        tuneRecord["genre"] = genre as CKRecordValue
        tuneRecord["comments"] = comments as CKRecordValue
        
        let audioURL = RecordTuneViewController.getTuneURL()
        let tuneAsset = CKAsset(fileURL: audioURL)
        tuneRecord["audio"] = tuneAsset
        
        CKContainer.default().publicCloudDatabase.save(tuneRecord) { [unowned self] record, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.status.text = "Error:\(error.localizedDescription)"
                    self.spinner.stopAnimating()
                } else {
                    self.view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
                    self.status.text = "Done!"
                    self.spinner.stopAnimating()
                    
                    ViewController.isDirty = true
                }
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneTapped))
            }
        }
    }
    
    @objc func doneTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
