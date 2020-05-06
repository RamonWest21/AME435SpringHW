//
//  GameOver.swift
//  IOSGame
//
//  Created by student on 5/5/20.
//  Copyright © 2020 Ramon. All rights reserved.
//

import UIKit
import SpriteKit
class GameOver: SKScene {
   
    override func didMove(to view: SKView) {
           backgroundColor = SKColor.blue
           
           let node = SKLabelNode(fontNamed: "Futura")
           node.fontSize = 48
           node.position = CGPoint(x: frame.midX, y: frame.midY)
           node.text = "Game Over"
           addChild(node)
        
            let score = SKLabelNode(fontNamed: "Futura")
            score.fontSize = 48
            score.position = CGPoint(x: frame.midX, y: frame.midY - 100)
            score.text = "Score: "
            addChild(score)
        
            let gameSound = SKAction.playSoundFileNamed("1_person_cheering-Jett_Rifkin-1851518140.wav", waitForCompletion: false)
        self.run(gameSound)
       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let intro = Intro(size: size)
        if let view = view{
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
            view.presentScene(intro, transition: transition)
        }
    }
       
}
