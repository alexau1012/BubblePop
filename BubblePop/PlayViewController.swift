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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let settings = settings {
            if let gameTime = settings.gameTime {
                timeLeft = gameTime;
                timeLeftLabel.text = String(gameTime);
            }
        }
        
        // Start Timer
        self.startTimer();
        
        let button = createBubble();
        print("\(button.frame)")
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
    
    @objc func bubbleOnClick() {
        print("Popped bubble!")
        
        // Increment score
        score = score + 1;
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
        
        // Add bubbles
        let bubbleNum = Int.random(in: 0..<16)
        for n in 0...bubbleNum {
            // create bubble
            // if n > 0: check if bubble overlaps with prev bubble
            // if overlap: try again
            // if not overlap: display bubble
        }
    }
    
    func createBubble() -> UIButton {
        let bubble = UIButton(type: .custom);
        bubble.frame = CGRect(x: 160, y: 300, width: 50, height: 50);
        bubble.layer.cornerRadius = 0.5 * bubble.bounds.size.width;
        bubble.clipsToBounds = true;
        bubble.backgroundColor = UIColor.red;
        bubble.addTarget(self, action: #selector(self.bubbleOnClick), for: .touchUpInside)
//        view.addSubview(bubble);
        
        return bubble;
    }

}
