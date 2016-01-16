//
//  WorldNode.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 5.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

//var currentLevel:LevelClass?
//var levelList:[LevelClass]?
//var background:String?


class WorldNode:SKNode {
    var backgroundSkyNode = SKSpriteNode(imageNamed: "background_sky")
    var groundSprite1 = SKSpriteNode(imageNamed: "ground")
    var groundSprite2 = SKSpriteNode(imageNamed: "ground")
    var parallaxBackgroundNode:ParallaxBackgroundNode!
    var parentFrame:CGRect!
    let GROUND_WIDTH:CGFloat = 4096
    var groundLevel:CGFloat?
    var goalPlatform:SKShapeNode?
    var currentLevel:LevelNode?
    
     init(frame:CGRect) {
        super.init()
        
        self.parentFrame = frame
        self.name = "world"
                
        groundLevel = groundSprite1.size.height
        //groundSprite1.position = CGPointMake(CGRectGetMidX(self.frame), -self.frame.height/2 + groundSprite1.frame.height/2)
        //groundSprite1.size.width = self.frame.width
        //world!.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        //world!.physicsBody?.categoryBitMask = EDGE_CATEGORY
        
        //groundSprite2.position = CGPointMake(CGRectGetMidX(self.frame) + self.frame.width, -self.frame.height/2 + groundSprite2.frame.height/2)
        //groundSprite2.size.width = self.frame.width
  
    }
    
    override convenience init() {
        self.init()
        
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    /**
       Initializes the selected level
     
     - Parameters:
     - level: LevelNode of the desired level
     */
    func initLevel(level:LevelNode) {
        self.currentLevel = level
        self.groundSprite1 = level.groundSprite1
        self.groundSprite2 = level.groundSprite2
        self.backgroundSkyNode = level.backgroundSkyNode
        
        backgroundSkyNode.position = CGPointMake(CGRectGetMidX(self.parentFrame), CGRectGetMidY(self.parentFrame))
        backgroundSkyNode.size = CGSizeMake(self.parentFrame.width * 8, self.parentFrame.height * 4)
        backgroundSkyNode.zPosition = -1
        //self.addChild(parallaxBackgroundNode)
        level.position = CGPointMake(0, 0)
        
        //self.addChild(backgroundSkyNode)
        self.addChild(level)
        
    }
    

}