//
//  LevelFactory.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 29.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

class LevelFactory {
    var parentFrame:CGRect
    let groundLevel = CGFloat(102)
    var factory = ObstacleFactory(scale:300)

    init(parentFrame:CGRect) {
        self.parentFrame = parentFrame
    }
    
    /**
     Creates level 1
     
     - Returns: LevelNode of level 1
     */
    func createLevel1() -> LevelNode{
        
        let level = LevelNode(parentFrame: parentFrame)
        
        level.name = "level1"
        level.highScore = getHighScore(level)
        let holeWall = factory.createHoleWall()
        holeWall.position.x = 0 + parentFrame.width/2
        holeWall.position.y = 0 - parentFrame.height / 2 + groundLevel
        
        
        var movingWallY = CGFloat(-parentFrame.height/2) + groundLevel
        
        
        let movingWall = factory.createVerticalMovingWall(1.5)
        movingWall.position.x = holeWall.position.x + 300
        movingWall.position.y = movingWallY
        
        
        let movingWall2 = factory.createVerticalMovingWall(2)
        
        movingWall2.position.x = movingWall.position.x + 200
        movingWall2.position.y = movingWallY
        
        let movingWall3 = factory.createVerticalMovingWall(2.5)
        movingWall3.position.x = movingWall2.position.x + 200
        movingWall3.position.y = movingWallY
        
        let circleObstacle = factory.createCircleObstacle()
        circleObstacle.position.y = movingWallY
        circleObstacle.position.x = movingWall3.position.x + 350
        
        let goalNode = factory.createGoalPlatform()
        goalNode.position.x = circleObstacle.position.x + 1000 + circleObstacle.frame.size.width
        goalNode.position.y = 0 - parentFrame.height / 2 + groundLevel - goalNode.frame.height / 2
        
        
        //self.addChild(groundSprite1)
        //self.addChild(groundSprite2)
        
        level.addChild(holeWall)
        level.addChild(movingWall)
        level.addChild(movingWall2)
        level.addChild(movingWall3)
        level.addChild(circleObstacle)
        level.addChild(goalNode)
        
        return level
    }
    
    /**
     Creates level 2
     
     - Returns: LevelNode of level 2
     */
    func createLevel2() -> LevelNode{
        let level = LevelNode(parentFrame: parentFrame)
        level.setParallax("mountain_ice_front", image2: "mountain_ice_mid", image3: "mountain_ice_back")
        level.name = "level2"
        level.highScore = getHighScore(level)

        let icePlatform = factory.createIcePlatform()
        icePlatform.position = CGPointMake(500 + icePlatform.frame.width / 2, 0 - parentFrame.height / 2 + groundLevel - icePlatform.frame.height)
        level.addChild(icePlatform)
        
        let lPiece = factory.createLWall()
        lPiece.position = CGPointMake(icePlatform.position.x + icePlatform.frame.width / 2, -parentFrame.height / 2 + groundLevel)
        level.addChild(lPiece)
        
        let airPlatforms = factory.createAirPlatforms()
        airPlatforms.position = icePlatform.position
        level.addChild(airPlatforms)
        
        let bounceWall = factory.createBounceWall()
        bounceWall.position = CGPointMake(lPiece.position.x + 800,0)
        level.addChild(bounceWall)
        
        let goalNode = factory.createGoalPlatform()
        goalNode.position.x = bounceWall.position.x + 800
        goalNode.position.y = -parentFrame.height / 2 + goalNode.frame.height * 1.2
        level.addChild(goalNode)
        
        return level

        
    }
    
    /**
     Creates level 3
     
     - Returns: LevelNode of level 3
     */
    func createLevel3() -> LevelNode {
        let level = LevelNode(parentFrame: parentFrame)
        level.setParallax("mountain_sand_front", image2: "mountain_sand_mid", image3: "mountain_sand_back")

        var bunkerList:[SKShapeNode]
        bunkerList = []
        level.name = "level3"
        level.highScore = getHighScore(level)

        for var i = 0; i < 5; i++ {
            let bunker = factory.createBunker(230)
            bunker.position = CGPointMake(200 + 580 * CGFloat(i) + bunker.frame.width / 2, 0 - parentFrame.height / 2 + groundLevel - bunker.frame.height)
            bunkerList.append(bunker)
            level.addChild(bunker)

        }
        

        
        let circles = factory.createBigCircles()
        circles.position.x = bunkerList[0].position.x
        
        let house = factory.createHouse()
        house.position.x = bunkerList[bunkerList.count - 1].position.x + 600
        //house.position.x = 75
        house.position.y = 0 - parentFrame.height / 2 + groundLevel - bunkerList[bunkerList.count - 1].frame.height
        
        
        let goalNode = factory.createGoalPlatform()
        goalNode.position.x = house.position.x + 800
        goalNode.position.y = -parentFrame.height / 2 + goalNode.frame.height * 1.2
        
        level.addChild(goalNode)
        level.addChild(circles)
        level.addChild(house)
        
        
        return level
    }
    
    func calibrateLevel() -> LevelNode {
        return  LevelNode(parentFrame: parentFrame)
    }
    
}