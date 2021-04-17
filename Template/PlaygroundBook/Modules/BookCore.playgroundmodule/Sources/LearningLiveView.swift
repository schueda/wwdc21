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
    
    var helloText: SKSpriteNode!
    
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
    
    func setupHelloText() {
        helloText = SKSpriteNode(imageNamed: "helloText")
        helloText.position = CGPoint(x: size.width/2, y: size.height * 0.15)
        helloText.alpha = 0
        helloText.setScale(0.3)
        addChild(helloText)
    }
    
    
    override public func didMove(to view: SKView) {
        setupBackground()
        setupHand()
        setupHelloText()
        
        
        hand.run(.repeatForever(.sequence([.wait(forDuration: 1), animations.createHelloAnimation(size: self.size, handCenter: handCenter), .wait(forDuration: 9)])))
        helloText.run(.repeatForever(.sequence([.wait(forDuration: 1), .fadeIn(withDuration: 0.4), .wait(forDuration: 2.8), .fadeOut(withDuration: 0.4), .wait(forDuration: 9)])))
        
    }
}
