//
//  HighScoreViewController.swift
//  BubblePop
//
//  Created by Man Him Au on 16/4/21.
//

import UIKit

class nameScore: Codable {
    let name: String;
    var score: Int;
    
    init(withName name: String, withScore score: Int) {
        self.name = name;
        self.score = score;
    }
}

class HighScoreViewController: UIViewController {
    
    @IBOutlet weak var highScoreTableView: UITableView!
    
    var newScore: nameScore?;
    
    var currentHighScoreList = [nameScore]();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Hide back button
        navigationItem.hidesBackButton = true;
        
        // Retreive high scores from User Default
        if let myHighScores = UserDefaults.standard.value(forKey: "myHighScores") as? Data {
            let decoder = JSONDecoder();
            if let myHighScoresDecoded = try? decoder.decode([nameScore].self, from: myHighScores) {
                self.currentHighScoreList = myHighScoresDecoded;
            }
        }
        
        // Add new score to high scores
        if let newScoreUnwrapped = newScore {

            // If the player of the newScore already exist in the high score list,
            // check if the newScore's score is higher, if it is, then update, if not, ignore
            if currentHighScoreList.filter({ $0.name == newScoreUnwrapped.name}).count != 0 {
                
                // Update user's prev score if new score is higher
                currentHighScoreList.first(where: {$0.name == newScoreUnwrapped.name && $0.score < newScoreUnwrapped.score})?.score = newScoreUnwrapped.score;
            } else {
                
                // Add newScore to high score list
                self.currentHighScoreList.append(newScoreUnwrapped);
            }
            
            // Sort by descending order
            self.currentHighScoreList.sort(by: { $0.score > $1.score });
            
            // Persist high scores
            let encoder = JSONEncoder();
            if let encoded = try? encoder.encode(self.currentHighScoreList) {
                UserDefaults.standard.set(encoded, forKey: "myHighScores");
            }
        }
    }

}

// High Scores Table
extension HighScoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentHighScoreList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL");
        
        let highScore = currentHighScoreList[indexPath.row];
        
        cell.textLabel?.text = highScore.name;
        cell.detailTextLabel?.text = String(highScore.score);
        
        return cell;
    }
    
    
}
