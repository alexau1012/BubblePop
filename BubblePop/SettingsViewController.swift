//
//  SettingsViewController.swift
//  BubblePop
//
//  Created by Man Him Au on 21/4/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var gameTimeSlider: UISlider!
    @IBOutlet weak var maxNumBubblesSlider: UISlider!

    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var maxNumBubblesLabel: UILabel!
    
    @IBOutlet weak var start: UIButton!
    
    var name: String?;
    var gameTime: Int?;
    var maxNumBubbles: Int?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Disable start button when the page first loads since the name field is empty
        start.isEnabled = false;
        
        gameTimeSlider.value = 60;
        gameTimeLabel.text = String(Int(gameTimeSlider.value));
        maxNumBubblesSlider.value = 15;
        maxNumBubblesLabel.text = String(Int(maxNumBubblesSlider.value));
        
        gameTime = Int(gameTimeSlider.value);
        maxNumBubbles = Int(maxNumBubblesSlider.value);
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        name = nameText.text;
        
        // If name field is empty, disable start button else enable
        if nameText.text != nil {
            if let nameTextUnwrapped = nameText.text {
                if nameTextUnwrapped != "" && !nameTextUnwrapped.trimmingCharacters(in: .whitespaces).isEmpty {
                    start.isEnabled = true;
                } else {
                    start.isEnabled = false;
                }
            }
        } else {
            // Disable when the text field is empty
            start.isEnabled = false;
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        // If text field is empty, disable start button
        if ((nameText.text?.isEmpty) != nil) {
            start.isUserInteractionEnabled = false;
        } else {
            start.isUserInteractionEnabled = true;
        }
    }
    
    @IBAction func gameTimeSliderOnChange(_ sender: Any) {
        gameTime = Int(gameTimeSlider.value);
        gameTimeLabel.text = String(Int(gameTimeSlider.value));
    }
    
    @IBAction func maxNumBubblesSliderOnChange(_ sender: Any) {
        maxNumBubbles = Int(maxNumBubblesSlider.value);
        maxNumBubblesLabel.text = String(Int(maxNumBubblesSlider.value));
    }
    
    @IBAction func startOnClick(_ sender: Any) {
        performSegue(withIdentifier: "startSegue", sender: nil);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a variable to send
        let settings = Settings(name: name, gameTime: gameTime, maxNumBubbles: maxNumBubbles);
        
        // Create a new var to store the instance of PlayViewController
        let destinationVc = segue.destination as? PlayViewController;
        destinationVc?.settings = settings;
    }
}
