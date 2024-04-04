//
//  GameScene.swift
//  Project17
//
//  Created by Михаил Тихомиров on 13.01.2024.
//

import SpriteKit
import UIKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    // MARK: Challenge 3.1
    var enemies:[SKSpriteNode] = []
    var scoreLabel:SKLabelNode!
    var possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    var touchesEnded = false
    var enemiesCount = 0
    var timeParam = 0.0
    var timer:Timer?
    
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // MARK: Challenge 2.1
    var gameTimer: Timer? {
        Timer.scheduledTimer(timeInterval: 1 - timeParam, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }

    override func didMove(to view: SKView) {
        
        backgroundColor = .black
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        // MARK: Challenge 3.2
        newGame(action: nil)
        
        physicsWorld.gravity = .zero                    // as we are in space the gravity is zero
        
        physicsWorld.contactDelegate = self             // tells us when contact happens
        
    }
    
    
    // MARK: Challenge 3.3
    func newGame(action: UIAlertAction!) {
        // MARK: Challenge 2.2
         timer = gameTimer
         isGameOver = false
         score = 0
         touchesEnded = false
         timeParam = 0.0
        
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)           // we set it starts from our right edge
        starfield.advanceSimulationTime(10) // here we start our simulation 10 seconds earlier
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size) // we draw it around the player texture to set physics
        player.physicsBody?.contactTestBitMask = 1 //a mask defines which categories of physics bodies cause intersection notifications with this physics body.

        addChild(player)
        
    }
    
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        // MARK: Challenge 2.3
        enemiesCount += 1
        if enemiesCount > 20 {
            if timeParam != 0.9 {
                timer?.invalidate()
                timeParam += 0.1
                timer = gameTimer
            }
            enemiesCount = 0
        }
        
        
        let spriteEnemy = SKSpriteNode(imageNamed: enemy)
        spriteEnemy.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(spriteEnemy)
        // MARK: Challenge 3.4
        enemies.append(spriteEnemy)
        
        
        spriteEnemy.physicsBody = SKPhysicsBody(texture: spriteEnemy.texture!, size: spriteEnemy.size)
        spriteEnemy.physicsBody?.categoryBitMask = 1  // we put our new created enemy to first category of bitMask.
        spriteEnemy.physicsBody?.velocity = CGVector(dx: -500, dy: 0) // so we push it very hard to the left side
        spriteEnemy.physicsBody?.angularVelocity = 5 // so it`ll spin through the air as it`s moving
        spriteEnemy.physicsBody?.linearDamping = 0   // controls how fast things slow down over time / it `ll never slow down
        spriteEnemy.physicsBody?.angularDamping = 0  // never stops spinning
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        // MARK: Challenge 1.2
        if touchesEnded == false {
            player.position = location
        }
    }
    
    // MARK: Challenge 1.1
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded = true
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        player.removeFromParent()
        // MARK: Challenge 3.5
        removeEnemies()
        
        isGameOver = true
        timer?.invalidate()
        starfield.removeFromParent()
        
        showAlert()
        
    }
    // MARK: Challenge 3.6
    func showAlert () {
        if let viewController = self.view?.window?.rootViewController {
            let ac = UIAlertController(title: "Game is over!", message: "Start again?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: newGame))
            viewController.present(ac, animated: true)
        }
    }
    
    // MARK: Challenge 3.7
    func removeEnemies() {
            for enemy in enemies {
                enemy.removeFromParent()
            }
            enemies.removeAll(keepingCapacity: false)
        }
}
