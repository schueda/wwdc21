//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Instantiates a live view and passes it to the PlaygroundSupport framework.
//

import PlaygroundSupport
import SpriteKit
import BookCore

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 512, height: 768))
//let scene = LearningLiveView(size: CGSize(width:512, height:768)))
//scene.scaleMode = .aspectFit
//sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
