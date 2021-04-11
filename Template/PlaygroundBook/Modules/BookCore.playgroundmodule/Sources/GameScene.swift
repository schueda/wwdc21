import SpriteKit

public class GameScene: SKScene {
    let animations = Animations()
    
    var anyKeyPressed: Bool = false
    
    var hand: SKSpriteNode!
    var handCenter = CGPoint(x: 0, y: 0)
    var handAnimations: [String: SKAction] = [:]
    var keyNodes: [SKSpriteNode] = []
    
    var keyJ: SKSpriteNode!
    
    let keys = [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                ["Z", "X", "C", "V", "B", "N", "M"]]
    
    func setupHand() {
        handCenter = CGPoint(x: size.width/2, y: size.height/1.7)
        hand = SKSpriteNode(imageNamed: "handDefault")
        hand.position = handCenter
        hand.setScale(0.3)
        hand.name = "hand"
        hand.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0, upperLimit: 0))]
        self.addChild(hand)
    }
    
    func createKey(keyName: String) -> SKSpriteNode {
        let key = SKSpriteNode(imageNamed: "key\(keyName)")
        key.size = CGSize(width: 37.0, height: 47.1)
        key.name = keyName
        
        return key
    }
    
    
    override public func didMove(to view: SKView) {
        setupHand()
        for (indexRow, row) in keys.enumerated() {
            for (indexCol, keyName) in row.enumerated() {
                let key = createKey(keyName: keyName)
                addChild(key)
                let baseX = self.frame.size.width/2 - (CGFloat(keys[0].count) * (key.frame.size.width + 2.5) - 2.5)/2
                let baseY = CGFloat(keys.count) * (key.frame.size.height + 5) + key.frame.size.height/2
                let x = baseX + CGFloat(indexCol) * (key.frame.size.width + 5) + CGFloat(indexRow) * key.frame.size.width/2
                let y = baseY - CGFloat(indexRow) * (key.frame.size.height + 5)
                key.position = CGPoint(x: x, y: y)
                
                keyNodes.append(key)
            }
        }
        
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
        guard !anyKeyPressed,
              let keyNode = keyNodes.first(where: {$0.contains(pos)}),
              let name = keyNode.name,
              let animation = handAnimations[name] else {
            return
        }
        anyKeyPressed = true
        let oldTexture = keyNode.texture
        let oldSize = keyNode.size
        let oldPosition = keyNode.position
        hand.run(animation) {
            keyNode.texture = oldTexture
            keyNode.size = oldSize
            keyNode.position = oldPosition
            self.anyKeyPressed = false
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
