import SpriteKit

public class GameScene: SKScene {
    let animations = Animations()
    
    var anyKeyPressed: Bool = false
    
    var hand: SKSpriteNode!
    var handCenter = CGPoint(x: 0, y: 0)
    var handAnimations: [String: SKAction] = [:]
    var keyNodes: [SKSpriteNode] = []
    var pressedKey: SKSpriteNode!
    var pressedKeyOldTexture: SKTexture!
    var pressedKeyOldPosition: CGPoint!
    
    var keyDefaultSize = CGSize(width: 37.0, height: 47.1)
    var stopKey: SKSpriteNode!
    
    let keys = [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                ["Z", "X", "C", "V", "B", "N", "M"]]
    
    func setupHand() {
        handCenter = CGPoint(x: size.width * 0.53 , y: size.height * 0.59)
        hand = SKSpriteNode(imageNamed: "handDefault")
        hand.position = handCenter
        hand.setScale(0.3)
        hand.name = "hand"
        hand.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0, upperLimit: 0))]
        self.addChild(hand)
    }
    
    func createKey(keyName: String) -> SKSpriteNode {
        let key = SKSpriteNode(imageNamed: "key\(keyName)")
        key.size = keyDefaultSize
        key.name = keyName
        
        return key
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
    }
    
    func setupKeyboard() {
        for (indexRow, row) in keys.enumerated() {
            for (indexCol, keyName) in row.enumerated() {
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
                let x = baseX + keyIndex * (keyWidth + padding) + rowIndex * keyWidth/2
                
                let baseY = numberOfRows * (keyHeight + padding) + keyHeight/2
                let y = baseY - rowIndex * (keyHeight + padding)
                
                key.position = CGPoint(x: x, y: y)
                addChild(key)
                
                keyNodes.append(key)
            }
        }
    }
    
    func setupStopKey() {
        stopKey = SKSpriteNode(imageNamed: "keyStop")
        stopKey.size = CGSize(width: 79.0, height: 47.1)
        let lastKey = keyNodes.last!
        let x = lastKey.position.x + lastKey.size.width/2 + 5 + stopKey.size.width/2
        stopKey.position = CGPoint(x: x , y: lastKey.position.y)
        addChild(stopKey)
    }
    
    override public func didMove(to view: SKView) {
        setupBackground()
        setupHand()
        setupKeyboard()
        setupStopKey()
        
        handAnimations["A"] = animations.createAAnimation()
        handAnimations["B"] = animations.createBAnimation()
        handAnimations["C"] = animations.createCAnimation()
        handAnimations["D"] = animations.createDAnimation()
        handAnimations["E"] = animations.createEAnimation()
        handAnimations["F"] = animations.createFAnimation()
        handAnimations["G"] = animations.createGAnimation()
        handAnimations["H"] = animations.createHAnimation()
        handAnimations["I"] = animations.createIAnimation()
        handAnimations["J"] = animations.createJAnimation(size: size, handCenter: handCenter)
        handAnimations["K"] = animations.createKAnimation(size: size, handCenter: handCenter)
        handAnimations["L"] = animations.createLAnimation()
        handAnimations["M"] = animations.createMAnimation()
        handAnimations["N"] = animations.createNAnimation()
        handAnimations["O"] = animations.createOAnimation()
        handAnimations["P"] = animations.createPAnimation()
        handAnimations["Q"] = animations.createQAnimation()
        handAnimations["R"] = animations.createRAnimation()
        handAnimations["S"] = animations.createSAnimation()
        handAnimations["T"] = animations.createTAnimation()
        handAnimations["U"] = animations.createUAnimation()
        handAnimations["V"] = animations.createVAnimation()
        handAnimations["W"] = animations.createWAnimation()
        handAnimations["X"] = animations.createXAnimation(size: size, handCenter: handCenter)
        handAnimations["Y"] = animations.createYAnimation(size: size, handCenter: handCenter)
        handAnimations["Z"] = animations.createZAnimation(size: size, handCenter: handCenter)
        
        handAnimations["default"] = animations.returnToDefaultAnimation(handCenter: handCenter)
        
        
//        let camera = SKCameraNode()
//        camera.setScale(3)
//        addChild(camera)
//        self.camera = camera

    }

    @objc static override public var supportsSecureCoding: Bool {
        get {
            return true
        }
    }

    func touchDown(atPoint pos : CGPoint) {
        if stopKey.contains(pos) {
            guard pressedKey != nil else {
                return
            }
            let pressTexture = SKAction.setTexture(SKTexture(imageNamed: "pressedKeyStop"))
            let pressSize = SKAction.resize(toHeight: keyDefaultSize.height * 0.8225, duration: 0)
            let pressPositon = SKAction.move(to: CGPoint(x: stopKey.position.x, y: stopKey.position.y - keyDefaultSize.height * 0.0875), duration: 0)
            let pressKey = SKAction.group([pressTexture, pressSize, pressPositon])

            let interval = SKAction.wait(forDuration: 0.4)

            let unpressTexture = SKAction.setTexture(SKTexture(imageNamed: "keyStop"))
            let unpressSize = SKAction.resize(toHeight: keyDefaultSize.height, duration: 0)
            let unpressPositon = SKAction.move(to: CGPoint(x: stopKey.position.x, y: keyNodes.last!.position.y), duration: 0)
            let unpressKey = SKAction.group([unpressTexture, unpressSize, unpressPositon])
            stopKey.run(SKAction.sequence([pressKey, interval, unpressKey]))
            
            pressedKey.texture = pressedKeyOldTexture
            pressedKey.size = keyDefaultSize
            pressedKey.position = pressedKeyOldPosition
            pressedKey = nil
            anyKeyPressed = false
            let returnDefaultAnimation = handAnimations["default"]!
            hand.removeAllActions()
            hand.run(returnDefaultAnimation)
        }
        
        guard !anyKeyPressed,
              let keyNode = keyNodes.first(where: {$0.contains(pos)}),
              let name = keyNode.name,
              let animation = handAnimations[name] else {
            return
        }
        pressedKey = keyNode
        anyKeyPressed = true
        pressedKeyOldTexture = keyNode.texture
        pressedKeyOldPosition = keyNode.position
        hand.run(animation) {
            keyNode.texture = self.pressedKeyOldTexture
            keyNode.size = self.keyDefaultSize
            keyNode.position = self.pressedKeyOldPosition
            self.anyKeyPressed = false
            self.pressedKey = nil
        }
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

extension CGPoint {
  public static func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
  }
}
