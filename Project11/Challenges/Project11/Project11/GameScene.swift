//
//  GameScene.swift
//  Project11
//
//  Created by Михаил Тихомиров on 15.12.2023.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel:SKLabelNode!
    
    var limit = 5
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)  // we put our background at the midle of the screen
        background.blendMode = .replace   // we used it, which is faster because it ignores transparency
        background.zPosition = -1           // we set our background being behind other nodes in scene!
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
       
        
        
        // by doing that our box is gonna interact physically with a frame of our screen and with a frame itself!
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  // + phisicsBody for all scene (+ box.physicsBody)
        physicsWorld.contactDelegate = self
        
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        

        
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return } // find that first touch
        let location = touch.location(in: self)  // find where that touch`s been in the whole game scene
        
        let objects = nodes(at: location)  // how many nodes exist in our locatioon on our scene
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                
                // creating the box here
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), 
                                                      green: CGFloat.random(in: 0...1),
                                                      blue: CGFloat.random(in: 0...1), 
                                                      alpha: 1),
                                       size: size)
                box.zRotation = CGFloat.random(in: 0...3)  // rotate it a random number of radians
                box.position = location // we places boxes where we`ve tapped
                box.name = "box"
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false // it can not move
                addChild(box)
                
                
            } else {
                if location.y >= 612 {
                    
                    // MARK: Challenge 1.1
                    let ball = SKSpriteNode(imageNamed: String(Int.random(in: 1...7)))
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.restitution = 0.4 // the bounciness of body (bounce effect)
                    // contactTestBitMask - which collisions do you want to know about
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0 // collisionBitMask - we can bounce from everything by default
                    
                    ball.position = location
                    ball.name = "ball"
                    addChild(ball)
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        // bouncer
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false // this object stays frozen
        addChild(bouncer)
    }

    func makeSlot(at position: CGPoint, isGood: Bool) {
    
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotGlow)  // the star
        addChild(slotBase)  // the green or red bar
        
        // adding the spin
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)  // is being spinned by angle pi within 10 seconds
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
    }
    // SKNode is a parent class of SKSpriteNode
    func collision(between ball: SKNode, object: SKNode) {
//        if object.name == "good" {
//            destroy(ball: ball)
//            score += 1
//        } else if object.name == "bad" {
//            destroy(ball: ball)
//            score -= 1
//        }
        
        
        switch object.name {
        case "good":
            destroy(ball: ball)
            score += 1
        case "bad":
            destroy(ball: ball)
            score -= 1
        case "box":
            limit -= 1
            if limit == 0 {
                destroyBox(box: object)
                limit = 5
            }
        default:
            return
        }
        
    }
    
    // we destroy the ball here
    func destroy(ball: SKNode) {
        
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    
    func destroyBox(box:SKNode) {
        box.removeFromParent()
        
//        if nodeA.name == "box" {
//            limit -= 1
//            if limit == 0 {
//                nodeA.removeFromParent()
//                limit = 5
//            }
//        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // to make safier our code because either bodyB or bodyA may not nave existed at the rare cases after collision!
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        

        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
            
        }
    }
    

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
