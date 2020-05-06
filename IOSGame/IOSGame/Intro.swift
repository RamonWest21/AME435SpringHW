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
        node.fontSize = 32
        node.position = CGPoint(x: frame.midX, y: frame.midY)
        node.text = "Welcome to Stacker!"
        addChild(node)
        
        let instructions1 = SKLabelNode(fontNamed: "Futura")
        instructions1.fontSize = 32
        instructions1.position = CGPoint(x: frame.midX, y: frame.midY - 60)
        instructions1.text = "Stack the green squares"
        addChild(instructions1)
        
        let instructions2 = SKLabelNode(fontNamed: "Futura")
        instructions2.fontSize = 32
        instructions2.position = CGPoint(x: frame.midX, y: frame.midY - 120)
        instructions2.text = "to reach the blue square!"
        addChild(instructions2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let game = Game(size: size)
        if let view = view{
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
            view.presentScene(game, transition: transition)
        }
    }
}
