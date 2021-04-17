//
//  Practicing.swift
//  BookCore
//
//  Created by André Schueda on 17/04/21.
//

import SpriteKit

public class Practicing: SKScene {
    let animations = Animations()
    var person: SKSpriteNode!
    var hand: SKSpriteNode!
    var personCenter = CGPoint(x: 0, y: 0)
    
    var learnText: SKSpriteNode!
    
    func setupPerson() {
        personCenter = CGPoint(x: size.width * 0.5 , y: size.height * 0.5)
        person = SKSpriteNode(imageNamed: "person")
        person.position = personCenter
        person.setScale(0.65)
        person.name = "person"
        person.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0, upperLimit: 0))]
        addChild(person)
    }
    
    func setupHand() {
        hand = SKSpriteNode(imageNamed: "handLearn1")
        hand.position = CGPoint(x: size.width * 0.47 , y: size.height * 0.67)
        hand.setScale(0.25)
        hand.alpha = 0
        hand.name = "hand"
        hand.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0, upperLimit: 0))]
        addChild(hand)
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
    }
    
    func setupLearnText() {
        learnText = SKSpriteNode(imageNamed: "learnText")
        learnText.position = CGPoint(x: size.width/2, y: size.height * 0.15)
        learnText.alpha = 0
        learnText.setScale(0.3)
        addChild(learnText)
    }
    
    func learnAnimation() -> SKAction {
        var learnFrames = [SKTexture]()
        learnFrames.append(SKTexture(imageNamed: "handLearn2"))
        learnFrames.append(SKTexture(imageNamed: "handLearn3"))
        learnFrames.append(SKTexture(imageNamed: "handLearn4"))
        learnFrames.append(SKTexture(imageNamed: "handLearn5"))
        learnFrames.append(SKTexture(imageNamed: "handLearn4"))
        learnFrames.append(SKTexture(imageNamed: "handLearn3"))
        learnFrames.append(SKTexture(imageNamed: "handLearn2"))
        learnFrames.append(SKTexture(imageNamed: "handLearn1"))
        learnFrames.append(SKTexture(imageNamed: "handLearn2"))
        learnFrames.append(SKTexture(imageNamed: "handLearn3"))
        learnFrames.append(SKTexture(imageNamed: "handLearn4"))
        learnFrames.append(SKTexture(imageNamed: "handLearn5"))
        learnFrames.append(SKTexture(imageNamed: "handLearn4"))
        learnFrames.append(SKTexture(imageNamed: "handLearn3"))
        learnFrames.append(SKTexture(imageNamed: "handLearn2"))
        learnFrames.append(SKTexture(imageNamed: "handLearn1"))
        learnFrames.append(SKTexture(imageNamed: "handLearn2"))
        learnFrames.append(SKTexture(imageNamed: "handLearn3"))
        learnFrames.append(SKTexture(imageNamed: "handLearn4"))
        learnFrames.append(SKTexture(imageNamed: "handLearn5"))
        let learnAnimationFrames = SKAction.animate(with: learnFrames, timePerFrame: 1.4/20)
        
        
        
        
        return SKAction.sequence([.fadeIn(withDuration: 0.4), learnAnimationFrames, .wait(forDuration: 1.4), .fadeOut(withDuration: 0.4)])
    }
    
    
    override public func didMove(to view: SKView) {
        setupBackground()
        setupPerson()
        setupHand()
        setupLearnText()
        
        
        learnText.run(.repeatForever(.sequence([.wait(forDuration: 1), .fadeIn(withDuration: 0.4), .wait(forDuration: 2.8), .fadeOut(withDuration: 0.4), .wait(forDuration: 9)])))
        hand.run(.repeatForever(.sequence([SKAction.setTexture(SKTexture(imageNamed: "handLearn1")), .wait(forDuration: 1), learnAnimation(), .wait(forDuration: 9)])))
    }
}
