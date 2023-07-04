//
//  ViewController.swift
//  Polyglot
//
//  Created by Nicholas McGinnis on 7/4/23.
//

import UIKit

class ViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    var words = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter", size: 22)!]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = "POLYGLOT"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewWord))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startTest))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "End Test", style: .plain, target: nil, action: nil)
        
        if let savedWords = defaults.object(forKey: "Words") as? [String] {
            words = savedWords
        } else {
            saveInitialValues(to: defaults)
        }

    }
    
    func saveInitialValues(to defaults: UserDefaults) {
        words.append("bear::l'ours")
        words.append("camel::le chameau")
        words.append("cow::la vache")
        words.append("fox::le renard")
        words.append("goat::la chèvre")
        words.append("monkey::le singe")
        words.append("pig::le cochon")
        words.append("rabbit::le lapin")
        words.append("sheep::le mouton")
        
        defaults.set(words, forKey: "Words")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        let word = words[indexPath.row]
        let split = word.components(separatedBy: "::")
        
        cell.textLabel?.text = split[0]
        cell.detailTextLabel?.text = ""
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.detailTextLabel?.text == "" {
                let word = words[indexPath.row]
                let split = word.components(separatedBy: "::")
                cell.detailTextLabel?.text = split[1]
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        words.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveWords()
    }
    
    func saveWords() {
        defaults.set(words, forKey: "Words")
    }

    @objc func addNewWord() {
        // create alert controller
        let ac = UIAlertController(title: "Add new word", message: nil, preferredStyle: .alert)
        
        // add 2 text fields, 1 english :: 1 french
        ac.addTextField { textField in
            textField.placeholder = "English"
        }
        
        ac.addTextField { textField in
            textField.placeholder = "French"
        }
        
        // create "Add Word" button to submit users input
        let submitAction = UIAlertAction(title: "Add Words", style: .default) { [unowned self, ac] (action: UIAlertAction!) in
            // pull English and French words, or empty string if there is a problem
            let firstWord = ac.textFields?[0].text ?? ""
            let secondWord = ac.textFields?[1].text ?? ""
            
            // submit English and French word to insertFlashcard() method
            self.insertFlashcard(first: firstWord, second: secondWord)
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func insertFlashcard(first: String, second: String) {
        guard first.count > 0 && second.count > 0 else { return }
        
        let newIndexPath = IndexPath(row: words.count, section: 0)
        
        words.append("\(first)::\(second)")
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        saveWords()
    }
    
    @objc func startTest() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Test") as? TestViewController else { return }
        vc.words = words
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

