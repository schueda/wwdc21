//
//  CutsceneViewController.swift
//  BookCore
//
//  Created by André Schueda on 15/04/21.
//

import SpriteKit
import AVFoundation

public class Cutscene: SKScene {
    let animations = Animations()
    var handAnimations: [String: SKAction] = [:]
    
    var hand: SKSpriteNode!
    var handCenter = CGPoint.zero
        
    var touchDownSound: AVAudioPlayer!
    var touchUpSound: AVAudioPlayer!
    
    var pressedKey: SKSpriteNode!
    var pressedKeyOldTexture: SKTexture!
    var pressedKeyOldPosition: CGPoint!
    var keyDefaultSize = CGSize(width: 37.0*1.2, height: 47.1*1.2)
    let keys = [["T", "H", "E", " ", "W", "O", "R", "L", "D"],
                ["I", "S", " ", "Q", "U", "I", "E", "T"]]
    var keyNodes: [SKSpriteNode] = []
    var anyKeyPressed = false
    
    var startKey: SKSpriteNode!
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "doubleSizeBackground")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
    }
    
    func playTouchDownSound() {
        let url: URL = Bundle.main.url(forResource: "touchDown", withExtension: "mp3")!
        touchDownSound = try! AVAudioPlayer(contentsOf: url, fileTypeHint: nil)

        touchDownSound.prepareToPlay()
        touchDownSound.volume = 0.3
        touchDownSound.play()
    }
    
    func playTouchUpSound() {
        let url: URL = Bundle.main.url(forResource: "touchUp", withExtension: "mp3")!
        touchUpSound = try! AVAudioPlayer(contentsOf: url, fileTypeHint: nil)

        touchUpSound.prepareToPlay()
        touchUpSound.volume = 0.3
        touchUpSound.play()
    }
    
    func createKey(keyName: String) -> SKSpriteNode {
        let key = SKSpriteNode(imageNamed: "key\(keyName)")
        key.size = keyDefaultSize
        key.name = keyName
        return key
    }
    
    func setupKeyboard() {
        for (indexRow, row) in keys.enumerated() {
            for (indexCol, keyName) in row.enumerated() {
                if keyName != " " {
                    let key = createKey(keyName: keyName)
                    
                    let sceneXCenter = self.frame.size.width/2
                    let numberOfKeysOnFirstRow = CGFloat(keys[0].count)
                    let numberOfRows = CGFloat(keys.count)
                    let keyWidth = key.frame.size.width
                    let keyHeight = key.frame.size.height
                    let keyIndex = CGFloat(indexCol)
                    let rowIndex = CGFloat(indexRow)
                    let padding = CGFloat(5)
                    
                    let baseX = sceneXCenter - (numberOfKeysOnFirstRow * (keyWidth + padding/2) - padding/2)/2 + padding/2
                    let x = baseX + keyIndex * (keyWidth + padding) + rowIndex * keyWidth/2 + 60
                    
                    let baseY = numberOfRows * (keyHeight + padding) + keyHeight/2
                    let y = baseY - rowIndex * (keyHeight + padding) + 450
                        
                    key.position = CGPoint(x: x, y: y)
                    addChild(key)
                    
                    keyNodes.append(key)
                }
            }
        }
    }
    
    func setupHand() {
        handCenter = CGPoint(x: size.width * 0.27, y: keyNodes[0].position.y - 27)
        hand = SKSpriteNode(imageNamed: "handDefault")
        hand.position = handCenter
        hand.setScale(0.27)
        hand.name = "hand"
        hand.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0, upperLimit: 0))]
        self.addChild(hand)
    }
    
    func createStartKey() {
        startKey = SKSpriteNode(imageNamed: "startButton")
        startKey.position = CGPoint(x: size.width * 0.5, y: size.height * 0.3)
        startKey.size = CGSize(width: 85.3*1.5, height: 47.1*1.5)
        startKey.name = "startKey"
        self.addChild(startKey)
    }
    
    override public func didMove(to view: SKView) {
        setupBackground()
        setupKeyboard()
        setupHand()
        createStartKey()
        
        handAnimations["T"] = animations.createTAnimation()
        handAnimations["H"] = animations.createHAnimation()
        handAnimations["E"] = animations.createEAnimation()
        handAnimations["W"] = animations.createWAnimation()
        handAnimations["O"] = animations.createOAnimation()
        handAnimations["R"] = animations.createRAnimation()
        handAnimations["L"] = animations.createLAnimation()
        handAnimations["D"] = animations.createDAnimation()
        handAnimations["I"] = animations.createIAnimation()
        handAnimations["S"] = animations.createSAnimation()
        handAnimations["Q"] = animations.createQAnimation()
        handAnimations["U"] = animations.createUAnimation()
        
    }

    @objc static override public var supportsSecureCoding: Bool {
        get {
            return true
        }
    }

    func touchDown(atPoint pos : CGPoint) {
        if startKey.contains(pos) {
            hand.color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        }
        guard !anyKeyPressed,
              let keyNode = keyNodes.first(where: {$0.contains(pos)}),
              let name = keyNode.name,
              let animation = handAnimations[name] else {
            return
        }
        anyKeyPressed = true
        pressedKeyOldTexture = keyNode.texture
        pressedKeyOldPosition = keyNode.position
        hand.run(animation) {
            keyNode.texture = self.pressedKeyOldTexture
            keyNode.size = self.keyDefaultSize
            keyNode.position = self.pressedKeyOldPosition
            self.anyKeyPressed = false
            self.pressedKey = nil
            self.playTouchDownSound()
        }
        playTouchUpSound()
        let newTexture = SKTexture(imageNamed: "keyPressed\(name)")
        keyNode.texture = newTexture
        keyNode.size = CGSize(width: keyNode.frame.size.width, height: keyNode.frame.size.height * 0.8225)
        keyNode.position = CGPoint(x: keyNode.position.x, y: keyNode.position.y - keyNode.frame.size.height * 0.0875)
    }

    func touchMoved(toPoint pos : CGPoint) {
    }

    func touchUp(atPoint pos : CGPoint) {
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }

    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

