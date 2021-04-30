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

class BubblesViewController: UIViewController {

    var settings: Settings?;
    var timeLeft: Int?;
    var maxNumBubbles: Int?;
    var currentBubbles = [UIButton]();
    var timer: Timer?;
    var delegate: gamesControl?;
    var lastPoppedBubbleColor: UIColor?;
    
    var maxPossibleBubbles: Int = 15;

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false);
        
        if let playerName = settings?.name {
            self.delegate?.updatePlayerName(name: playerName);
        }
        
        if let gameTime = settings?.gameTime {
            self.timeLeft = gameTime;
            self.delegate?.updateTimeLeftLabel(value: gameTime);
        }

        if let maxNumBubblesUnwrapped = settings?.maxNumBubbles {
            self.maxNumBubbles = maxNumBubblesUnwrapped;
        }
        
        // Add some bubbles at the start
        addBubbles(num: Int.random(in: 0..<maxPossibleBubbles));
        
        // Start game timer
        startTimer();
    }
    
    deinit {
        stopTimer();
    }
    
    func startTimer() {
        guard timer == nil else { return };
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.update),
            userInfo: nil,
            repeats: true);
    }
    
    func stopTimer() {
        timer?.invalidate();
        timer = nil;
    }
    
    // This function runs every second during gameplay
    @objc func update() {
        
        // Decrement time left
        if var timeLeft = self.timeLeft {
            timeLeft = timeLeft - 1;
            self.timeLeft = timeLeft;
            delegate?.updateTimeLeftLabel(value: timeLeft);
        }

        // When time is at zero
        // Stop timer and exit update func if timer is at zero
        // Remove all bubbles from view
        if self.timeLeft == 0 {
            // Remove all bubbles from view
            for currentBubble in currentBubbles {
                currentBubble.removeFromSuperview();
            }
            
            // Stop timer
            self.stopTimer();
            
            // Call Segue from Play VC to High Score VC
            delegate?.showLeaderboard();
            
            return;
        }
        
        // Add some bubbles
        addBubbles(num: Int.random(in: 0..<maxPossibleBubbles));
        
        // Remove some bubbles
        removeBubbles(num: Int.random(in: 0..<maxPossibleBubbles));
    }
    
    func addBubbles(num: Int) {
        // Add bubbles
        var bubbleNum = num;
        
        // Get max num of bubbles per second
        if let maxNumBubblesUnwrapped = maxNumBubbles {
            outerLoop: while bubbleNum > 0 && maxNumBubblesUnwrapped > currentBubbles.count {

                // create bubble
                let randX = Double(Int.random(in: 0..<(Int(view.frame.maxX)-50)));
                let randY = Double(Int.random(in: 0..<(Int(view.frame.maxY)-50)));

                // Determine bubble color
                let color: UIColor;
                let randPercentage = Int.random(in: 0..<100)

                if (randPercentage < 40) {
                    color = UIColor.red;
                } else if (randPercentage < 70) {
                    color = UIColor.magenta;
                } else if (randPercentage < 85) {
                    color = UIColor.green;
                } else if (randPercentage < 95) {
                    color = UIColor.blue;
                } else {
                    color = UIColor.black;
                }

                // Create a new bubble using the determined settings
                let newBubble = createBubble(x: randX,y: randY, color: color);

                // check with every bubble in currentBubbles to see if there is any overlap
                for currentBubble in currentBubbles {
                    // Check if bubble overlaps
                    if (currentBubble.frame.intersects(newBubble.frame)) {
                        // Try again by creating a new bubble
                        continue outerLoop;
                    }
                }

                // Add new bubble to current bubble list
                currentBubbles.append(newBubble);

                // Display the new bubble
                view.addSubview(newBubble);

                // Decrement bubble number if it is created
                bubbleNum = bubbleNum - 1;
            }
        }
    }

    // Create a bubble parsing in the location of the button on the view
    // and the color
    func createBubble(x: Double, y: Double, color: UIColor) -> UIButton {
        let bubble = UIButton(type: .custom);
        bubble.frame = CGRect(x: x, y: y, width: 50, height: 50);
        bubble.layer.cornerRadius = 0.5 * bubble.bounds.size.width;
        bubble.clipsToBounds = true;
        bubble.backgroundColor = color;
        bubble.addTarget(self, action: #selector(self.bubbleOnClick), for: .touchUpInside);

        return bubble;
    }

    // Bubble on click handler
    @objc func bubbleOnClick(sender: UIButton) {
        // Destroy bubble
        sender.removeFromSuperview();
        
        var points: Int = 0;
        
        // Increment score based on the bubble's color
        switch sender.backgroundColor {
            case UIColor.red:
                points = 1;
                break;
            case UIColor.magenta:
                points = 2;
                break;
            case UIColor.green:
                points = 5;
                break;
            case UIColor.blue:
                points = 8;
                break;
            case UIColor.black:
                points = 10;
                break;
            default:
                print("Unrecognised color: \(String(describing: sender.backgroundColor))");
        }
        
        // If the last popped bubble color is the same, then add x1.5 the score
        if let lastPoppedBubbleColorUnwrapped = lastPoppedBubbleColor {
            if lastPoppedBubbleColorUnwrapped == sender.backgroundColor {
                points = Int(Double(points) * 1.5);
            }
        }
        
        // Store bubble color for comparision the next time a bubble is popped
        lastPoppedBubbleColor = sender.backgroundColor;
        
        delegate?.updateScore(value: points)
    }

    // Remove bubbles from the view
    func removeBubbles(num: Int) {
        var bubblesToRemove = num;

        while bubblesToRemove > 0 && bubblesToRemove <= currentBubbles.count {

            // Randomly chossing a bubble index to remove
            let indexToRemove = Int.random(in: 0..<currentBubbles.count);

            // Remove UIButton
            currentBubbles[indexToRemove].removeFromSuperview();

            // Remove the bubble from the current bubbles
            currentBubbles.remove(at: indexToRemove);

            bubblesToRemove = bubblesToRemove - 1;
        }
    }
}
