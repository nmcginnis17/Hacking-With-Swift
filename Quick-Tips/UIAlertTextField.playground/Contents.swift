import Foundation
import UIKit

func alertForAnswer() {
    let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
    ac.addTextField()
    
    let confirmAnswer = UIAlertAction(title: "Submit", style: .default) { [weak ac] _ in
        let answer = ac?.textFields![0]
        // perform something with entered answer
    }
    
    ac.addAction(confirmAnswer)
    
    present(ac, animated: true)
}
