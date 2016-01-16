//
//  SlimeNode.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 28.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

class SlimeSpriteNode : SKSpriteNode {
    

    let airTexture:SKTexture = SKTexture(imageNamed: "slime_air")
    let groundTexture:SKTexture = SKTexture(imageNamed: "slime_ground")
    var onGround:Bool?
    var oldLocation:CGPoint = CGPointMake(0,0)
    let landSound = SKAction.playSoundFileNamed("land_sound.wav", waitForCompletion: true)
    let jumpSound = SKAction.playSoundFileNamed("jump_sound.wav", waitForCompletion: false)


    convenience init() {
        self.init(imageNamed: "slime_air")
        onGround = true
        
        //self.position = CGPointMake(-100, CGRectGetMidY(self.frame))
        self.name = "slime"
        self.setScale(0.8)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSizeMake(self.size.width * 0.9, self.size.height * 0.9))
        self.physicsBody!.mass = 1
        self.physicsBody!.restitution = 0.55
        self.physicsBody!.friction = 0.2
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.categoryBitMask = SLIME_CATEGORY
        self.physicsBody!.collisionBitMask = SLIME_CATEGORY | EDGE_CATEGORY | GROUND_CATEGORY | WALL_CATEGORY | GOAL_CATEGORY
        self.physicsBody!.contactTestBitMask = GOAL_CATEGORY | GROUND_CATEGORY | WALL_CATEGORY
    }
    
    /**
     Changes the slime texture if on ground / in air
     
     Parameters:
     - onGround: True if slime is on ground
     */
    func isOnGround(onGround:Bool) {
        if onGround {
            self.texture = groundTexture
            
        } else {
            self.texture = airTexture
        }
    }
    
    /**
     Animates bouncing of the slime
     */
    func animateBounce() {
        var textures:[SKTexture] = []

        textures.append(SKTexture(imageNamed: "slime_bounce_1"))
        textures.append(SKTexture(imageNamed: "slime_bounce_2"))
        textures.append(SKTexture(imageNamed: "slime_bounce_3"))
        textures.append(SKTexture(imageNamed: "slime_bounce_2"))
        textures.append(SKTexture(imageNamed: "slime_bounce_1"))
        textures.append(self.airTexture)

        self.name = ""
        
        self.runAction(SKAction.animateWithTextures(textures, timePerFrame: 0.03), completion: {
            
            self.name = "slime"
            
        })
        
        playSound(landSound)

    }
    
    /**
     Plays a sound effect
     
     - Parameters:
     - sound: Desired sound wrapped in a SKAction
     */
    func playSound(sound:SKAction) {
     
        
        if getSoundOption() {
            runAction(sound)
        }
        
    }
}