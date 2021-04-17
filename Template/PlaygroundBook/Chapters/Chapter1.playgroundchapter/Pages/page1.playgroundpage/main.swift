/*:
> For a better experience, use this playground on the horizontal and with the split screen mode. It also has some sounds, so turn on the volume if you want to.
 # Learning
 Besides Portuguese, Brazil has a second official language. It's called _Libras_ and means Brazilian sign language. However, the number of people that are able to communicate by it is really small. **The language is not normally taught in schools**.
 
 _Libras_ uses a lot of gestures, facial and corporeal expressions to communicate. Here on this playground, the idea is to **teach the alphabet, which uses only the hand**.

 It is important to highlight that **the alphabet is not the sign language itself, but a essencial part of it.** The letter signs are used as basis to many word signs, and are also used to spell people's and places' names.
 
 On this page, you will have a keyboard where you can **choose letters to see their hand gestures** according to the Libras alphabet.
 > If you clicked a key by mistake or just don't want to see its whole animation, click the "Stop" key.
 
 */

//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//
    import PlaygroundSupport
    import SpriteKit
    import UIKit
    import BookCore

    let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 512, height: 768))
    let scene = GameScene(size: CGSize(width:512, height:768))
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)

    PlaygroundPage.current.liveView = sceneView
    PlaygroundPage.current.needsIndefiniteExecution = true

//#-end-hidden-code
