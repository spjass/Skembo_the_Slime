//
//  ObstacleFactory.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 23.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

class ObstacleFactory {
    
    var scale:CGFloat
    var width:  CGFloat
    var height:CGFloat
    let LARGE_WIDTH:CGFloat = 80.0
    let MEDIUM_WIDTH:CGFloat = (80.0*(2/3))
    let SMALL_WIDTH:CGFloat = (80.0/2)
    
    init(scale:CGFloat) {
        self.scale = scale
        width =  CGFloat(LARGE_WIDTH)
        height = CGFloat(470/3)
    }
    
    /**
     Creates an obstacle containing two vertical walls with a hole in between

     
     - Returns: Node of the created obstacle
     */
    func createHoleWall() -> SKNode {
        var obstacle = SKNode()
        
        var wall1 = SKShapeNode(rectOfSize: CGSizeMake(width,height))
        wall1.fillColor = SKColor.whiteColor()
        wall1.setTiledFillTexture("brick_texture", tileSize: CGSizeMake(64,64))
        wall1.position = CGPointMake(0,0)
        
        var wall2 = SKShapeNode(rectOfSize: CGSizeMake(width,height * 2))
        wall2.fillColor = SKColor.whiteColor()
        wall2.setTiledFillTexture("brick_texture", tileSize: CGSizeMake(64,64))

        wall2.position = wall1.position
        wall2.position.y = wall1.frame.height + (83*2)
        
        obstacle.addChild(wall1)
        obstacle.addChild(wall2)
        
        wall1.physicsBody = SKPhysicsBody(rectangleOfSize: wall1.frame.size)
        wall2.physicsBody = SKPhysicsBody(rectangleOfSize: wall2.frame.size)
        wall1.physicsBody?.dynamic = false
        wall2.physicsBody?.dynamic = false
        wall1.physicsBody?.categoryBitMask = WALL_CATEGORY
        wall2.physicsBody?.categoryBitMask = WALL_CATEGORY
        wall1.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        wall2.physicsBody?.contactTestBitMask = SLIME_CATEGORY

        
        return obstacle
    }
    
    /**
     Creates a moving wall obstacle
     
     - Parameters:
     - moveDuration: The duration for the wall to move up and down
     
     - Returns: Node of the created obstacle
     */
    func createVerticalMovingWall(moveDuration:Double) -> SKNode {
        
        let obstacle = SKNode()
        obstacle.name = "vertical_moving_wall"
        
        
        height = CGFloat(90)
        
        let wall = SKShapeNode(rectOfSize: CGSizeMake(width,height))
        wall.fillColor = SKColor.whiteColor()
        wall.setTiledFillTexture("brick_texture", tileSize: CGSizeMake(64,64))

        wall.physicsBody = SKPhysicsBody(rectangleOfSize: wall.frame.size)
        wall.physicsBody?.categoryBitMask = WALL_CATEGORY
        wall.physicsBody?.contactTestBitMask = SLIME_CATEGORY

        wall.physicsBody?.dynamic = false
        
        let minY = CGFloat(0)
        let maxY = minY + 60
        
        
        wall.position.y = 26
        var duration2 = moveDuration
        var moveDown = SKAction.moveToY(minY, duration: moveDuration)
        var moveUp = SKAction.moveToY(maxY, duration: moveDuration)
        
        let sequence = SKAction.sequence([moveUp,moveDown])
        
        wall.runAction(SKAction.repeatActionForever(sequence))
        obstacle.addChild(wall)
        return obstacle
    }
    
    /**
     Creates an node containing 7 small circle obstacles
     
     - Returns: Node of the obstacle
     */
    func createCircleObstacle() -> SKNode {
        let obstacle = SKNode()
        obstacle.name = "circle_obstacle"
        
        for (var i:Int = 0; i < 7; i++) {
            var circle = SKShapeNode(ellipseOfSize: CGSizeMake(110,110))
            circle.fillColor = SKColor.whiteColor()
            circle.setTiledFillTexture("brick_texture", tileSize: CGSizeMake(64,64))

            circle.position.x = CGFloat(i) * CGFloat(110)
            circle.position.y = 150
            
            if (i % 2 == 0) {
                circle.position.y = 100/3
            } else if (i % 3 == 0) {
                circle.position.y = 250/3
            } else if i % 5 == 0 {
                circle.position.y = 190/3
            } else {
                circle.position.y = 275/3
            }
            circle.physicsBody = SKPhysicsBody(circleOfRadius: 55)
            circle.physicsBody!.dynamic = false
            circle.physicsBody!.categoryBitMask = WALL_CATEGORY
            circle.physicsBody?.contactTestBitMask = SLIME_CATEGORY

            
            obstacle.addChild(circle)
        }
        
        return obstacle
    }
    
    /**
     Crates a goal platform

     - Returns: SKShapeNode of the goal
     */
    func createGoalPlatform() -> SKShapeNode {
        let size = CGSizeMake(LARGE_WIDTH*2,SMALL_WIDTH)
        
        var goalNode = SKShapeNode(rectOfSize: size)
        
        goalNode.fillColor = SKColor.greenColor()
        goalNode.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        goalNode.physicsBody!.dynamic = false
        goalNode.physicsBody!.categoryBitMask = GOAL_CATEGORY
        goalNode.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        goalNode.name = "GOAL"
        
        let goalLabel = SKLabelNode(fontNamed: "Arial")
        
        goalLabel.fontSize = 20
        goalLabel.text = "GOAL"
        goalLabel.fontColor = SKColor.redColor()
        goalLabel.position = CGPointMake(CGRectGetMidX(goalNode.frame), CGRectGetMidY(goalNode.frame))
        
        goalNode.addChild(goalLabel)
        
        return goalNode
    }
    
    /**
     Creates a slippery platform with ice texture

     - Returns: SKShapeNode of the ice platform
     */
    func createIcePlatform() -> SKShapeNode {
        let size = CGSizeMake(LARGE_WIDTH*32, SMALL_WIDTH)
        var iceNode = SKShapeNode(rectOfSize: size)
        
        iceNode.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        iceNode.physicsBody?.dynamic = false
        iceNode.physicsBody?.categoryBitMask = WALL_CATEGORY
        iceNode.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        iceNode.physicsBody?.friction = 0.008
        iceNode.fillColor = SKColor.whiteColor()
        iceNode.setTiledFillTexture("ice_texture", tileSize: CGSizeMake(64,iceNode.frame.height))

        iceNode.name = "ICE"
        
        return iceNode
    }
    
    /**
     Creates big L-shaped wall

     - Returns: Node of the obstacle
     */
    func createLWall() -> SKNode {
        let size1 = CGSizeMake(SMALL_WIDTH, LARGE_WIDTH * 10)
        let size2 = CGSizeMake(LARGE_WIDTH * 9, SMALL_WIDTH)
        let obstacle = SKNode()
        
        var wall1 = SKShapeNode(rectOfSize: size1)
        var wall2 = SKShapeNode(rectOfSize: size2)
        
        wall1.physicsBody = SKPhysicsBody(rectangleOfSize: size1)
        wall2.physicsBody = SKPhysicsBody(rectangleOfSize: size2)
        wall1.physicsBody?.dynamic = false
        wall2.physicsBody?.dynamic = false
        wall1.physicsBody?.categoryBitMask = WALL_CATEGORY
        wall2.physicsBody?.categoryBitMask = WALL_CATEGORY
        wall1.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        wall2.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        
        wall1.fillColor = SKColor.grayColor()
        wall2.fillColor = SKColor.grayColor()
        
        wall2.position.y = size1.height/2
        wall2.position.x = -size2.width/2
        
        obstacle.addChild(wall1)
        obstacle.addChild(wall2)
        
        return obstacle
    }
    
    /**
     Creates three horizontal platforms
     
     - Returns: Node of the obstacle
     */
    func createAirPlatforms() -> SKNode {
        let size1 = CGSizeMake(LARGE_WIDTH * 2.5, SMALL_WIDTH)
        var width = LARGE_WIDTH * 32
        let height = LARGE_WIDTH * 5
        let obstacle = SKNode()
        
        
        var wall1 = SKShapeNode(rectOfSize: size1)
        var wall2 = SKShapeNode(rectOfSize: size1)
        var wall3 = SKShapeNode(rectOfSize: size1)
        
        wall1.physicsBody = SKPhysicsBody(rectangleOfSize: size1)
        wall2.physicsBody = SKPhysicsBody(rectangleOfSize: size1)
        wall3.physicsBody = SKPhysicsBody(rectangleOfSize: size1)
        
        wall1.physicsBody?.dynamic = false
        wall2.physicsBody?.dynamic = false
        wall3.physicsBody?.dynamic = false
        
        wall1.physicsBody?.categoryBitMask = WALL_CATEGORY
        wall1.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        wall2.physicsBody?.categoryBitMask = WALL_CATEGORY
        wall2.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        wall3.physicsBody?.categoryBitMask = WALL_CATEGORY
        wall3.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        
        wall1.fillColor = SKColor.grayColor()
        wall2.fillColor = SKColor.grayColor()
        wall3.fillColor = SKColor.grayColor()
        
        wall1.position.x = -LARGE_WIDTH*32/3.5 + wall1.frame.width
        wall1.position.y = height / 2
        
        wall2.position = CGPointMake(0, height / 2)
        
        wall3.position = CGPointMake(LARGE_WIDTH*32/4 - wall2.frame.width, height / 2)
        
        obstacle.addChild(wall1)
        obstacle.addChild(wall2)
        obstacle.addChild(wall3)
        
        return obstacle
    }
    
    /**
     Creates a bouncy wall obstacle

     - Returns: Node of the obstacle
     */
    func createBounceWall() -> SKNode {
        var size1 = CGSizeMake(SMALL_WIDTH, LARGE_WIDTH*4)
        
        var obstacle = SKNode()
        
        var wall1 = SKShapeNode(rectOfSize: CGSizeMake(size1.width, size1.height * 2))
        var wall2 = SKShapeNode(rectOfSize: size1)
        var wall3 = SKShapeNode(rectOfSize: CGSizeMake(size1.width*CGFloat(2.5), SMALL_WIDTH))
        
        wall1.position.x = wall2.position.x - size1.width*4
        wall1.position.y = wall2.position.y + size1.height
        
        wall3.position.x = wall1.position.x + size1.width*2.5 / 2 - size1.width/2
        wall3.position.y = wall2.position.y + size1.height/4
        
        wall1.physicsBody = SKPhysicsBody(rectangleOfSize: wall1.frame.size)
        wall2.physicsBody = SKPhysicsBody(rectangleOfSize: wall2.frame.size)
        wall3.physicsBody = SKPhysicsBody(rectangleOfSize: wall3.frame.size)
        
        wall1.physicsBody?.dynamic = false
        wall2.physicsBody?.dynamic = false
        wall3.physicsBody?.dynamic = false

        
        wall1.physicsBody?.restitution = 0.01
        wall2.physicsBody?.restitution = 0.01
        
        wall1.physicsBody?.categoryBitMask = WALL_CATEGORY
        wall2.physicsBody?.categoryBitMask = WALL_CATEGORY
        wall3.physicsBody?.categoryBitMask = WALL_CATEGORY

        
        wall1.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        wall2.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        wall3.physicsBody?.contactTestBitMask = SLIME_CATEGORY

        
        
        obstacle.addChild(wall1)
        obstacle.addChild(wall2)
        obstacle.addChild(wall3)
        
        wall1.fillColor = SKColor.grayColor()
        wall2.fillColor = SKColor.grayColor()
        wall3.fillColor = SKColor.grayColor()
        
        return obstacle
    }
    
    /**
     Creates a bunker obstacle with high friction
     
     - Parameters:
     - width: Width of the obstacle

     - Returns: SKShapeNode of the bunker
     */
    func createBunker(width:CGFloat) -> SKShapeNode {
        let size = CGSizeMake(width, SMALL_WIDTH)
        var sandNode = SKShapeNode(rectOfSize: size)
        
        sandNode.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        sandNode.physicsBody?.dynamic = false
        sandNode.physicsBody?.categoryBitMask = WALL_CATEGORY
        sandNode.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        sandNode.physicsBody?.friction = 1
        sandNode.fillColor = SKColor.whiteColor()
        sandNode.setTiledFillTexture("sand_texture", tileSize: CGSizeMake(128,sandNode.frame.height))
        
        sandNode.name = "BUNKER"
        
        return sandNode
    }
    
    /**
        Creates 8 big circle obstacles
     
     - Returns: Node of the obstacle
     */
    func createBigCircles() -> SKNode {

        let obstacle = SKNode()
        obstacle.name = "circle_obstacle"
        
        for (var i:Int = 0; i < 8; i++) {
            var circle = SKShapeNode(ellipseOfSize: CGSizeMake(135,135))
            circle.fillColor = SKColor.whiteColor()
            circle.setTiledFillTexture("sandrock_texture", tileSize: CGSizeMake(64,64))

            circle.position.x = CGFloat(i) * CGFloat(275)
            circle.position.y = 150
            
            if (i % 2 == 0) {
                circle.position.y = 100/3
            } else if (i % 3 == 0) {
                circle.position.y = 250/3
            } else if i % 5 == 0 {
                circle.position.y = 190/3
            } else {
                circle.position.y = 275/3
            }
            circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.frame.width/2)
            circle.physicsBody!.dynamic = false
            circle.physicsBody!.categoryBitMask = WALL_CATEGORY
            circle.physicsBody?.contactTestBitMask = SLIME_CATEGORY
            
            
            obstacle.addChild(circle)
        }
        
        return obstacle
    
    }
    
    /**
     Creates a dynamic house obstacle
     
     - Returns: Node of the house
     */
    func createHouse() -> SKNode {
        let houseNode = SKNode()
        
        let baseSize = CGSizeMake(LARGE_WIDTH * 4, MEDIUM_WIDTH)
        let wallSize = CGSizeMake(MEDIUM_WIDTH, LARGE_WIDTH * 4)
        let roofSize = CGSizeMake(baseSize.width, baseSize.height*3)
        

        
        
        var base = SKShapeNode(rectOfSize: baseSize)
        base.physicsBody = SKPhysicsBody(rectangleOfSize: baseSize)
        base.physicsBody?.categoryBitMask = WALL_CATEGORY
        base.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        base.fillColor = SKColor.whiteColor()
        base.setTiledFillTexture("sandrock_texture", tileSize: CGSizeMake(64,64))
        
        base.physicsBody?.dynamic = false
        
        var leftWall = SKShapeNode(rectOfSize: wallSize)
        leftWall.position = CGPointMake(-baseSize.width / 2 + wallSize.width/2, baseSize.height*3)
        leftWall.physicsBody = SKPhysicsBody(rectangleOfSize: wallSize)
        leftWall.physicsBody?.dynamic = true
        leftWall.physicsBody?.categoryBitMask = WALL_CATEGORY
        leftWall.fillColor = SKColor.whiteColor()
        leftWall.setTiledFillTexture("brick_texture", tileSize: CGSizeMake(64,64))
        leftWall.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        
        var rightWall = SKShapeNode(rectOfSize: wallSize)
        rightWall.position = CGPointMake(baseSize.width / 2 - wallSize.width/2, baseSize.height*3)
        rightWall.physicsBody = SKPhysicsBody(rectangleOfSize: wallSize)
        rightWall.physicsBody?.dynamic = true
        rightWall.physicsBody?.categoryBitMask = WALL_CATEGORY
        rightWall.fillColor = SKColor.whiteColor()
        rightWall.setTiledFillTexture("brick_texture", tileSize: CGSizeMake(64,64))
        rightWall.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        
        let roof = SKShapeNode()
        let triangleRect = CGRect(origin: CGPointMake(0,0), size:roofSize)
        var bezierPath = UIBezierPath()
        
        let offsetX = CGRectGetMidX(triangleRect)
        let offsetY = CGRectGetMidY(triangleRect)
        
        bezierPath.moveToPoint(CGPointMake(offsetX, offsetY * 2))
        bezierPath.addLineToPoint(CGPointMake(0, 0))
        bezierPath.addLineToPoint(CGPointMake(offsetX * 2, 0))

        bezierPath.closePath()
        
        roof.path = bezierPath.CGPath
        roof.physicsBody = SKPhysicsBody(polygonFromPath: roof.path!)
        
        roof.physicsBody!.dynamic = true
        roof.physicsBody?.categoryBitMask = WALL_CATEGORY
        roof.physicsBody?.contactTestBitMask = SLIME_CATEGORY
        roof.fillColor = SKColor.whiteColor()
        roof.setTiledFillTexture("brick_texture", tileSize: CGSizeMake(64,64))
        
        roof.position.x = base.position.x - roofSize.width / 2
        roof.position.y = leftWall.position.y + wallSize.height / 2
        
        houseNode.addChild(base)
        houseNode.addChild(leftWall)
        houseNode.addChild(rightWall)
        houseNode.addChild(roof)

        return houseNode
    }
    
}

extension SKShapeNode {
    func setTiledFillTexture(imageName: String, tileSize: CGSize) {
        let targetDimension = max(self.frame.size.width, self.frame.size.height)
        let targetSize = CGSizeMake(targetDimension, targetDimension)
        let targetRef = UIImage(named: imageName)!.CGImage
        
        UIGraphicsBeginImageContext(targetSize)
        let contextRef = UIGraphicsGetCurrentContext()
        CGContextDrawTiledImage(contextRef, CGRect(origin: CGPointZero, size: tileSize), targetRef)
        let tiledTexture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.fillTexture = SKTexture(image: tiledTexture)
    }
}