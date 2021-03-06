//
//  FlappyScene.swift
//  Flappy Bird
//
//  Created by Jesse Tipton on 11/3/16.
//  Copyright © 2016 MAD. All rights reserved.
//

import SpriteKit

extension SKColor {
    
    static func flappyBirdSkyColor() -> SKColor {
        let red: CGFloat = 113.0 / 255.0
        let green: CGFloat = 197.0 / 255.0
        let blue: CGFloat = 207.0 / 255.0
        let alpha: CGFloat = 1.0
        return SKColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
    
}

class FlappyScene: SKScene {

    var birdNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        // MARK: Bird setup
        
        let birdTexture1 = SKTexture(imageNamed: "Bird1")
        birdTexture1.filteringMode = .nearest
        
        let birdTexture2 = SKTexture(imageNamed: "Bird2")
        birdTexture2.filteringMode = .nearest
        
        let flapAction = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.2)
        let flapForeverAction = SKAction.repeatForever(flapAction)
        
        birdNode = SKSpriteNode(texture: birdTexture1)
        birdNode.setScale(2)
        
        birdNode.position = self.frame.center
        
        birdNode.run(flapForeverAction)
        
        birdNode.physicsBody = SKPhysicsBody(texture: birdTexture1, size: birdNode.size)
        birdNode.physicsBody?.isDynamic = true
        birdNode.physicsBody?.allowsRotation = false
        
        self.addChild(birdNode)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        self.backgroundColor = SKColor.flappyBirdSkyColor()
        
        let spawnPipesAction = SKAction.perform(#selector(pipeItUp), onTarget: self)
        let delayAction = SKAction.wait(forDuration: 3)
        let spawnPipesAndWaitAction = SKAction.sequence([spawnPipesAction, delayAction])
        let spawnPipesForever = SKAction.repeatForever(spawnPipesAndWaitAction)
        self.run(spawnPipesForever)
    }
    
    func pipeItUp() {
        let bottomPipeTexture = SKTexture(imageNamed: "PipeBottom")
        bottomPipeTexture.filteringMode = .nearest
        
        let topPipeTexture = SKTexture(imageNamed: "PipeTop")
        topPipeTexture.filteringMode = .nearest
        
        let bottomPipeNode = SKSpriteNode(texture: bottomPipeTexture)
        bottomPipeNode.setScale(2)
        
        bottomPipeNode.physicsBody = SKPhysicsBody(texture: bottomPipeTexture, size: bottomPipeNode.size)
        bottomPipeNode.physicsBody?.isDynamic = false
        
        let topPipeNode = SKSpriteNode(texture: topPipeTexture)
        topPipeNode.setScale(2)
        
        topPipeNode.physicsBody = SKPhysicsBody(texture: topPipeTexture, size: topPipeNode.size)
        topPipeNode.physicsBody?.isDynamic = false
        
        let pipePair = SKNode()
        pipePair.addChild(bottomPipeNode)
        pipePair.addChild(topPipeNode)
        
        let pipeY = Int(arc4random()) % Int(frame.size.height / 3)
        
        bottomPipeNode.position = CGPoint(x: 0, y: pipeY)
        topPipeNode.position = CGPoint(x: 0, y: bottomPipeNode.size.height + CGFloat(pipeY) + 150)
        
        pipePair.position = CGPoint(x: self.frame.size.width + bottomPipeTexture.size().width, y: 0)
        pipePair.zPosition = -1
        
        let movePipesAction = SKAction.moveBy(x: -1, y: 0, duration: 0.01)
        let movePipesForeverAction = SKAction.repeatForever(movePipesAction)
        pipePair.run(movePipesForeverAction)
        
        self.addChild(pipePair)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        birdNode.physicsBody?.velocity = CGVector.zero
        birdNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
    }
    
}


























