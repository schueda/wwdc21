import SpriteKit
import AVFoundation

public class RealGameScene: SKScene {
    let animations = Animations()
    
    var anyKeyPressed: Bool = false
    
    var startButton: SKSpriteNode!
    
    var leftButton: SKSpriteNode!
    var middleButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    var buttons: [SKSpriteNode]  {
        [self.leftButton, self.middleButton, self.rightButton]
    }
    
    var correctSound: AVAudioPlayer!
    var comboSound: AVAudioPlayer!
    var mistakeSound: AVAudioPlayer!
    
    var repeatButton: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var streakLabel: SKLabelNode!
    
    let sparklesHands = SKSpriteNode(imageNamed: "handSparklesIcon")
    var sparklesHandsAnimation: SKAction!
    
    var hand: SKSpriteNode!
    var handCenter = CGPoint(x: 0, y: 0)
    var handAnimations: [String: SKAction] = [:]
    var keyNodes: [SKSpriteNode] = []
    
    let letters = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
                    "A", "S", "D", "F", "G", "H", "J", "K", "L",
                     "Z", "X", "C", "V", "B", "N", "M"]
    
    var options: (left: String, middle: String, right: String)!
    var correct: String!
    
    
    var state = GameState.initialState
    
    var pastRounds = [String]()
    var score: Int = 0
    var streak: Int = 0
    
    func createThreeButtons() {
        leftButton = SKSpriteNode(imageNamed: "keyL")
        leftButton.position = CGPoint(x: size.width * 0.25, y: size.height/4.5)
        leftButton.size = CGSize(width: 37.0 * 2, height: 47.1 * 2)
        leftButton.name = "leftButton"
        leftButton.alpha = 0
        self.addChild(leftButton)
        
        middleButton = SKSpriteNode(imageNamed: "keyM")
        middleButton.position = CGPoint(x: size.width * 0.5, y: size.height/4.5)
        middleButton.size = CGSize(width: 37.0 * 2, height: 47.1 * 2)
        middleButton.name = "middleButton"
        middleButton.alpha = 0
        self.addChild(middleButton)
        
        rightButton = SKSpriteNode(imageNamed: "keyR")
        rightButton.position = CGPoint(x: size.width * 0.75, y: size.height/4.5)
        rightButton.size = CGSize(width: 37.0 * 2, height: 47.1 * 2)
        rightButton.name = "rightButton"
        rightButton.alpha = 0
        self.addChild(rightButton)
    }
    
    func createRepeatButton() {
        repeatButton = SKSpriteNode(imageNamed: "keyRepeat")
        repeatButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.925)
        repeatButton.size = CGSize(width: 37.0, height: 47.1)
        repeatButton.name = "repeatButton"
        repeatButton.alpha = 0
        self.addChild(repeatButton)
    }
    
    func runRound(animationLetter: String, completion: (()->())? = nil) {
        state = .animationState
        let interval = SKAction.wait(forDuration: 0.7)
        let animation = handAnimations[correct]!
        
        hand.run(.sequence([interval, animation])) {
            self.state = .entryState
            self.leftButton.run(.fadeIn(withDuration: 0.2))
            self.middleButton.run(.fadeIn(withDuration: 0.2))
            self.rightButton.run(.fadeIn(withDuration: 0.2))
            self.repeatButton.run(.fadeIn(withDuration: 0.2))
            completion?()
        }
    }
    
    func startRound() {
        let generatedRound = generateRound()
        options = generatedRound.options
        correct = generatedRound.correct
        leftButton.texture = SKTexture(imageNamed: "key\(options.left)")
        leftButton.name = options.left
        middleButton.texture = SKTexture(imageNamed: "key\(options.middle)")
        middleButton.name = options.middle
        rightButton.texture = SKTexture(imageNamed: "key\(options.right)")
        rightButton.name = options.right

        runRound(animationLetter: correct)
    }
    
    func generateRound() -> (options: (left: String, middle: String, right: String), correct: String) {
        var lettersCopy = letters.filter({
            !pastRounds.contains($0)
        })
        if pastRounds.count == 3 {
            pastRounds = Array(pastRounds[1...2])
        }
        lettersCopy.shuffle()
        let chosenLetters = lettersCopy[0...2]
        let correct = chosenLetters.randomElement()!
        pastRounds.append(correct)
        
        return ((chosenLetters[0], chosenLetters[1], chosenLetters[2]), correct)
    }
    
    func attemptChoice(pressedButtonName: String) {
        state = .resultState
        let pressedButton = buttons.first(where: {$0.name == pressedButtonName})!
        if pressedButtonName == correct {
            score += 1
            streak += 1
            pressedButton.texture = SKTexture(imageNamed: "pressedCorrectKey\(correct!)")
            pressedButton.size =  CGSize(width: pressedButton.frame.size.width, height: pressedButton.frame.size.height * 0.8225)
            pressedButton.position = CGPoint(x: pressedButton.position.x, y: pressedButton.position.y - pressedButton.frame.size.height * 0.0875)
            hand.run(handAnimations["correct"]!)

            if streak%3 == 0 {
                playComboSound()
                sparklesHands.run(sparklesHandsAnimation)
            } else {
                playCorrectSound()
            }
        } else {
            streak = 0
            pressedButton.texture = SKTexture(imageNamed: "wrongKey\(pressedButtonName)")
            pressedButton.size =  CGSize(width: pressedButton.frame.size.width, height: pressedButton.frame.size.height * 0.8225)
            pressedButton.position = CGPoint(x: pressedButton.position.x, y: pressedButton.position.y - pressedButton.frame.size.height * 0.0875)
            
            let correctButton = buttons.first(where: {$0.name == correct})!
            correctButton.texture = SKTexture(imageNamed: "correctKey\(correct!)")
            hand.run(handAnimations["mistake"]!)
            playMistakeSound()
        }
        changeScore()
        changeStreak()
        
        run(SKAction.wait(forDuration: 2)) {
            self.leftButton.run(.fadeOut(withDuration: 0.2))
            self.middleButton.run(.fadeOut(withDuration: 0.2))
            self.rightButton.run(.fadeOut(withDuration: 0.2))
            self.repeatButton.run(.fadeOut(withDuration: 0.2)){
                self.startRound()
                pressedButton.size = CGSize(width: pressedButton.frame.size.width, height: pressedButton.frame.size.height / 0.8225)
                pressedButton.position = CGPoint(x: pressedButton.position.x, y: self.size.height/4.5)
            }
        }
    }
    
    func changeScore() {
        scoreLabel.text = String(score)
    }
    
    func changeStreak() {
        streakLabel.text = String(streak)
        if streak%5 == 0 {
        }
    }
    
    func createScore() {
        let scoreTitle = SKSpriteNode(imageNamed: "score")
        scoreTitle.position = CGPoint(x: size.width*0.12, y: size.height*0.95)
        scoreTitle.size = CGSize(width: 53.6, height: 23.7)
        scoreLabel = SKLabelNode(text: String(score))
        scoreLabel.position =  CGPoint(x: size.width * 0.12, y: size.height*0.9)
        scoreLabel.fontColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1)
        scoreLabel.fontName = "avenir"
        addChild(scoreTitle)
        addChild(scoreLabel)
    }
    
    func createStreak() {
        let streakTitle = SKSpriteNode(imageNamed: "streak")
        streakTitle.position = CGPoint(x: size.width*0.87, y: size.height*0.95)
        streakTitle.size = CGSize(width: 60.2, height: 23.7)
        streakLabel = SKLabelNode(text: String(streak))
        streakLabel.position = CGPoint(x: size.width*0.87, y: size.height*0.9)
        streakLabel.fontColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1)
        streakLabel.fontName = "avenir"
        addChild(streakTitle)
        addChild(streakLabel)
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
    }
    
    func setupHand() {
        handCenter = CGPoint(x: size.width * 0.53 , y: size.height * 0.59)
        hand = SKSpriteNode(imageNamed: "handDefault")
        hand.position = handCenter
        hand.setScale(0.65)
        hand.name = "hand"
        hand.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0, upperLimit: 0))]
        self.addChild(hand)
    }
    
    func createStartButton() {
        startButton = SKSpriteNode(imageNamed: "startButton")
        startButton.position = CGPoint(x: size.width/2, y: size.height/4.5)
        startButton.size = CGSize(width: 85.3*2, height: 47.1*2)
        startButton.name = "startButton"
        self.addChild(startButton)
    }
    
    func playCorrectSound() {
        let url: URL = Bundle.main.url(forResource: "correct", withExtension: "mp3")!
        correctSound = try! AVAudioPlayer(contentsOf: url, fileTypeHint: nil)

        correctSound.prepareToPlay()
        correctSound.volume = 0.3
        correctSound.play()
    }
    
    func playComboSound() {
        let url: URL = Bundle.main.url(forResource: "combo", withExtension: "mp3")!
        comboSound = try! AVAudioPlayer(contentsOf: url, fileTypeHint: nil)

        comboSound.prepareToPlay()
        comboSound.volume = 0.3
        comboSound.play()
    }
    
    func playMistakeSound() {
        let url: URL = Bundle.main.url(forResource: "mistake", withExtension: "mp3")!
        mistakeSound = try! AVAudioPlayer(contentsOf: url, fileTypeHint: nil)

        mistakeSound.prepareToPlay()
        mistakeSound.volume = 0.3
        mistakeSound.play()
    }
    
    func playTouchUpSound() {
        let url: URL = Bundle.main.url(forResource: "touchUp", withExtension: "mp3")!
        mistakeSound = try! AVAudioPlayer(contentsOf: url, fileTypeHint: nil)

        mistakeSound.prepareToPlay()
        mistakeSound.volume = 0.3
        mistakeSound.play()
    }
    
    func playTouchDownSound() {
        let url: URL = Bundle.main.url(forResource: "touchDown", withExtension: "mp3")!
        mistakeSound = try! AVAudioPlayer(contentsOf: url, fileTypeHint: nil)

        mistakeSound.prepareToPlay()
        mistakeSound.volume = 0.3
        mistakeSound.play()
    }
    
    func playStartSound() {
        let url: URL = Bundle.main.url(forResource: "startSound", withExtension: "mp3")!
        mistakeSound = try! AVAudioPlayer(contentsOf: url, fileTypeHint: nil)

        mistakeSound.prepareToPlay()
        mistakeSound.volume = 0.3
        mistakeSound.play()
    }
    
    
    override public func didMove(to view: SKView) {
        setupBackground()
        setupHand()
        createStartButton()
        
        sparklesHands.position = CGPoint(x: size.width*1.1, y: size.height*0.84)
        sparklesHands.setScale(0.1)
        addChild(sparklesHands)
        sparklesHandsAnimation = animations.createSparklesHandsAnimation(size: size)
        
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
        
        handAnimations["correct"] = animations.createCorrectAnimation()
        handAnimations["mistake"] = animations.createMistakeAnimation()
        
        
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
        if startButton.contains(pos) {
            startButton.texture = SKTexture(imageNamed: "pressedStartButton")
            startButton.size = CGSize(width: startButton.frame.size.width, height: startButton.frame.size.height * 0.8225)
            startButton.position = CGPoint(x: startButton.position.x, y: startButton.position.y - startButton.frame.size.height * 0.0875)
            playStartSound()
            startButton.run(.wait(forDuration: 0.35)) {
                self.startButton.texture = SKTexture(imageNamed: "startButton")
                self.startButton.size = CGSize(width: self.startButton.frame.size.width, height: self.startButton.frame.size.height / 0.8225)
                self.startButton.position = CGPoint(x: self.startButton.position.x, y: self.size.height/4.5 )
                self.startButton.run(.wait(forDuration: 0.35)) {
                    self.startButton.run(.fadeOut(withDuration: 0.2)) {
                        self.startButton.position = CGPoint(x: 1000, y: 1000)
                        self.startButton.removeFromParent()
                        self.createThreeButtons()
                        self.createRepeatButton()
                        self.startRound()
                        self.createScore()
                        self.createStreak()
                    }
                }
            }
        }
        
        if state == .entryState {
            if leftButton.contains(pos) {
                attemptChoice(pressedButtonName: leftButton.name!)
            }
            
            if middleButton.contains(pos) {
                attemptChoice(pressedButtonName: middleButton.name!)
            }
            
            if rightButton.contains(pos) {
                attemptChoice(pressedButtonName: rightButton.name!)
            }
            
            if repeatButton.contains(pos) {
                leftButton.run(.fadeOut(withDuration: 0.2))
                middleButton.run(.fadeOut(withDuration: 0.2))
                rightButton.run(.fadeOut(withDuration: 0.2))
                
                runRound(animationLetter: correct) {
                    self.repeatButton.texture = SKTexture(imageNamed: "keyRepeat")
                    self.repeatButton.size = CGSize(width: 37.0, height: 47.1)
                    self.repeatButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.925)
                    self.playTouchDownSound()
                }
                playTouchUpSound()
                repeatButton.texture = SKTexture(imageNamed: "keyPressedRepeat")
                repeatButton.size = CGSize(width: repeatButton.frame.size.width, height: repeatButton.frame.size.height * 0.8225)
                repeatButton.position = CGPoint(x: repeatButton.position.x, y: repeatButton.position.y - repeatButton.frame.size.height * 0.04375)
                
            }
        }
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

enum GameState {
    case initialState
    case animationState
    case entryState
    case resultState
}
    
