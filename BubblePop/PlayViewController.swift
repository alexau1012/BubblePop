//
//  PlayViewController.swift
//  BubblePop
//
//  Created by Man Him Au on 21/4/21.
//

import UIKit

class PlayViewController: UIViewController {
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    var settings: Settings?;
    var timer: Timer?;
    var timeLeft: Int?;
    var score: Int = 0;
    var maxNumBubbles: Int?;
    
    let childVC = BubblesViewController();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let settings = settings {
            if let gameTime = settings.gameTime {
                timeLeft = gameTime;
                timeLeftLabel.text = String(gameTime);
            }
            
            if let maxNumBubblesSetting = settings.maxNumBubbles {
                maxNumBubbles = maxNumBubblesSetting;
            }
        }
        
        // Start Timer
        self.startTimer();
        
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
    
    func incrementScore(value: Int) {
        score = score + value;
        
        // Update label
        scoreLabel.text = String(score);
    }
    
    @objc func update() {
        
        // Stop timer and exit update func if timer is at zero
        if self.timeLeft == 0 {
            self.stopTimer();
            return;
        }
        
        // Decrement time left
        if var timeLeft = self.timeLeft {
            timeLeft = timeLeft - 1;
            self.timeLeft = timeLeft;
            self.timeLeftLabel.text = String(timeLeft);
        }
        
        // Add some bubbles
        childVC.addBubbles(num: 1);
        
        // Remove some bubbles
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Identifier" {
            if let childVC = segue.destination as? BubblesViewController {
                //Some property on ChildVC that needs to be set
                childVC.maxNumBubbles = maxNumBubbles;
            }
        }
    }
}

class BubblesViewController: UIViewController {
    
    var maxNumBubbles: Int?;
    var currentBubbles: [UIButton] = [];
    
    let parentVC = PlayViewController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        let button = createBubble(x: 0, y: 0, color: UIColor.red);
        view.addSubview(button);
        print("\(button.frame)")
    }
    
    func addBubbles(num: Int) {
        // Add bubbles
        var bubbleNum = Int.random(in: 0..<(num+1))
        
        while bubbleNum > 0 {
            
            // create bubble
            let randX = Int.random(in: 0..<(Int(view.frame.maxX)-50))
            let randY = Int.random(in: 0..<(Int(view.frame.maxY)-50))
            
            // Determine bubble color
            let color: UIColor;
            let randPercentage = Int.random(in: 0..<100)
            
            if (randPercentage < 40) {
                color = UIColor.red;
            } else if (randPercentage < 70) {
                color = UIColor.systemPink;
            } else if (randPercentage < 85) {
                color = UIColor.green;
            } else if (randPercentage < 95) {
                color = UIColor.blue;
            } else {
                color = UIColor.black;
            }
            
            let newBubble = createBubble(x: randX,y: randY, color: color);
            
            // check with every bubble in currentBubbles to see if there is any overlap
            for currentBubble in currentBubbles {
                // Check if bubble overlaps
                if (newBubble.frame.intersects(currentBubble.frame)) {
                    // Try again
                    continue;
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
    
    func createBubble(x: Int, y: Int, color: UIColor) -> UIButton {
        let bubble = UIButton(type: .custom);
        bubble.frame = CGRect(x: view.frame.maxX-50, y: view.frame.maxY-50, width: 50, height: 50);
        bubble.layer.cornerRadius = 0.5 * bubble.bounds.size.width;
        bubble.clipsToBounds = true;
        bubble.backgroundColor = color;
        bubble.addTarget(self, action: #selector(self.bubbleOnClick), for: .touchUpInside);
        
        return bubble;
    }
    
    @objc func bubbleOnClick(sender: UIButton) {
        print("Popped bubble!")
        
        // Increment score based on the bubble's color
        switch sender.backgroundColor {
            case UIColor.red:
                parentVC.incrementScore(value: 1)
            case UIColor.systemPink:
                parentVC.incrementScore(value: 2)
            case UIColor.green:
                parentVC.incrementScore(value: 5)
            case UIColor.blue:
                parentVC.incrementScore(value: 8)
            case UIColor.black:
                parentVC.incrementScore(value: 10)
            default:
                print("Unrecognised color: \(String(describing: sender.backgroundColor))");
        }
    }
}
