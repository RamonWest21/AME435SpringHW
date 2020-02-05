//
//  ViewController.swift
//  CommonInputControls
//
//  Created by student on 2/5/20.
//  Copyright © 2020 Ramon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        print("Button was tapped")
        if toggle.isOn {
                print("The switch is on!")
        }
        else {
                print("The switch is off.")
        }
        print("The slider is set to \(slider.value)")
        
    }
    @IBAction func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
                print("The switch is on!")
        }
        else {
                print("The switch is off.")
        }
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        print(sender.value)
    }
    @IBAction func keyboardReturnKeyTapped(_ sender: UITextField) {
        if let text = sender.text{
            print(text)
        }
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        if let text = sender.text{
            print(text)
        }
    }
}

