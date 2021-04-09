//
//  Animations.swift
//  BookCore
//
//  Created by André Schueda on 08/04/21.
//

import SpriteKit

class Animations {
    let defaultHand = SKAction.setTexture(SKTexture(imageNamed: "handDefault"), resize: true)
    
    func createSingleFrameAnimation(imageNamed imageName: String) -> SKAction {
        let hand = SKAction.setTexture(SKTexture(imageNamed: imageName), resize: true)
        let interval = SKAction.wait(forDuration: 2)
        
        return SKAction.sequence([defaultHand, hand, interval, defaultHand])
    }
    
    func createAAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handA")
    }
    
    func createBAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handB")
    }
    
    func createCAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handC")
    }
    
    func createDAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handD")
    }
    
    func createEAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handE")
    }
    
    func createFAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handF")
    }
    
    func createGAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handG")
    }
    
    func createHAnimation() -> SKAction {
        let hHandRotationDuration = 0.4
        
        var hImages = [SKTexture]()
        hImages.append(SKTexture(imageNamed: "handH2"))
        hImages.append(SKTexture(imageNamed: "handH3"))
        hImages.append(SKTexture(imageNamed: "handH4"))
        hImages.append(SKTexture(imageNamed: "handH5"))
        hImages.append(SKTexture(imageNamed: "handH6"))
        hImages.append(SKTexture(imageNamed: "handH7"))
        hImages.append(SKTexture(imageNamed: "handH8"))
        hImages.append(SKTexture(imageNamed: "handH9"))
        let hRotation = SKAction.animate(with: hImages, timePerFrame: hHandRotationDuration/Double(hImages.count))
        
        let hInitialHand = SKAction.setTexture(SKTexture(imageNamed: "handH1"))
        let hFinalHand = SKAction.setTexture(SKTexture(imageNamed: "handH10"))

        let interval = SKAction.wait(forDuration: 0.4)
        
        return SKAction.sequence([defaultHand, hInitialHand, interval, hRotation, hFinalHand, interval, defaultHand])
    }
    
    func createIAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handI")
    }
    
    func createJAnimation(size: CGSize, handCenter: CGPoint) -> SKAction {
        var jHandRotation = [SKTexture]()
        jHandRotation.append(SKTexture(imageNamed: "handJ2"))
        jHandRotation.append(SKTexture(imageNamed: "handJ3"))
        jHandRotation.append(SKTexture(imageNamed: "handJ4"))
        jHandRotation.append(SKTexture(imageNamed: "handJ5"))
        jHandRotation.append(SKTexture(imageNamed: "handJ6"))
        jHandRotation.append(SKTexture(imageNamed: "handJ7"))
        jHandRotation.append(SKTexture(imageNamed: "handJ8"))
        jHandRotation.append(SKTexture(imageNamed: "handJ9"))
        jHandRotation.append(SKTexture(imageNamed: "handJ10"))
        
        let interval = SKAction.wait(forDuration: 1)
        let jHandgoingDownDuration = 0.15
        let jHandRotationDuration = 0.5
        
        // translation animation
        let jInitPoint = CGPoint(x: size.width/1.5, y: size.height/1.4)
        let jIntermediatePoint = CGPoint(x: size.width/1.5, y: size.height/1.5)
        let jArcCenterPoint = CGPoint(x: size.width/2, y: size.height/1.5)
        let jRadius = jArcCenterPoint.x - jIntermediatePoint.x
        
        let jPathHandDown = UIBezierPath()
        jPathHandDown.move(to: .zero)
        jPathHandDown.addLine(to: jIntermediatePoint - jInitPoint)
        
        let jPathRotatingHand = UIBezierPath()
        jPathRotatingHand.move(to: .zero)
        jPathRotatingHand.addArc(withCenter: jArcCenterPoint - jIntermediatePoint, radius: jRadius, startAngle: .pi, endAngle: 0, clockwise: false)
        
        let movementToJInitialPosition = SKAction.move(to: jInitPoint, duration: 0.2)
        let jFirstFollow = SKAction.follow(jPathHandDown.cgPath, duration: jHandgoingDownDuration)
        let jSecondFollow = SKAction.follow(jPathRotatingHand.cgPath, duration: jHandRotationDuration)
        let returnCenter = SKAction.move(to: handCenter, duration: 0.2)
        
        //hand animation
        let defaultHand = SKAction.setTexture(SKTexture(imageNamed: "handDefault"))
        let jInitialHand = SKAction.setTexture(SKTexture(imageNamed: "handJ1"))
        let handRotation = SKAction.animate(with: jHandRotation, timePerFrame: jHandRotationDuration/Double(jHandRotation.count))
        
        let initialPositionGroup = SKAction.group([movementToJInitialPosition, defaultHand])
        let handRotationGroup = SKAction.group([jSecondFollow, handRotation])
        let returnDefaultGroup = SKAction.group([returnCenter, defaultHand])
        
        return SKAction.sequence([initialPositionGroup, jInitialHand, interval, jFirstFollow, handRotationGroup, interval, returnDefaultGroup])
    }
    
    func createKAnimation(size: CGSize, handCenter: CGPoint) -> SKAction {
        let interval = SKAction.wait(forDuration: 0.4)
        let kTopPoint = CGPoint(x: size.width/2, y: size.height/1.4)
        
        let kHand = SKAction.setTexture(SKTexture(imageNamed: "handK"))
        
        let kHandUp = SKAction.move(to: kTopPoint, duration: 0.3)
        let kHandDown = SKAction.move(to: handCenter, duration: 0.3)
        
        return SKAction.sequence([defaultHand, kHand, interval, kHandUp, kHandDown, interval, defaultHand])
        
    }
    
    func createLAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handL")
    }
    
    func createMAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handM")
    }
    
    func createNAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handN")
    }
    
    func createOAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handO")
    }
    
    func createPAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handP")
    }
    
    func createQAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handQ")
    }
    
    func createRAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handR")
    }
    
    func createSAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handS")
    }
    
    func createTAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handT")
    }
    
    func createUAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handU")
    }
    
    func createVAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handV")
    }
    
    func createWAnimation() -> SKAction {
        return createSingleFrameAnimation(imageNamed: "handW")
    }
    
    func createXAnimation(size: CGSize, handCenter: CGPoint) -> SKAction {
        let xHand = SKAction.setTexture(SKTexture(imageNamed: "handX"), resize: true)
        let interval = SKAction.wait(forDuration: 0.3)
        
        let lookDistant = SKAction.scale(by: 0.64, duration: 0.5)
        let lookCloser = SKAction.scale(by: 1.5625, duration: 0.5)
        
        let distantPoint = CGPoint(x: size.width/2.3, y:handCenter.y)
        let moveLeft = SKAction.move(to: distantPoint, duration: 0.5)
        let moveRight = SKAction.move(to: handCenter, duration: 0.5)
        
        let makeDistant = SKAction.group([lookDistant, moveLeft])
        let makeCloser = SKAction.group([lookCloser, moveRight])
        
        return SKAction.sequence([defaultHand, xHand, interval, makeDistant, makeCloser, interval, defaultHand])
    }
    
    func createYAnimation(size: CGSize, handCenter: CGPoint) -> SKAction {
        // to-do:
        return createAAnimation()
    }
    
    func createZAnimation(size: CGSize, handCenter: CGPoint) -> SKAction {
        // to-do:
        return createAAnimation()
    }
}
