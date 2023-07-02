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
    
    var dates = [Date]()
    var allVotes = [Int]()
    var ourVotes = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Date", for: indexPath)
        cell.textLabel?.text = "Date goes here"
        return cell
    }
    
    @IBAction func addDate(_ sender: AnyObject) {
       // add to arrays
        dates.append(datePicker.date)
        allVotes.append(0)
        ourVotes.append(1)
        
        // insert new row in the table
        let newIndexPath = IndexPath(row: dates.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        // scroll the new row into view
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        
        // flash the scroll bars so the user knows something changed
        tableView.flashScrollIndicators()
    }

    @IBAction func saveSelectedDates(_ sender: AnyObject) {
        
    }

}
