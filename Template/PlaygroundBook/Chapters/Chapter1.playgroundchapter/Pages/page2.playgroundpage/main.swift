/*:
# Practicing
 On this page, the hand will make a random letter gesture, and you will be given three options.
 
 If you get it right, your score and streak will increase. **Try to get 3 in a row to experience a little surprise.**
 
 If you get it wrong, your streak will be set to zero, but don't worry, **you’ll be shown the right answer** so that in the next time you get it right. Have fun and try to learn from your mistakes.
 
> The hand gestures that appear after the attempts are not from _Libras_, they are simply thumbs up and thumbs down.
 
> If you got distracted or it was too fast, you can hit the repeat key to rewatch the sign animation.
 
 */


//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.

import PlaygroundSupport
import SpriteKit
import UIKit
import BookCore

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 512, height: 768))
let scene = RealGameScene(size: CGSize(width:512, height:768))
scene.scaleMode = .aspectFit
sceneView.presentScene(scene)

PlaygroundPage.current.liveView = sceneView
PlaygroundPage.current.needsIndefiniteExecution = true
//
//#-end-hidden-code
