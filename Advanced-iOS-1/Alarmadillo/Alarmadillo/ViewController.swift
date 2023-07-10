//
//  ViewController.swift
//  Alarmadillo
//
//  Created by Nicholas McGinnis on 7/7/23.
//

import UIKit
import UserNotifications

class ViewController: UITableViewController {
    
    var groups = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial Rounded MT Bold", size: 20)!]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = "Alarmadillo"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Groups", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: Notification.Name("save"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        load()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath)
        
        let group = groups[indexPath.row]
        
        cell.textLabel?.text = group.name
        
        if group.enabled {
            cell.textLabel?.textColor = UIColor.black
        } else {
            cell.textLabel?.textColor = UIColor.red
        }
        
        if group.alarms.count == 1 {
            cell.detailTextLabel?.text = "1 alarm"
        } else {
            cell.detailTextLabel?.text = "\(group.alarms.count) alarms"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        groups.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        save()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let groupToEdit: Group
        
        if sender is Group {
            groupToEdit = sender as! Group
        } else {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            groupToEdit = groups[selectedIndexPath.row]
        }
        
        if let groupViewController = segue.destination as? GroupViewController {
            groupViewController.group = groupToEdit
        }
    }

    
    @objc func addGroup() {
        let newGroup = Group(id: UUID().uuidString, name: "Name this group", playSound: true, enabled: false, alarms: [])
        groups.append(newGroup)
        
        performSegue(withIdentifier: "EditGroup", sender: newGroup)
        
        save()
    }
    
    @objc func save() {
        do {
            let path = Helper.getDocumentsDirectory().appendingPathComponent("groups")
            let data = try NSKeyedArchiver.archivedData(withRootObject: groups, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            // SHOW FAIL ALERT
            let ac = UIAlertController(title: "Error", message: "Failed to save", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            print("Failed to save")
        }
        updateNotifications()
    }
    
    func load() {
        do {
            let path = Helper.getDocumentsDirectory().appendingPathComponent("groups")
            let data = try Data(contentsOf: path)
            groups = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Group] ?? [Group]()
        } catch {
            // SHOW FAIL ALERT
            let ac = UIAlertController(title: "Error", message: "Failed to load", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            print("Failed to load")
        }
        
        tableView.reloadData()
    }
    
    func updateNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { [unowned self] (granted, error) in
            if granted {
                self.createNotifications()
            }
        }
    }
    
    func createNotifications() {
        let center = UNUserNotificationCenter.current()
        
        // remove any pending notifications
        center.removeAllPendingNotificationRequests()
        
        for group in groups {
            // ignore disabled groups
            guard group.enabled == true else { return }
            
            for alarm in group.alarms {
                // create notification request from each alarm
                let notification = createNotificationsRequest(group: group, alarm: alarm)
                
                // schedule notification for delivery
                center.add(notification) { error in
                    if let error = error {
                        let ac = UIAlertController(title: "Error", message: "Error scheduling notification: \(error.localizedDescription)", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(ac, animated: true)
                        print("Error scheduling notification: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func createNotificationsRequest(group: Group, alarm: Alarm) -> UNNotificationRequest {
        // create content of notification
        let content = UNMutableNotificationContent()
        
        // assign users name & caption
        content.title = alarm.name
        content.body = alarm.caption
        
        // give id we can attach to custom buttons later on
        content.categoryIdentifier = "alarm"
        
        // attach group ID and alarm ID for this alarm
        content.userInfo = ["group": group.id, "alarm": alarm.id]
        
        // if user request a sound for this group, attach their default alert sound
        if group.playSound {
            content.sound = UNNotificationSound.default
        }
        
        // use createNotificationAttachments to attach picture for alert
        content.attachments = createNotificationsAttachments(alarm: alarm)
        
        // get calender ready to pull date components
        let cal = Calendar.current
        
        // pull out the hour and minute components from this alarm's date
        var dateComponents = DateComponents()
        dateComponents.hour = cal.component(.hour, from: alarm.time)
        dateComponents.minute = cal.component(.minute, from: alarm.time)
        
        // create trigger matching those date components, set to repeat
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
/// TO TEST NOTIFICATION WORK, COMMENT OUT ABOVE TRIGGER, UNCOMMENT BELOW TRIGGER
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        // combine the content and trigger to create notification request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // pass object back to createNotifications() for scheduling
        return request
    }
    
    func createNotificationsAttachments(alarm: Alarm) -> [UNNotificationAttachment] {
        // return if there is no image to attach
        guard alarm.image.count > 0 else { return [] }
        
        let fm = FileManager.default
        
        do {
            // get full path to alarm image
            let imageURL = Helper.getDocumentsDirectory().appendingPathComponent(alarm.image)
            
            // create temp filename
            let copyURL = Helper.getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).jpg")
            
            // copy alarm image to temp filename
            try fm.copyItem(at: imageURL, to: copyURL)
            
            // create attachment from temp filename, giving random id
            let attachment = try UNNotificationAttachment(identifier: UUID().uuidString, url: copyURL)
            
            // return attachment back to createNotificationRequest()
            return [attachment]
        } catch {
            print("Failed to attach alarm image: \(error)")
            return []
        }
    }

}

