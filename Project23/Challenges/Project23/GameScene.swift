//
//  GameScene.swift
//  Project23
//
//  Created by Михаил Тихомиров on 15.02.2024.
//

import AVFoundation
import SpriteKit

// for create enemy func
enum ForcedBomb {
    case never, always, random
}


// one - may be a bomb or not
// CaseIterable - that lists all its cases as an array so we can pick random sequence types to run our game!
// This thing is used in
enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}


 

class GameScene: SKScene {
    
    var gameScore:SKLabelNode!
    
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var livesImages = [SKSpriteNode]()
    
    var lives = 3
    
    var activeSliceBG: SKShapeNode! // backGround
    var activeSliceFG: SKShapeNode! // foreGround
    
    var activeSlicePoints = [CGPoint]()
    var isSwooshSoundActive = false
    var activeEnemies = [SKSpriteNode]()
    var bombSoundEffect: AVAudioPlayer?
    
    var popupTime = 0.9  // time between the last enemy is being destroyed and a new one being created!
    var sequence = [SequenceType]()
    var sequencePosition = 0   // that tells us where we are in the game. (in sequence array)
    var chainDelay = 3.0       // how long to wait before creating a new enemy when the sequence type is chained
    var nextSequenceQueued = true // we use it to know when all enemies are destroyed

    // MARK: challenge 2.1
    var goldEnemy:Int = 0
    
    var isGameEnded = false
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // it`s less than gravity of earth - 9.8 (stay in the air a bit longer)
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85 // this causes all movement in the game (slow rate)
        
        
        createScore()
        createLives()
        createSlices()
        
        // this our starting sequence for the game
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0...1000 {
            // allCases works because of CaseIterable
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
        
        // so we call that after two seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tossEnemies()
        }
    }
    
    
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    
    
    func createLives() {
        for i in 0..<3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            livesImages.append(spriteNode)
        }
    }
    
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameEnded == false else { return }
        
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
        
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint { // so it`ll only enter the loop if the node is SKSpriteNode
            if node.name == "enemy" || node.name == "gold_enemy" {
                // destroy the penguin
                
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitter.position = node.position
                    addChild(emitter)
                }
                
                
                
                // physics bodies take less CPU time to calculate in the physics simulator, and still respond to collisions.
                
                node.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut]) // group specifies that all actions inside shoud run simultaneously
                
                let seq = SKAction.sequence([group, .removeFromParent()]) // specifies runs them all one ar a time
                node.run(seq)
                if node.name == "gold_enemy" {
                    score += 5
                }else {
                    score += 1
                }
                node.name = ""
                
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
//                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                
            } else if node.name == "bomb" {
                // destroy the bomb
                // we need to find here the main container
                guard let bombContainer = node.parent as? SKSpriteNode else { continue } // if it`s not go to the next node in for case let
                
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                
                node.name = ""
                bombContainer.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut]) // group specifies that all actions inside shoud run simultaneously
                
                let seq = SKAction.sequence([group, .removeFromParent()]) // specifies runs them all one ar a time
                bombContainer.run(seq)
                
                
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
//                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggeredByBomb: true)
            }
        }
    }
    
    func endGame(triggeredByBomb: Bool) {
        guard isGameEnded == false else { return }
        
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false  // these are from tapping or swiping on our screen anymore
        
        bombSoundEffect?.stop()
        bombSoundEffect = nil // stop it and destroy AV audio player
        
        if triggeredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        //MARK: CHallenge 3.1
        let gameover = SKSpriteNode(imageNamed: "gameOver")
        gameover.position = CGPoint(x: 512, y: 384)
        addChild(gameover)
    }
    
    func playSwooshSound() {
         isSwooshSoundActive = true
        
         let randomNumber = Int.random(in: 1...3)
         let soundName = "swoosh\(randomNumber).caf"
        
         let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
         //SKAction will wait until it`s fully finished before treagering completion
         
         run(swooshSound) {[weak self] in
            self?.isSwooshSoundActive = false
            
        }
    }
    
    // touches Began the first method that occures
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        // we remove things from the screen
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    func redrawActiveSlice () {
        
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12) // for example: 15 - 12 = 3. It will remove frist three items from begin
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1..<activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    func createEnemmy(forceBomb: ForcedBomb = .random) {
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        if forceBomb == .never {
            enemyType = 1  // never be a bomb
        } else if forceBomb == .always {
            enemyType = 0 // always a bomb
        }
        
        
        if enemyType == 0 {
            // bomb code goes here
            enemy = SKSpriteNode() // this will be container for other things inside
            enemy.zPosition = 1 // it appear ahead of other things including pinguins
            enemy.name = "bombContainer"
            
            
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
//            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
//                if let sound = try? AVAudioPlayer(contentsOf: path) {
//                    bombSoundEffect = sound
//                    sound.play()
//                }
//            }
            
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
            
        } else {
            //MARK: Challenge 2.2
            if goldEnemy == 3 {
                enemy = SKSpriteNode(imageNamed: "target_gold")
                run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: true))
                enemy.name = "gold_enemy"
            } else {
                enemy = SKSpriteNode(imageNamed: "penguin")
                run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: true))
                enemy.name = "enemy"
            }
        }
        
        // position code goes here
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)   // -128 - the bottom edge of the screen
        enemy.position = randomPosition
        
        
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int
        
        
        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)   // it moves fast to the right
        } else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)     // it moves to the right gently
        } else if randomPosition.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)    // it moves to the left
        } else {
            randomXVelocity = -Int.random(in: 8...15)  // moves the left very fast
        }
        
        let randomYVelocity = Int.random(in: 24...32)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity  // it will spin in air
        enemy.physicsBody?.collisionBitMask = 0 // bounce off nothing in the game
            
        
            
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    func subtractLife() {
        lives -= 1
//        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        
        var life: SKSpriteNode
        
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeAllActions()
                    
                    //MARK: Challenge 2.3
                    if node.name == "enemy" || node.name == "gold_enemy" {
                        node.name = ""
                        subtractLife()
                        
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                    
                }
            }
        } else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in
                    self?.tossEnemies()
                }
                // we tossed our next sequence here
                nextSequenceQueued = true
            }
        }
        
        
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer" {
               bombCount += 1
               break   // exit that loop
            }
        }
        
        if bombCount == 0 {
            // no bombs - stop the fuse sound!
            
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
        
    }
    
    func tossEnemies() {
        guard isGameEnded == false else { return }
        //MARK: Challenge 2.4
        goldEnemy = Int.random(in: 1...3)
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            createEnemmy(forceBomb: .never)
        case .one:
            createEnemmy()
        case .twoWithOneBomb:
            createEnemmy(forceBomb: .never)
            createEnemmy(forceBomb: .always)
        case .two:
            createEnemmy()
            createEnemmy()
        case .three:
            createEnemmy()
            createEnemmy()
            createEnemmy()
        case .four:
            createEnemmy()
            createEnemmy()
            createEnemmy()
            createEnemmy()
        case .chain:
            createEnemmy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0))
            { [weak self] in self?.createEnemmy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2))
            { [weak self] in self?.createEnemmy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3))
            { [weak self] in self?.createEnemmy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4))
            { [weak self] in self?.createEnemmy() }
            
        case .fastChain:
            createEnemmy()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0))
            { [weak self] in self?.createEnemmy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2))
            { [weak self] in self?.createEnemmy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3))
            { [weak self] in self?.createEnemmy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4))
            { [weak self] in self?.createEnemmy() }
        }
        
        sequencePosition += 1  // next sequence item
        nextSequenceQueued = false
    }
    
}
