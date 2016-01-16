//
//  LevelNode.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 29.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

class LevelNode:SKNode {
    var par:Int
    var backgroundSkyNode = SKSpriteNode(imageNamed: "background_sky")
    var groundSprite1 = SKSpriteNode(imageNamed: "ground")
    var groundSprite2 = SKSpriteNode(imageNamed: "ground")
    let GROUND_WIDTH:CGFloat = 4096
    var parallaxBackground:ParallaxBackgroundNode!
    var highScore:Int
    
    
    init(parentFrame:CGRect) {
        self.par = 0
        self.highScore = -1
        super.init()
        groundSprite1.physicsBody = SKPhysicsBody(texture: groundSprite1.texture!, size: CGSizeMake(GROUND_WIDTH, groundSprite1.frame.height/2))
        groundSprite1.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        groundSprite1.physicsBody?.categoryBitMask = GROUND_CATEGORY
        groundSprite1.physicsBody?.dynamic = false
        groundSprite1.name = "ground"
        
        parallaxBackground = ParallaxBackgroundNode()
        
        groundSprite2.physicsBody = SKPhysicsBody(texture: groundSprite2.texture!, size: CGSizeMake(GROUND_WIDTH, groundSprite2.frame.height/2))
        groundSprite2.physicsBody?.categoryBitMask = GROUND_CATEGORY
        groundSprite2.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        
        groundSprite2.physicsBody?.dynamic = false
        groundSprite2.name = "ground"
        
        groundSprite1.position = CGPointMake(CGRectGetMidX(parentFrame), -parentFrame.height/2 + groundSprite1.frame.height/2)
        groundSprite1.size.width = GROUND_WIDTH
        
        groundSprite2.position = CGPointMake(CGRectGetMidX(parentFrame) + groundSprite1.frame.width, -parentFrame.height/2 + groundSprite2.frame.height/2)
        groundSprite2.size.width = GROUND_WIDTH
        
        self.addChild(groundSprite1)
        self.addChild(groundSprite2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Sets the graphics for parallax background of the level
     
     - Parameters:
     - image1: Front image
     - image2: Middle image
     - image3: Back image

     */
    func setParallax(image1:String, image2:String, image3:String) {
        var front = SKSpriteNode(imageNamed: image1)
        var mid = SKSpriteNode(imageNamed: image2)
        var back = SKSpriteNode(imageNamed: image3)
        
        self.parallaxBackground = ParallaxBackgroundNode(backgroundFront: front, backgroundMid: mid, backgroundBack: back)
    }
    

}