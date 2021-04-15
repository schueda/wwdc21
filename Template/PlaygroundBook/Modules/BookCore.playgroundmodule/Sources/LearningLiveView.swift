//
//  LearningLiveView.swift
//  BookCore
//
//  Created by André Schueda on 14/04/21.
//

import SpriteKit

public class LearningLiveView: SKScene {
    let animations = Animations()
    var hand: SKSpriteNode!
    var handCenter = CGPoint(x: 0, y: 0)
    
    func setupHand() {
        handCenter = CGPoint(x: size.width * 0.53 , y: size.height * 0.59)
        hand = SKSpriteNode(imageNamed: "handDefault")
        hand.position = handCenter
        hand.setScale(0.65)
        hand.name = "hand"
        hand.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0, upperLimit: 0))]
        addChild(hand)
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
    }
    
    
    override public func didMove(to view: SKView) {
        setupBackground()
        setupHand()
        
        hand.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1), animations.createAAnimation()])))
        
        
    }
}
