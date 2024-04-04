//
//  GameScene.swift
//  Project26
//
//  Created by Михаил Тихомиров on 03.03.2024.
//

import SpriteKit
import CoreMotion

// In level document
// x - the wall
// v - vortex, deadly for players
// s - star, awarding points to the player
// f - level finish

// this reversed order of the level!
//0 xxxxxxxxxxxxxxxx
//1 x              x
//2 x vvvvvvvvvvvvfx
//3 x          svxxx
//4 xxx xxxxxxvs   x
//5 xvxsxxxxxxxxxv x
//6 xsxvxs      xv x
//7 x xxx xxxxx    x
//8 x         x vv x
//9 x xxxxxx vx vv x
//10 x xs      xs  sx
//11 xxxxxxxxxxxxxxxx

enum CollisionTypes: UInt32{
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
    case exit = 64
}

class GameScene: SKScene, SKPhysicsContactDelegate {
  
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager:CMMotionManager?
    var isGameOver = false
    
    var scoreLabel:SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let defaultPlayerPosition = CGPoint(x: 96, y: 672)
    
    // MARK: Challenge 2.1
    var level = 1
    var exitPositions = [CGPoint] ()
    
    
    override func didMove(to view: SKView) {
        let background  = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.name = "background"
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        
        
        
        loadlevel()
        
        
        createPlayer(with: defaultPlayerPosition)
        
        physicsWorld.gravity = .zero // no gravity
        physicsWorld.contactDelegate = self // tell us when the collision happen
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()  // at this point we start getting the data
    }
    
    func loadlevel() {
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level1.txt in the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        // reverse matters so we read from the bottom to the top because the inverted Y-axis
        
        
        for(row, line) in lines.reversed().enumerated()
            // here for examp. for row = 1 in reverse order we`ve got line "x              x"
        {
            
            for (column, letter) in line.enumerated() {
                // here for examp. after line.enumerated we`ve got every letter of line as an element of array
                // arry = ["x"," "," "," "," "," "," "," "," "," "," "," "," "," "," ","x"]
                
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)  // +32 for centering
                
                // MARK: then below is Challenge 1.1
                
                if letter == "x" {
                    //load wall
                    wallNode(with: position)
                } else if letter == "v" {
                    //load vortex
                    vartexNode(with: position)
                } else if letter == "s" {
                    //star
                    starNode(with: position)
                } else if letter == "f" {
                    //finish
                    finishNode(with: position)
                }else if letter == " " {
                       // this is an empty space do thing
                }else if letter == "t" {
                    teleportNode(with: position)
                }else if letter == "e" {
                    exitNode(with: position)
                }else {
                    fatalError("Unknown level letter: \(letter)")
                }
                // by default physics bodies have a CollisionBitMask that means everything bounce off everything else
                // by default contactTestBitMask that means nothing so you will never get told about collisions
            }

        }
        
    }
    
    func teleportNode(with position:CGPoint) {
        let teleport = SKEmitterNode(fileNamed: "teleport")!
        teleport.position = position
        teleport.targetNode = self
        teleport.name = "teleport"
        teleport.physicsBody?.isDynamic = false
        teleport.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        teleport.physicsBody?.affectedByGravity = false
        teleport.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        teleport.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        teleport.physicsBody?.collisionBitMask = 0
        
        addChild(teleport)
    }
    
    
    func exitNode(with position:CGPoint) {
        // exit point of teleport
        let node = SKSpriteNode(imageNamed: "exit")
        node.position = position
        exitPositions.append(position)
        addChild(node)
    }
    
    
    func wallNode(with position: CGPoint) {
        //load wall
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue // we extract the value by using rawValue
        node.physicsBody?.isDynamic = false // we turn off physics actions for this node
        addChild(node)
    }
    
    func vartexNode(with position: CGPoint) {
        // load vortex
           let node = SKSpriteNode(imageNamed: "vortex")
           node.name = "vortex"
           node.position = position
           node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
           node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
           node.physicsBody?.isDynamic = false
           
           node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
           node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue // when it touches the player we want to be told about it
           node.physicsBody?.collisionBitMask = 0  // it bounce off nothing
           addChild(node)
    }
    
    
    func starNode(with position: CGPoint) {
        // star
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    
    func finishNode(with position: CGPoint) {
        // load finish point
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func createPlayer(with position: CGPoint) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: position.x, y: position.y)
        // by the way if we skip setting zposition it`s gonna be = 0 by default
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.teleport.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
        
    }
    
   
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
//        physicsWorld.gravity = .zero
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        
        
        #if targetEnvironment(simulator)  // the code in the first block will be compiled only on the simulator
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        // real device code
        if let accelerometerData = motionManager?.accelerometerData {
            // and the code we`re gonna run will create a CGVector from the tilt info (how much x and y we have) and use that for our phys.world gravity
            
            // we flips data for dx and dy because we are using landscape mode
            // we also amplify data from accelerometer by 50
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    // called when two bodies contact each other
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
    
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false  // stop this thing from rolling around
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25) // we suck our ball to vortex with this action!
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move,scale,remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer(with: self!.defaultPlayerPosition)
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "teleport" {
            player.physicsBody?.isDynamic = false
            
            
            let move = SKAction.move(to: node.position, duration: 0.25) // we suck our ball to vortex with this action!
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move,scale,remove])
            
            
            player.run(sequence) { [weak self] in
//                self?.movePlayer
                self?.createPlayer(with: self!.exitPositions.shuffled().first!)
                
            }
            
        } else if node.name == "finish" {
            // MARK: Challenge 2.2
            // go to next level
            guard level <= 3 else { return }
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score = 0
            level += 1
            exitPositions.removeAll(keepingCapacity: false)
            
            let move = SKAction.move(to: node.position, duration: 0.25) // we suck our ball to vortex with this action!
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move,scale,remove])
            
            player.run(sequence) { [weak self] in
                self?.clearSurfface()
                self?.createPlayer(with: self!.defaultPlayerPosition)
                self?.loadlevel()
                self?.isGameOver = false
            }
            
        }
    }
    // MARK: Challenge 2.3
    func clearSurfface() {
        for node in children {
            if node.name != "background" && node != scoreLabel {
                node.removeFromParent()
            }
        }
    }
    
}
