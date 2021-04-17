//
//  CutsceneViewController.swift
//  BookCore
//
//  Created by André Schueda on 15/04/21.
//

import SpriteKit
import AVFoundation
import PlaygroundSupport

public class Cutscene: SKScene {
    let animations = Animations()
    var handAnimations: [String: SKAction] = [:]
    
    var text1 = SKSpriteNode(imageNamed: "flyText")
    var text2 = SKSpriteNode(imageNamed: "beachesText")
    var icon1 = SKLabelNode(text: "􀑓")
    var icon2 = SKLabelNode(text: "􀆷")
    
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
    var startKeyPosition: CGPoint!
    
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
    
    func playStartSound() {
        let url: URL = Bundle.main.url(forResource: "startSound", withExtension: "mp3")!
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
    
    func createText1() {
        text1.alpha = 0
        text1.size = CGSize(width: text1.size.width * 0.5, height: text1.size.height * 0.5)
        text1.position = CGPoint(x: size.width * 0.25, y: size.height * 0.75)
        addChild(text1)
        
    }
    
    func createText2() {
        text2.alpha = 0
        text2.size = CGSize(width: text2.size.width * 0.5, height: text2.size.height * 0.5)
        text2.position = CGPoint(x: size.width * 0.75, y: size.height * 0.25)
        addChild(text2)
    }
    
    func createIcon1() {
        icon1.alpha = 0
        icon1.position = CGPoint(x: size.width * 0.25, y: size.height * 0.55)
        icon1.fontSize = 100
        icon1.fontColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1)
        addChild(icon1)
    }
    
    func createIcon2() {
        icon2.alpha = 0
        icon2.position = CGPoint(x: size.width * 0.75, y: size.height * 0.4)
        icon2.fontSize = 100
        icon2.fontColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1)
        addChild(icon2)
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
        startKeyPosition = CGPoint(x: size.width * 0.5, y: size.height * 0.3)
        startKey = SKSpriteNode(imageNamed: "startButton")
        startKey.position = startKeyPosition
        startKey.size = CGSize(width: 85.3*1.5, height: 47.1*1.5)
        startKey.name = "startKey"
        self.addChild(startKey)
    }
    
    override public func didMove(to view: SKView) {
        setupBackground()
        setupKeyboard()
        setupHand()
        createStartKey()
        
        createText1()
        createText2()
        createIcon1()
        createIcon2()
        
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
    
    func wholeAnimation() {
        let fadeDuration = 1.0
        let intervalDuration = 2.5
        let silentDuration = 0.5
        let fadeIn = SKAction.fadeIn(withDuration: fadeDuration)
        let fadeOut = SKAction.fadeOut(withDuration: fadeDuration)
        let halfScale = SKAction.scale(by: 0.5, duration: 0)
        let rotateIcon2ToDefault = SKAction.run {self.icon2.zRotation = 0}
        
        let intervalWithFades = SKAction.wait(forDuration: intervalDuration + 2*fadeDuration)
        let interval = SKAction.wait(forDuration: intervalDuration)
        let silentInterval = SKAction.wait(forDuration: silentDuration)
        
        let startDelay = SKAction.wait(forDuration: 1)
        
        //bloco de codigo text1
        let moveToFamily = SKAction.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.35), duration: 0)
        let changeToFamilyText = SKAction.setTexture(SKTexture(imageNamed: "familyText"), resize: true)
        let moveToGramma = SKAction.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.75), duration: 0)
        let changeToGrammaText = SKAction.setTexture(SKTexture(imageNamed: "grammaText"), resize: true)
        let moveToCommunication = SKAction.move(to: CGPoint(x: size.width * 0.75, y: size.height * 0.75), duration: 0)
        let changeToCommunicationText = SKAction.setTexture(SKTexture(imageNamed: "communicatingText"), resize: true)
        
        //bloco de codigo do text2
        let changeToFrustratingText = SKAction.setTexture(SKTexture(imageNamed: "frustratingText"), resize: true)
        let moveToLove = SKAction.move(to: CGPoint(x: size.width * 0.75, y: size.height * 0.25), duration: 0)
        let changeToLoveText = SKAction.setTexture(SKTexture(imageNamed: "loveText"), resize: true)
        let moveToDeaf = SKAction.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.4), duration: 0)
        let changeToDeafText = SKAction.setTexture(SKTexture(imageNamed: "deafText"), resize: true)
        
        //bloco de codigo do icon1
        let moveToCenter = SKAction.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.5), duration: 0)
        let changeToFamilyIcon = SKAction.run { self.icon1.text = "􀝋" }
        let moveToUnderGramma = SKAction.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.5), duration: 0)
        let changeToStoryIcon = SKAction.run { self.icon1.text = "􀌯" }
        let moveToUnderCommunicating = SKAction.move(to: CGPoint(x: size.width * 0.75, y: size.height * 0.5), duration: 0)
        let changeToCommunicatingIcon = SKAction.run { self.icon1.text = "􀯩" }
        
        //bloco de codigo do icon2
        let moveToOverFamily = SKAction.move(to: CGPoint(x: size.width * 0.46, y: size.height * 0.5), duration: 0)
        let changeToFrustratingIcon = SKAction.run { self.icon2.text = "􀓨" }
        let rotateIcon2 = SKAction.run {self.icon2.zRotation = -.pi/4}
        let moveToUnderLove = SKAction.move(to: CGPoint(x: size.width * 0.75, y: size.height * 0.4), duration: 0)
        let changeToLoveIcon = SKAction.run { self.icon2.text = "􀊵" }
        let moveToUnderDeaf = SKAction.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.5), duration: 0)
        let changeToDeafIcon = SKAction.run { self.icon2.text = "􀧁" }
        
        text1.run(SKAction.sequence([startDelay, fadeIn, interval, fadeOut,
                                     moveToFamily, changeToFamilyText, halfScale, intervalWithFades, silentInterval, silentInterval, fadeIn, interval, fadeOut,
                                     moveToGramma, changeToGrammaText, intervalWithFades, silentInterval, silentInterval, fadeIn, interval, fadeOut,
                                     moveToCommunication, changeToCommunicationText, intervalWithFades, silentInterval, silentInterval, fadeIn, interval, fadeOut]))

        icon1.run(SKAction.sequence([startDelay, fadeIn, interval, fadeOut,
                                     moveToCenter, changeToFamilyIcon, intervalWithFades, silentInterval, silentInterval, fadeIn, interval, fadeOut,
                                     moveToUnderGramma, changeToStoryIcon, intervalWithFades, silentInterval, silentInterval, fadeIn, interval, fadeOut,
                                     moveToUnderCommunicating, changeToCommunicatingIcon, intervalWithFades, silentInterval,silentInterval, fadeIn, interval, fadeOut]))

        text2.run(SKAction.sequence([startDelay, intervalWithFades, silentInterval, fadeIn, interval, fadeOut,
                                     moveToFamily, changeToFrustratingText, halfScale, intervalWithFades, silentInterval, silentInterval, fadeIn, interval, fadeOut,
                                     moveToLove, changeToLoveText, intervalWithFades, silentInterval, silentInterval, fadeIn, interval, fadeOut,
                                     moveToDeaf, changeToDeafText, intervalWithFades, silentInterval, fadeIn]))

        icon2.run(SKAction.sequence([startDelay, intervalWithFades, silentInterval, fadeIn, interval, fadeOut,
                                     moveToOverFamily, changeToFrustratingIcon, rotateIcon2, intervalWithFades, silentInterval, silentInterval, fadeIn, interval, fadeOut,
                                     rotateIcon2ToDefault, moveToUnderLove, changeToLoveIcon, intervalWithFades, silentInterval, silentInterval, fadeIn, interval, fadeOut,
                                     moveToUnderDeaf, changeToDeafIcon, intervalWithFades, silentInterval, fadeIn, interval])) {
            PlaygroundPage.current.navigateTo(page: .next)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let fadeDuration = 0.4
        if startKey.contains(pos) {
            playStartSound()
            startKey.texture = SKTexture(imageNamed: "pressedStartButton")
            startKey.size = CGSize(width: startKey.frame.size.width, height: startKey.frame.size.height * 0.8225)
            startKey.position = CGPoint(x: startKey.position.x, y: startKey.position.y - startKey.frame.size.height * 0.0875)
            startKey.run(.wait(forDuration: 0.35)) {
                self.startKey.texture = SKTexture(imageNamed: "startButton")
                self.startKey.size = CGSize(width: self.startKey.frame.size.width, height: self.startKey.frame.size.height / 0.8225)
                self.startKey.position = CGPoint(x: self.startKey.position.x, y: self.startKeyPosition.y)
                self.startKey.run(.wait(forDuration: 0.35)) {
                    for key in self.keyNodes {
                        key.run(.fadeOut(withDuration: fadeDuration))
                    }
                    self.hand.run(.fadeOut(withDuration: fadeDuration))
                    self.startKey.run(.fadeOut(withDuration: fadeDuration)) {
                        self.startKey.position = CGPoint(x: 1000, y: 1000)
                        self.startKey.removeFromParent()
                        for key in self.keyNodes {
                            key.position = CGPoint(x: 1000, y: 1000)
                            key.removeFromParent()
                        }
                        self.hand.removeFromParent()
                        self.wholeAnimation()
                    }
                }
            }
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
