//
//  MissileSpriteController.swift
//  Assignment23
//
//  Created by Xcode User on 2018-11-29.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import Foundation

import SpriteKit
import GameplayKit

class MissileSpriteController: SKScene, SKPhysicsContactDelegate {
    
var enemySprites: [SKSpriteNode] = []
    
    
func spawnEnemy(targetSprite: SKNode) -> SKSpriteNode {
    
    // create a new enemy sprite
    let newEnemy = SKSpriteNode(imageNamed:"missileT.png")
    enemySprites.append(newEnemy)
    newEnemy.xScale = 0.08
    newEnemy.yScale = 0.08
    //newEnemy.color = UIColor.red
    //newEnemy.colorBlendFactor=0.4
    
    // position new sprite at a random position on the screen
    let sizeRect = UIScreen.main.bounds
    let posX = arc4random_uniform(UInt32(sizeRect.size.width))
    let posY = arc4random_uniform(UInt32(sizeRect.size.height))
    newEnemy.position = CGPoint(x: CGFloat(posX), y: CGFloat(posY))
    
    // Define Constraints for orientation/targeting behavior
    let i = enemySprites.count-1
    let rangeForOrientation = SKRange(constantValue:CGFloat(M_2_PI*7))
    let orientConstraint = SKConstraint.orient(to: targetSprite, offset: rangeForOrientation)
    let rangeToSprite = SKRange(lowerLimit: 80, upperLimit: 90)
    var distanceConstraint: SKConstraint
    
    // First enemy has to follow spriteToFollow, second enemy has to follow first enemy, ...
    if enemySprites.count-1 == 0 {
        distanceConstraint = SKConstraint.distance(rangeToSprite, to: targetSprite)
    } else {
        distanceConstraint = SKConstraint.distance(rangeToSprite, to: enemySprites[i-1])
    }
    newEnemy.constraints = [orientConstraint, distanceConstraint]
    
    return newEnemy
    }
    
    func shoot(targetSprite: SKNode) {
        for enemy in enemySprites {
        // Create the bullet sprite
        let bullet = SKSpriteNode()
        bullet.color = UIColor.green
        bullet.size = CGSize(width: 10,height: 10)
        bullet.position = CGPoint(x: enemy.position.x, y: enemy.position.y)
        targetSprite.parent?.addChild(bullet)
        
        // Determine vector to targetSprite
        let vector = CGVector(dx: (targetSprite.position.x-enemy.position.x), dy: targetSprite.position.y-enemy.position.y)
        
        // Create the action to move the bullet. Don't forget to remove the bullet!
        let bulletAction = SKAction.sequence([SKAction.repeat(SKAction.move(by: vector, duration: 1), count: 10) ,  SKAction.wait(forDuration: 30.0/60.0), SKAction.removeFromParent()])
        bullet.run(bulletAction)
        }
    }
}
