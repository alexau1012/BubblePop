//
//  HighScoreViewController.swift
//  BubblePop
//
//  Created by Man Him Au on 16/4/21.
//

import UIKit

struct nameScore: Codable {
    let name: String;
    var score: Int;
}

class HighScoreViewController: UIViewController {
    
    @IBOutlet weak var highScoreTableView: UITableView!
    
    var newScore: nameScore?;
    
    var currentHighScoreList = [nameScore]();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let myHighScores = UserDefaults.standard.value(forKey: "myHighScores") as? Data {
            let decoder = JSONDecoder();
            if let myHighScoresDecoded = try? decoder.decode([nameScore].self, from: myHighScores) {
                self.currentHighScoreList = myHighScoresDecoded;
            }
        }
        
        if let newScoreUnwrapped = newScore {
            self.currentHighScoreList.append(newScoreUnwrapped);
            
            // Persist high scores
            let encoder = JSONEncoder();
            if let encoded = try? encoder.encode(self.currentHighScoreList) {
                UserDefaults.standard.set(encoded, forKey: "myHighScores");
            }
        }
    }

}

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
