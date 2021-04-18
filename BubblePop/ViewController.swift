//
//  ViewController.swift
//  BubblePop
//
//  Created by Man Him Au on 11/4/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

class SettingsViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var gameTimeSlider: UISlider!
    @IBOutlet weak var maxNumBubblesSlider: UISlider!

    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var maxNumBubblesLabel: UILabel!
    
    @IBOutlet weak var start: UIButton!
    
    var name: String?;
    var gameTime: Float?;
    var maxNumBubbles: Float?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameTimeSlider.value = 60;
        gameTimeLabel.text = String(Int(gameTimeSlider.value));
        maxNumBubblesSlider.value = 15;
        maxNumBubblesLabel.text = String(Int(maxNumBubblesSlider.value));
    }

    @IBAction func nameTextOnChange(_ sender: Any) {
        name = nameText.text;
    }
    
    @IBAction func gameTimeSliderOnChange(_ sender: Any) {
        gameTime = gameTimeSlider.value;
        gameTimeLabel.text = String(Int(gameTimeSlider.value));
    }
    
    @IBAction func maxNumBubblesSliderOnChange(_ sender: Any) {
        maxNumBubbles = maxNumBubblesSlider.value;
        maxNumBubblesLabel.text = String(Int(maxNumBubblesSlider.value));
    }
    
    @IBAction func startOnClick(_ sender: Any) {
        performSegue(withIdentifier: "startSegue", sender: nil);
    }
}

class PlayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

class HighScoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
