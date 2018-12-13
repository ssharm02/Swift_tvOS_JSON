//
//  GameScene.swift
//  w5Game
//
//  Created by Jawaad Sheikh on 2016-09-09.
//  Copyright © 2016 Jawaad Sheikh. All rights reserved.
//

import SpriteKit
import GameplayKit

// step 7 - add Physics categories struct
struct PhysicsCategory{
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Baddy : UInt32 = 0b1 // 1
    static let Hero : UInt32 = 0b10 // 2
    // future expansion - dunno if we'll make it here
    static let Projectile : UInt32 = 0b11 // 3
}

// step 6 - add collision detection delegate
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    // step 1 define our sport ninja
    private var sportNode : SKSpriteNode?
    var background = SKSpriteNode(imageNamed: "sky.png")
    var lifeNodes : [SKSpriteNode] = []
    var remainingLifes = 3
    var scoreNode = SKLabelNode()
    
    var score = 0
    override func didMove(to view: SKView) {
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 1.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        
        sportNode = SKSpriteNode(imageNamed: "donkey.png")
        sportNode?.position = CGPoint(x: 30, y: 30)
        
        addChild(sportNode!)

        physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        physicsWorld.contactDelegate = self

        sportNode?.physicsBody = SKPhysicsBody(circleOfRadius: (sportNode?.size.width)!/2)
        sportNode?.physicsBody?.isDynamic = true
        sportNode?.physicsBody?.categoryBitMask = PhysicsCategory.Hero
        sportNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Baddy
        sportNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        sportNode?.physicsBody?.usesPreciseCollisionDetection = true
        

        background.zPosition = -1
        background.size.height = self.size.height
        background.size.width = self.size.width
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(background)

        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addBaddy), SKAction.wait(forDuration: 1.0)])))
        
        createHUD()
    }
    

    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min:CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max-min) + min
    }
    
    func addBaddy(){
        
        let baddy = SKSpriteNode(imageNamed: "fruits.png")
        baddy.size = CGSize(width: 70, height: 70)
        let actualY = random(min: baddy.size.height/2, max: size.height-baddy.size.height/2)
        
        baddy.position = CGPoint(x: size.width + baddy.size.width/2, y:actualY)
        
        addChild(baddy)

        baddy.physicsBody = SKPhysicsBody(rectangleOf: baddy.size)
        baddy.physicsBody?.isDynamic = true
        baddy.physicsBody?.categoryBitMask = PhysicsCategory.Baddy
        baddy.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        baddy.physicsBody?.collisionBitMask = PhysicsCategory.None
        

        let actualDuration = random(min: CGFloat(2.0), max:CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: -baddy.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        baddy.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    

    func blowUpFruits(pos: CGPoint) {
        var emitterNode = SKEmitterNode(fileNamed: "ExplosionX.sks")
        emitterNode?.particlePosition = pos
        self.addChild(emitterNode!)
        // Don't forget to remove the emitter node after the explosion
        self.run(SKAction.wait(forDuration: 2), completion: { emitterNode?.removeFromParent() })
    }
    
    func heroDidCollideWithBaddy(hero: SKSpriteNode, baddy: SKSpriteNode){
        print("hit")
        blowUpFruits(pos: baddy.position)
        // Increase score
        self.score = self.score + 10
        self.scoreNode.text = String(score)
        // need to come up with something
        // maybe have baddy grow?

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.Baddy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Hero != 0)){
            heroDidCollideWithBaddy(hero: firstBody.node as! SKSpriteNode, baddy: secondBody.node as! SKSpriteNode)
        }
    }
    // end step 10
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
            
            // step 5 - now lets move our hero
            let actionMove = SKAction.move(to: pos, duration: TimeInterval(2.0))
            
            let actionMoveDone = SKAction.rotate(byAngle: CGFloat(360.0), duration: 1.0)
            sportNode?.run(SKAction.sequence([actionMove, actionMoveDone]))
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    func createHUD() {
        
        // Create a root node with black background to position and group the HUD elemets
        // HUD size is relative to the screen resolution to handle iPad and iPhone screens
        var hud = SKSpriteNode(color: UIColor.black, size: CGSize(width: self.size.width, height: self.size.height*0.05))
        hud.anchorPoint=CGPoint(x: 0, y: 0)
        hud.position = CGPoint(x: 0, y: self.size.height-hud.size.height)
        self.addChild(hud)
        
        // Display the remaining lifes
        // Add icons to display the remaining lifes
        // Reuse the Spaceship image: Scale and position releative to the HUD size
        let lifeSize = CGSize(width: hud.size.height-10, height: hud.size.height-10)
        
//        for i in 1...self.remainingLifes {
//
//            let tmpNode = SKSpriteNode(imageNamed: "ufo123")
//            lifeNodes.append(tmpNode)
//            tmpNode.size = lifeSize
//            tmpNode.position=CGPoint(x: tmpNode.size.width * 1.3 * (1.0 + CGFloat(i)), y: (hud.size.height-5)/2)
//            hud.addChild(tmpNode)
//        }
        
        // Display the current score
        self.score = 0
        self.scoreNode.position = CGPoint(x: hud.size.width-hud.size.width * 0.1, y: 1)
        self.scoreNode.text = "0"
        self.scoreNode.fontSize = hud.size.height
        hud.addChild(self.scoreNode)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        

    }
}
