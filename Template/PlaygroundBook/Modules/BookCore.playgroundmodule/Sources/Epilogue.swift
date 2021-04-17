//
//  CutsceneViewController.swift
//  BookCore
//
//  Created by André Schueda on 15/04/21.
//

import SpriteKit
import AVFoundation
import PlaygroundSupport

public class Epilogue: SKScene {
    var person: SKSpriteNode!
    var rightHand: SKSpriteNode!
    var leftHand: SKSpriteNode!
    var thankText: SKSpriteNode!
    var epilogueText: SKSpriteNode!
    
    func setupPerson() {
        person = SKSpriteNode(imageNamed: "person")
        person.position = CGPoint(x: size.width * 0.25, y: size.height * 0.6)
        person.setScale(0.8)
        addChild(person)
    }
    
    func setupRightHand() {
        rightHand = SKSpriteNode(imageNamed: "handThankRight")
        rightHand.position = CGPoint(x: size.width * 0.21, y: size.height * 0.79)
        rightHand.setScale(0.9)
        rightHand.zRotation = -0.3
        addChild(rightHand)
    }
    
    func setupLeftHand() {
        leftHand = SKSpriteNode(imageNamed: "handThankLeft")
        leftHand.position = CGPoint(x: size.width * 0.30, y: size.height * 0.4)
        leftHand.setScale(0.9)
        leftHand.zRotation = 0.3
        addChild(leftHand)
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "doubleSizeBackground")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
    }
    
    func setupThanksText() {
        thankText = SKSpriteNode(imageNamed: "thankText")
        thankText.position = CGPoint(x: size.width * 0.25, y: size.height * 0.193)
        thankText.alpha = 0
        thankText.setScale(0.4)
        addChild(thankText)
    }
    
    func setupEpilogueText() {
        epilogueText = SKSpriteNode(imageNamed: "epilogueText")
        epilogueText.position = CGPoint(x: size.width * 0.71, y: size.height * 0.5)
        epilogueText.setScale(0.2)
        addChild(epilogueText)
    }
    
    func rightThankAnimation() -> SKAction {
        let moveLeft = SKAction.move(by: CGVector(dx: -10, dy: 0), duration: 0.3)
        let growScale = SKAction.scale(by: 1.111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111, duration: 0.3)
        let moveRight = SKAction.move(by: CGVector(dx: 10, dy: 0), duration: 0.3)
        let shrinkScale = SKAction.scale(by: 0.9, duration: 0.3)
        let interval = SKAction.wait(forDuration: 2.5)
        
        return SKAction.sequence([SKAction.group([moveLeft, growScale]), interval, SKAction.group([moveRight, shrinkScale])])
    }
    
    func leftThankAnimation() -> SKAction {
        let moveLeft = SKAction.move(by: CGVector(dx: -10, dy: 0), duration: 0.3)
        let growScale = SKAction.scale(by: 1.111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111, duration: 0.3)
        let moveRight = SKAction.move(by: CGVector(dx: 10, dy: 0), duration: 0.3)
        let shrinkScale = SKAction.scale(by: 0.9, duration: 0.3)
        let interval = SKAction.wait(forDuration: 2.5)
        
        return SKAction.sequence([SKAction.group([moveRight, growScale]), interval, SKAction.group([moveLeft, shrinkScale])])
    }
    
    override public func didMove(to view: SKView) {
        setupBackground()
        setupPerson()
        setupRightHand()
        setupLeftHand()
        setupThanksText()
        setupEpilogueText()
        
        rightHand.run(.repeatForever(.sequence([.wait(forDuration: 1), rightThankAnimation(), .wait(forDuration: 9)])))
        leftHand.run(.repeatForever(.sequence([.wait(forDuration: 1), leftThankAnimation(), .wait(forDuration: 9)])))
        thankText.run(.repeatForever(.sequence([.wait(forDuration: 1), .fadeIn(withDuration: 0.3), .wait(forDuration: 2.5), .fadeOut(withDuration: 0.3), .wait(forDuration: 9)])))
    }

    @objc static override public var supportsSecureCoding: Bool {
        get {
            return true
        }
    }
}
