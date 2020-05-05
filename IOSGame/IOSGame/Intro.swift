//
//  Intro.swift
//  IOSGame
//
//  Created by student on 5/5/20.
//  Copyright © 2020 Ramon. All rights reserved.
//

import UIKit
import SpriteKit

class Intro: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.blue
        
        let node = SKLabelNode(fontNamed: "Futura")
        node.fontSize = 48
        node.position = CGPoint(x: frame.midX, y: frame.midY)
        node.text = "Hello"
        addChild(node)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let game = Game(size: size)
        if let view = view{
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
            view.presentScene(game, transition: transition)
        }
    }
}
