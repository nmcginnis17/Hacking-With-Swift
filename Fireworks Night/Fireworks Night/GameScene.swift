//
//  GameScene.swift
//  Fireworks Night
//
//  Created by Nicholas McGinnis on 10/23/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func creatFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        case 2:
            firework.color = .red
        default:
            break
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            creatFirework(xMovement: 0, x: 512, y: bottomEdge)
            creatFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            creatFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            creatFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            creatFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            creatFirework(xMovement: 0, x: 512, y: bottomEdge)
            creatFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            creatFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            creatFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            creatFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
        case 2:
            creatFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            creatFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            creatFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            creatFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            creatFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3:
            creatFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            creatFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            creatFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            creatFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            creatFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
        default:
            break
        }
    }
    
}
