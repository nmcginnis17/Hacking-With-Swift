//
//  EventViewController.swift
//  TimeShare MessagesExtension
//
//  Created by Nicholas McGinnis on 6/28/23.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Date", for: indexPath)
        cell.textLabel?.text = "Date goes here"
        return cell
    }
    
    @IBAction func addDate(_ sender: AnyObject) {
       
    }

    @IBAction func saveSelectedDates(_ sender: AnyObject) {
        
    }

}
