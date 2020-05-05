//
//  ViewController.swift
//  IOSGame
//
//  Created by student on 5/5/20.
//  Copyright © 2020 Ramon. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let intro = Intro(size: view.frame.size)
        
        if let view = view as? SKView {
            view.presentScene(intro)
        }
    }


}

