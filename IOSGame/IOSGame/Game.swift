//
//  Game.swift
//  IOSGame
//
//  Created by student on 5/5/20.
//  Copyright © 2020 Ramon. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class Game: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.black
        
        // Create Dispenser
        
        let dispencer = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 30, height: 30))
        dispencer.position = CGPoint(x: frame.midX, y: frame.height - 20)
        dispencer.name = "Dispencer"
        // give dispencer a physics body
        let dispencerBody = SKPhysicsBody(rectangleOf: dispencer.size)
        // Ground not affected by gravity. isDynamic = false
        dispencerBody.affectedByGravity = false
        dispencerBody.friction = 0.0
        dispencerBody.contactTestBitMask = 1
        dispencer.physicsBody = dispencerBody
        let action = SKAction.sequence([
            SKAction.applyImpulse(CGVector(dx: 10.0, dy: 0.0), duration: 0.5)
        ])

        dispencer.run(action)
        addChild(dispencer)
        
        print(dispencer.position)
        
        // Create base
        let node = SKSpriteNode(color: SKColor.green, size: CGSize(width: 80, height: 20))
        node.position = CGPoint(x:frame.midX + CGFloat.random(in: -100 ... 100), y: 50)
        node.name = "Base"
        // Objects require an SKPhysicsBody to participate in the physics system
        let body = SKPhysicsBody(rectangleOf: node.size)
        // apply physics body to the node
        node.physicsBody = body
        addChild(node)
        
        // Create ground
        let ground = SKSpriteNode(color: SKColor.blue, size: CGSize(width: frame.width, height: 30))
        ground.position = CGPoint(x: frame.midX, y: 15.0)
        ground.name = "Ground"
        // give ground a physics body
        let groundBody = SKPhysicsBody(rectangleOf: ground.size)
        // Ground not affected by gravity. isDynamic = false
        groundBody.isDynamic = false
        ground.physicsBody = groundBody
        addChild(ground)
        
        // Create left wall
        let wallLeft = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 0.1, height: frame.height * 2))
        wallLeft.position = CGPoint(x: 0.0, y: 15.0)
        wallLeft.name = "Left Wall"
        // give ground a physics body
        let wallLeftBody = SKPhysicsBody(rectangleOf: wallLeft.size)
        // wallLeft not affected by gravity. isDynamic = false
        wallLeftBody.isDynamic = false
        wallLeft.physicsBody = wallLeftBody
        addChild(wallLeft)
        
        // Create right wall
        let wallRight = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 0.1, height: frame.height * 2))
        wallRight.position = CGPoint(x: frame.width, y: 15.0)
        wallRight.name = "Right Wall"
        // give ground a physics body
        let wallRightBody = SKPhysicsBody(rectangleOf: wallRight.size)
        // wallRight not affected by gravity. isDynamic = false
        wallRightBody.isDynamic = false
        wallRight.physicsBody = wallRightBody
        addChild(wallRight)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        let node = SKSpriteNode(color: SKColor.green, size: CGSize(width: 30, height: 30))
        node.position = point
        node.name = "Green"
        node.zPosition = CGFloat.random(in: 0.0 ... 1.0)
        let body = SKPhysicsBody(rectangleOf: node.size)
        // need to change contact test bit mask to notify for colliisons
        body.contactTestBitMask = 1
        node.physicsBody = body
        addChild(node)
        
        let bloom = SKAction.playSoundFileNamed("Blop-Mark_DiAngelo-79054334.wav", waitForCompletion: false)
        self.run(bloom)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node, let nameA = nodeA.name else { return }
        guard let nodeB = contact.bodyB.node, let nameB = nodeB.name else { return }
        
        if nameA == "Green" && nameB == "Ground" {
            guard let node = nodeA as? SKSpriteNode else { return }
            explosion(node: node)
        }
        
        else if nameA == "Ground" && nameB == "Green" {
            guard let node = nodeB as? SKSpriteNode else { return }
            explosion(node: node)
        }
        
        if nameA == "Dispencer" && nameB == "Left Wall" {
            guard let node = nodeA as? SKSpriteNode else { return }
            moveRight(node: node)
        }

        else if nameA == "Left Wall" && nameB == "Dispencer" {
            guard let node = nodeB as? SKSpriteNode else { return }
            moveRight(node: node)
        }

        if nameA == "Dispencer" && nameB == "Right Wall" {
            guard let node = nodeA as? SKSpriteNode else { return }
            moveLeft(node: node)
        }

        else if nameA == "Right Wall" && nameB == "Dispencer" {
            guard let node = nodeB as? SKSpriteNode else { return }
            moveLeft(node: node)
        }
        
        if nameA == "Dispencer" && nameB == "Green" {
            guard let node = nodeA as? SKSpriteNode else { return }
            explosion(node: node)
            let scene = GameOver(size: size)
            if let view = view{
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }

        else if nameA == "Green" && nameB == "Dispencer" {
            guard let node = nodeB as? SKSpriteNode else { return }
            explosion(node: node)
            let scene = GameOver(size: size)
            if let view = view{
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }
    }
    
    func moveLeft(node: SKSpriteNode) {
        let action = SKAction.sequence([
            SKAction.applyForce(CGVector(dx: -10.0, dy: 0.0), duration: 0.25)
        ])
        node.run(action)
    }
    
    func moveRight(node: SKSpriteNode){
        let action = SKAction.sequence([
            SKAction.applyForce(CGVector(dx: 10.0, dy: 0.0), duration: 0.25)
        ])
        node.run(action)
    }
    
    func explosion(node: SKSpriteNode){
        for _ in 1 ... 10 {
            let explosionSound = SKAction.playSoundFileNamed("Punch_HD-Mark_DiAngelo-1718986183.wav", waitForCompletion: false)
            debris(node: node)
            self.run(explosionSound)
        }
        node.removeFromParent()
        
    }
    
    func debris(node: SKSpriteNode){
        let r = 0.7 + CGFloat.random(in: 0.0 ... 0.3)
        let g = 0.1 + CGFloat.random(in: 0.0 ... 0.2)
        let b = 0.1 + CGFloat.random(in: 0.0 ... 0.2)
        let thing = SKSpriteNode(color: SKColor(red: r, green: g, blue: b, alpha: 1.0), size: CGSize(width: 10, height: 10))
        thing.position = CGPoint(x: node.position.x + CGFloat.random(in: -node.size.width/2 ... node.size.width/2), y: node.position.y + CGFloat.random(in: -node.size.height/2 ... node.size.height/2))

        thing.name = "debris"
        let body = SKPhysicsBody(rectangleOf: thing.size)
        let dx = CGFloat.random(in: -600 ... 600)
        let dy = CGFloat.random(in: -600 ... 600)
        let direction = CGVector(dx: dx, dy: dy)
        body.velocity = direction
        thing.physicsBody = body
        
        addChild(thing)
        
        let action = SKAction.sequence([
            SKAction.wait(forDuration: 2.0, withRange: 2.0),
            SKAction.removeFromParent()
        ])
        
        thing.run(action)
    }
}
