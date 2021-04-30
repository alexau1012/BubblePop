//
//  PlayViewController.swift
//  BubblePop
//
//  Created by Man Him Au on 21/4/21.
//

import UIKit

protocol gamesControl {
    func updateTimeLeftLabel(value: Int);
    func updateScore(value: Int);
    func showLeaderboard();
    func updatePlayerName(name: String);
}

class PlayViewController: UIViewController, gamesControl {
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var bubblesView: UIView!
    
    var settings: Settings?;
    var playerName: String = "";
    var score: Int = 0;
    var highScore: Int?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get high score from user defaults and display it
        if let myHighScores = UserDefaults.standard.value(forKey: "myHighScores") as? Data {
            let decoder = JSONDecoder();
            if let myHighScoresDecoded = try? decoder.decode([nameScore].self, from: myHighScores) {
                highScore = myHighScoresDecoded.map({$0.score}).max();
                
                if let highScoreUnwrapped = highScore {
                    updateHighScore(value: highScoreUnwrapped);
                }
            }
        }
    }
    
    func updateTimeLeftLabel(value: Int) {
        timeLeftLabel.text = String(value);
    }
    
    // Update score variable and score label
    func updateScore(value: Int) {
        score = score + value;

        // Update score label
        scoreLabel.text = String(score);
        
        // Update high score
        if let highScoreUnwrapped = highScore {
            if score > highScoreUnwrapped {
                updateHighScore(value: score);
            }
        } else {
            updateHighScore(value: score);
        }
    }
    
    // Update high score variable and high score label
    func updateHighScore(value: Int) {
        highScore = value;
        
        // Update high score label
        if let highScoreUnwrapped = highScore {
            highScoreLabel.text = String(highScoreUnwrapped);
        }
    }
    
    func updatePlayerName(name: String) {
        playerName = name;
    }
    
    // Navigate to high score page
    func showLeaderboard() {
        performSegue(withIdentifier: "finishSegue", sender: nil);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSegue" {
            if let bubblesVC = segue.destination as? BubblesViewController {
                // Some property on bubblesVC that needs to be set
                bubblesVC.settings = settings;
                bubblesVC.delegate = self;
            }
        } else if segue.identifier == "finishSegue" {
            if let highScoreVC = segue.destination as? HighScoreViewController {
                // Some property on highScoreVC that needs to be set
                let newScore = nameScore(withName: self.playerName, withScore: self.score)
                highScoreVC.newScore = newScore;
            }
        }
    }
}
