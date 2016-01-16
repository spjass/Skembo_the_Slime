//
//  ParallaxBackgroundNode.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 10.12.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

class ParallaxBackgroundNode:SKNode {
    var backgroundFront, backgroundMid, backgroundBack : SKSpriteNode!
    var origin:CGPoint!
    var frontPos  = CGPointMake(0.0,0.0), midPos  = CGPointMake(0.0,0.0), backPos = CGPointMake(0.0,0.0)
    let CAMERA_WIDTH = CGFloat(768)
    
    
    init(backgroundFront:SKSpriteNode, backgroundMid:SKSpriteNode, backgroundBack:SKSpriteNode) {
        super.init()
        self.backgroundBack = backgroundBack
        self.backgroundMid = backgroundMid
        self.backgroundFront = backgroundFront
        
        self.backgroundFront.setScale(3.0)
        self.backgroundMid.setScale(3.0)
        self.backgroundBack.setScale(3.0)
        
        self.backgroundFront.alpha = 1
        self.backgroundMid.alpha = 0.95
        self.backgroundBack.alpha = 1
        
        self.backgroundMid.position.x = self.backgroundFront.position.x + 100
        self.backgroundBack.position.x = self.backgroundFront.position.x + 550
        
        self.backgroundBack.position.y =  -250
        
        SKBlendMode.init(rawValue: 50000)
        self.backgroundBack.colorBlendFactor = 0.5
        self.backgroundBack.color = SKColor.brownColor()
        
        frontPos = CGPointMake(650.0,0.0)
        midPos = CGPointMake(400, 0.0)
        backPos = CGPointMake(150, 0.0)
        
        self.addChild(self.backgroundBack)
        self.addChild(self.backgroundMid)
        self.addChild(self.backgroundFront)
        
        origin = CGPointMake(0.0,0.0)
        
    }
    
    convenience override init() {
        var front = SKSpriteNode(imageNamed: "mountain_green_front")
        var mid = SKSpriteNode(imageNamed: "mountain_green_mid")
        var back = SKSpriteNode(imageNamed: "mountain_green_back")

        self.init(backgroundFront: front, backgroundMid: mid, backgroundBack: back)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Sets the origin position
     
     - Parameters:
     - position: Origin CGPoint position

     */
    func setOrigin(position:CGPoint) {
        self.origin = position
        
    }
    
    /**
     Updates positions of all layers of the background
     
     - Parameters:
     - cameraNode: Camera node of the game
     */
    func updatePositions(cameraNode:SKNode) {
        var frontOffsetX, frontOffsetY, midOffsetX, midOffsetY, backOffsetX, backOffsetY:CGFloat
        var playerPosition = cameraNode.position
        var offsetX = playerPosition.x - origin.x
        var offsetY = playerPosition.y - origin.y
        
        if playerPosition.x > frontPos.x +  CAMERA_WIDTH * 2  {

            frontPos.x = frontPos.x + CAMERA_WIDTH * 5
        } else if playerPosition.x < frontPos.x - CAMERA_WIDTH * 2 {
            frontPos.x = frontPos.x - CAMERA_WIDTH * 5
        }
        
        frontOffsetX = offsetX / 1 - frontPos.x
        frontOffsetY = offsetY / 1 - frontPos.y

        
        if playerPosition.x / 3 > midPos.x +  CAMERA_WIDTH * (3/2)   {
            midPos.x = midPos.x + CAMERA_WIDTH * (1 + 3/2)
        } else if playerPosition.x / 3 < midPos.x - CAMERA_WIDTH * (3/2)  {
            midPos.x = midPos.x - CAMERA_WIDTH * (1 + 3/2)
            
        }
        
        midOffsetX = offsetX / 3 - midPos.x
        midOffsetY = offsetY / 2 - midPos.y

        if playerPosition.x / 6 > backPos.x +  CAMERA_WIDTH   {
            backPos.x = backPos.x + CAMERA_WIDTH * 2
        } else if playerPosition.x / 6 < backPos.x - CAMERA_WIDTH * 2  {
            backPos.x = backPos.x - CAMERA_WIDTH * 2.5
            
        }
        
        backOffsetX = offsetX / 6 - backPos.x
        backOffsetY = offsetY / 4 - backPos.y
        
        if frontOffsetX > frontPos.x + backgroundFront.frame.width + 500 {
            
        } else if frontOffsetX < frontPos.x - backgroundFront.frame.width - 500 {
            
        }
        
        var moveFrontAction = SKAction.moveTo(CGPointMake(-frontOffsetX, -frontOffsetY), duration: 0)
        var moveMidAction = SKAction.moveTo(CGPointMake(-midOffsetX, -midOffsetY), duration: 0)
        var moveBackAction = SKAction.moveTo(CGPointMake(-backOffsetX, -backOffsetY), duration:0)
        
        self.backgroundFront.runAction(moveFrontAction)
        self.backgroundMid.runAction(moveMidAction)
        self.backgroundBack.runAction(moveBackAction)
        
    }
}
