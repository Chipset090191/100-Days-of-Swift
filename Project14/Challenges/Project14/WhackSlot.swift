//
//  WhackSlot.swift
//  Project14
//
//  Created by Михаил Тихомиров on 01.01.2024.
//

import SpriteKit            // 1 - WhackSlot, 2 - whackHole(SKSpriteNode), 3 - cropNode(SKCropNode) + charNode inside
import UIKit
// we use SKNode because it has sits in our scene at a particular position holding other nodes as children! So we use it as a container for our View!
class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!
    var mudParticles: SKEmitterNode!
    var smokeEmitter: SKEmitterNode!
    var isVisible = false
    var isHit = false
    
    
    func configure(at position: CGPoint) {
        // and here we set our main position for our container and this means that other child Views in our container class SKNode will be attached to this position and be able to have itselves positions as shifts
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        // we set the mask so if our pinguin appears inside the frame of mask we can see it
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        // we`ve added our penguin right inside the cropNode because cropNode only can crop the things inside it!
    
        addChild(cropNode)
    }
    
    // Show method randomly shows Good or Evil Penguin Picture motion
    func show(hideTime: Double) {
        if isVisible { return }
        
        // here we put the scale to the regular one
        charNode.xScale = 1
        charNode.yScale = 1
        
        // MARK: Challenge 3.1
        mudParticles = SKEmitterNode(fileNamed: "mud.sks")
        mudParticles.position = charNode.position
        mudParticles.run(SKAction.moveBy(x: 0, y: 70, duration: 0.01))
        addChild(mudParticles)
        
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.09))
        isVisible = true
        isHit = false
        
        
        
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        // Here we add to main queue execution of hide method after delay again
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    
    func hide() {
        
        if !isVisible { return }
                    
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        
        // MARK: Challenge 3.2
        smokeEmitter = SKEmitterNode(fileNamed: "smoke.sks")
        smokeEmitter.position = charNode.position
        addChild(smokeEmitter)
        
        
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
    }
    
    
    
}
