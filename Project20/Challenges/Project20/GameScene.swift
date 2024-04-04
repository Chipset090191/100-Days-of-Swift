//
//  GameScene.swift
//  Project20
//
//  Created by Михаил Тихомиров on 28.01.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var scoreLable:SKLabelNode!
    var numOfLaunches = 0
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var score = 0 {
        didSet {
            // MARK: Challenge 1.1
            scoreLable.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
      let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint (x: 512, y: 384)
        background.zPosition = -1
        addChild(background)
        
        // MARK: Challenge 1.2
        scoreLable = SKLabelNode(fontNamed: "Chalkduster")
        scoreLable.position = CGPoint(x: 16, y: 16)
        scoreLable.horizontalAlignmentMode = .left
        addChild(scoreLable)
        
        score = 0

        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }


    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1 // if this option is 0 firework`s color won`t be different. That`s gonna be closer to white Color.
        firework.name = "firework"
        node.addChild(firework)
        
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()                               // this object can draw the path that might be curve or straight or different
        path.move(to: .zero)                                    // we move start point of our path to the zero Point
        path.addLine(to: CGPoint(x: xMovement, y: 1000))        // this is our vector(direction) of movement (it`s calculated in x and y axis)
        
        // then we create an action that moves the node along a path / asOffset - we start where our sprite start (true)
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        
        // then we add this emitter to the node and it may be offseted relatively our node
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    
    }
    
    @objc func launchFireworks () {
        
        // MARK: Challenge 2.1
        numOfLaunches += 1
        if numOfLaunches > 20 {
            gameFinish()
        }
        
        let movementAmount: CGFloat = 1800

        
        switch Int.random(in: 0...3) {
        case 0:
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
        case 2:
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3:
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
        default:
            break // we do nothing
        }
    }
    
    // MARK: Challenge 2.2
    func gameFinish() {
        gameTimer?.invalidate()
        guard let viewController = self.view?.window?.rootViewController else { return }
        
        let ac = UIAlertController(title: "You finished the game!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        viewController.present(ac, animated: true)
        
    }
    
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)   // that means that our touch from the game scene!
        let nodesAtPoint = nodes (at: location)  // to get back a list of all the sprite kit nodes
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }  // then we choose only the node with name "firework"
            
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // we use enumerated().reversed() so as to avoid index out of range.
        // It`s just helps out us to identify right index to be deleted from fireworks
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    
    }
    
    func explode(firework:SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }
        
        
        
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for(index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 200
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
                
        }
    }
    
}
