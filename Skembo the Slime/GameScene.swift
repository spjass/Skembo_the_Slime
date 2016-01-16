//
//  GameScene.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 1.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class GameScene:SKScene, SKPhysicsContactDelegate {
    var isCreated: Bool = false
    // The root node of your game world. Attach game entities
    // (player, enemies, &c.) to here.
    var world: WorldNode?
    // The root node of our UI. Attach control buttons & state
    // indicators here.
    var overlay: GameOverlay?
    // The camera. Move this node to change what parts of the world are visible.
    var myCamera: SKNode?
    
    var musicPlayer:AVAudioPlayer!
    
    var backBorder: SKSpriteNode?
    var endBorder:SKSpriteNode?
    var slimeSprite:SlimeSpriteNode!
    let SLIME_CATEGORY : UInt32 = 1 << 0
    let EDGE_CATEGORY : UInt32 = 1 << 1
    let GROUND_CATEGORY : UInt32 = 1 << 2
    var frameCount:Int!
    var startLocation:CGPoint!
    var endLocation:CGPoint!
    var slimeTouch:Bool = false
    let backgroundSkyNode = SKSpriteNode(imageNamed: "background_sky")
    var groundSprite1:SKSpriteNode?
    var groundSprite2:SKSpriteNode?
    var lastPoint:CGPoint!
    var lastMoved:Int?
    var isMoving:Bool = false
    var isBunker:Bool = false
    var isGoal = false
    var currentLevel:LevelNode!
    var levelFactory:LevelFactory!
    var highScoreMade:Bool = false
    var isPlayingMusic:Bool = false

    var isSoundEnabled:Bool {
        set(newValue) {
            saveSoundOption(newValue)
        } get {
            return getSoundOption()
        }
    }
    
    var isPowerEnabled:Bool {
        set(newValue) {
            savePowerOption(newValue)
        } get {
            return getPowerOption()
        }
    }
    var gameOver:Bool = false
    var parallaxBackgroundNode:ParallaxBackgroundNode!
    var powerIndicator = SKShapeNode(rectOfSize: CGSizeMake(10,5))

    convenience init(size:CGSize, level:LevelNode) {
        self.init(size: size)
        self.currentLevel = level

    }
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.yellowColor()
        self.physicsWorld.contactDelegate = self;
        self.scaleMode = .AspectFit
        
        var view = self.view! as! MySpriteView
        view.stopMusic()
        
        playMusic()
        
        
        if !isCreated {
            isCreated = true
            lastMoved = 0
            self.physicsWorld.gravity = CGVector(dx:0.0, dy:-4.9)
            levelFactory = LevelFactory(parentFrame: self.frame)
            // Camera setup
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.world = WorldNode(frame:self.frame)
            
            if currentLevel != nil {
                self.world!.currentLevel = currentLevel
            } else {
                self.world!.currentLevel = levelFactory.createLevel3()
            }
            
            self.world!.initLevel(self.world!.currentLevel!)
            world!.position = CGPointMake(0 - self.frame.width / 2, 0 - self.frame.height)
            self.world?.name = "world"
            groundSprite1 = world!.groundSprite1
            groundSprite2 = world!.groundSprite2
            
            slimeSprite = SlimeSpriteNode()

            backgroundSkyNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            backgroundSkyNode.size = CGSizeMake(self.frame.width, self.frame.height)
            
            
            backBorder = SKSpriteNode()
            
            backBorder?.position = CGPointMake(CGRectGetMidX(self.frame) - self.frame.width/2,0)
            backBorder?.size.height = self.frame.height * 100
            backBorder?.size.width = 1
            backBorder?.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(backBorder!.frame.width, backBorder!.frame.height))
            backBorder?.physicsBody?.categoryBitMask = EDGE_CATEGORY
            backBorder?.physicsBody?.dynamic = false
            
            endBorder = SKSpriteNode()
            
            endBorder?.position = CGPointMake(3000,0)
            endBorder?.size.height = self.frame.height * 100
            endBorder?.size.width = 1
            endBorder?.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(endBorder!.frame.width, endBorder!.frame.height))
            endBorder?.physicsBody?.categoryBitMask = EDGE_CATEGORY
            endBorder?.physicsBody?.dynamic = false

            if let goal = self.world!.currentLevel?.childNodeWithName("GOAL") {
                endBorder!.position.x = goal.position.x + 600
            }
            
            
            world!.currentLevel!.addChild(slimeSprite)
            
            world!.addChild(backBorder!)
            world!.addChild(endBorder!)
            
            //backgroundSkyNode.zPosition = 0.5
            self.addChild(backgroundSkyNode)
            
            parallaxBackgroundNode = currentLevel.parallaxBackground
            
            addChild(parallaxBackgroundNode)
            addChild(self.world!)
            
            
            self.myCamera = SKNode()
            self.myCamera?.name = "camera"
            self.world?.addChild(self.myCamera!)
            lastPoint = myCamera?.position

            // UI setup
            self.overlay = GameOverlay()
            self.overlay?.zPosition = 10
            self.overlay?.name = "overlay"
            self.overlay?.initLabels(self.frame.size)
            self.overlay?.highScore = currentLevel.highScore
            
            self.world!.zPosition = 3
            self.parallaxBackgroundNode.zPosition = 2
            //self.world?.backgroundSkyNode.zPosition = 1
            slimeSprite.addChild(powerIndicator)
            powerIndicator.hidden = true
            powerIndicator.name = "POWER"

            addChild(self.overlay!)
            
        }
        
        
        //frameCount = 0
        
    }
    
    /**
     Starts playing the game music if sound is enabled from options
     */
    func playMusic() {
        do {
            try self.musicPlayer = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("game_music", withExtension: "mp3")!)
            if isSoundEnabled {
                self.musicPlayer.numberOfLoops = -1
                if (!isPlayingMusic) {
                    self.musicPlayer.play()
                    isPlayingMusic = true
                }
            }
        } catch {
            NSLog("audio not found")
        }
    }
    
    /**
     Stops playing the game music
     */
    func stopMusic() {
        if isPlayingMusic {
            self.musicPlayer.pause()
            isPlayingMusic = false
        }
    }
    
    override func didSimulatePhysics() {

        
        if self.overlay != nil {
            checkIfMovementStopped()
            self.overlay!.update()
            
        }
        
        if parallaxBackgroundNode.origin == CGPointMake(0.0,0.0) {
            
            if self.myCamera != nil {
                parallaxBackgroundNode.origin = self.myCamera!.position
                initParallax()
            }
        }
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstNode = contact.bodyA.node
        let secondNode = contact.bodyB.node
        
        if (contact.bodyB.categoryBitMask == SLIME_CATEGORY) && (contact.bodyA.categoryBitMask == GROUND_CATEGORY) {
            if slimeSprite != nil {
                slimeSprite.animateBounce()
                
            }
            
        }
        
        if (contact.bodyB.categoryBitMask == SLIME_CATEGORY) && (contact.bodyA.categoryBitMask == GOAL_CATEGORY) {
            isGoal = true
        } else if (contact.bodyA.categoryBitMask == SLIME_CATEGORY) && (contact.bodyB.categoryBitMask == GOAL_CATEGORY) {
            isGoal = true
        }
        
        if (contact.bodyA.categoryBitMask == SLIME_CATEGORY) && (contact.bodyB.categoryBitMask == WALL_CATEGORY) {
            
            if slimeSprite != nil {
                    slimeSprite.animateBounce()

                
                if secondNode!.name == "ICE" {
                    slimeSprite!.physicsBody?.friction = 0.01
                }
                
                if secondNode!.name == "BUNKER" {
                    isBunker = true
                }
            }
            
        } else if (contact.bodyB.categoryBitMask == SLIME_CATEGORY) && (contact.bodyA.categoryBitMask == WALL_CATEGORY) {

            if slimeSprite != nil {

                    slimeSprite.animateBounce()

                
                
                
                if firstNode!.name == "ICE" {
                    //slimeSprite!.physicsBody?.friction = 0.01

                }
                
                if firstNode!.name == "BUNKER" {
                    isBunker = true
                }
            }
        }
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let firstNode = contact.bodyA.node
        let secondNode = contact.bodyB.node
        
        if (contact.bodyB.categoryBitMask == SLIME_CATEGORY) && (contact.bodyA.categoryBitMask == GROUND_CATEGORY) {
            
            //slimeSprite.isOnGround(false)
        }
        
        if (contact.bodyB.categoryBitMask == SLIME_CATEGORY) && (contact.bodyA.categoryBitMask == GOAL_CATEGORY) {
            isGoal = false
        } else if (contact.bodyA.categoryBitMask == SLIME_CATEGORY) && (contact.bodyB.categoryBitMask == GOAL_CATEGORY) {
            isGoal = false
        }
        
        if (contact.bodyA.categoryBitMask == SLIME_CATEGORY) && (contact.bodyB.categoryBitMask == WALL_CATEGORY) {
            
            if slimeSprite != nil {
                
                if secondNode!.name == "ICE" {
                    slimeSprite!.physicsBody?.friction = 0.2
                }
                
                
                if secondNode!.name == "BUNKER" {
                    isBunker = false
                }
                
            }
            
        } else if (contact.bodyB.categoryBitMask == SLIME_CATEGORY) && (contact.bodyA.categoryBitMask == WALL_CATEGORY) {
            
            if slimeSprite != nil {
                
                
                if firstNode!.name == "ICE" {
                    slimeSprite!.physicsBody?.friction = 0.2

                }
                
                if firstNode!.name == "BUNKER" {
                    isBunker = false
                }
            }
        }
    }

    
    func centerOnNode(node: SKNode) {
        let cameraPositionInScene: CGPoint = node.scene!.convertPoint(node.position, fromNode: node.parent!)
        
        node.parent!.position = CGPoint(x:node.parent!.position.x - cameraPositionInScene.x, y:node.parent!.position.y - cameraPositionInScene.y)
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        if self.myCamera != nil {
            self.centerOnNode(self.myCamera!)
            cameraFollowNode()
            scrollGround()
        }
        
        if self.parallaxBackgroundNode != nil {
            self.parallaxBackgroundNode.updatePositions(myCamera!)
        }
        
    }
    
    /**
     Inits the parallax background position
     */
    func initParallax() {
        parallaxBackgroundNode.position.y = groundSprite1!.frame.height
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch?.locationInNode(myCamera!)
        let node = self.nodeAtPoint(location!)
        
        if slimeTouch {
            updatePowerIndicator(startLocation, endPoint: location!)

        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch?.locationInNode(myCamera!)
        let node = self.nodeAtPoint(location!)
        
        if node.name == "slime" {
            startLocation = location
            slimeTouch = true
            
            if var powerNode = slimeSprite.childNodeWithName("POWER") {
                
                if powerNode.hidden && isPowerEnabled && !isMoving {
                    powerNode.hidden = false
                }
            }
        }
        
        
        
        if (gameOver) {
            let startScene = StartScene(size: self.size)
            let transition = SKTransition.doorsCloseVerticalWithDuration(0.5)
            self.view?.presentScene(startScene, transition: transition)
            stopMusic()
        }
        
        if node.name == "settings" {
            openSettings()
        }
        
        overlay!.settings.touchHandle(touch!)
        
    }
    
    /**
     Makes the camera node to follow the slimeSprite
     */
    func cameraFollowNode() {
        let slime = slimeSprite
        
        if slime != nil {
            var position = slime!.position
            position.x = position.x + self.frame.width / 4
            position.y = CGRectGetMidY(self.frame)
            
            // Follow slime in air
            if slime!.position.y > CGRectGetMidY(self.frame) {
                position.y = slime!.position.y
            }
            
            // Stop camera if going left
            if slime!.position.x < backBorder!.position.x + self.frame.width/4 {
                position.x = backBorder!.position.x + self.frame.width/2
            }
            
            // Stop camera after goal
            if slime.position.x > endBorder!.position.x - self.frame.width*(3/4) {
                position.x = endBorder!.position.x - self.frame.width/2
            }

            
            let action = SKAction.moveTo(position, duration: 0.15)
            self.myCamera!.runAction(action)
            
        }
        
        
    }
    
    
    /**
     Handles the scrolling of the ground, and adding new ground sprites if camera goes far enough
     */
    func scrollGround() {
        if var camera = myCamera {
            
            if(camera.position.x > groundSprite1!.position.x + groundSprite1!.size.width + 1000)
            {
                groundSprite1!.position = CGPointMake(groundSprite2!.position.x + groundSprite2!.size.width - 25, groundSprite2!.position.y )
                backBorder!.position = CGPointMake((groundSprite2?.position.x)! - self.frame.width/2, 0)
            }
            
            if(camera.position.x > groundSprite2!.position.x + groundSprite2!.size.width + 1000)
            {
                groundSprite2!.position = CGPointMake(groundSprite1!.position.x + groundSprite1!.size.width - 25, groundSprite1!.position.y)
                backBorder!.position = CGPointMake((groundSprite1?.position.x)! - self.frame.width/2, 0)
                
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch?.locationInNode(myCamera!)
        endLocation = location
        
        if let slime = slimeSprite {
            
            if slimeTouch && !isMoving {
                slime.physicsBody!.applyImpulse(calculateJumpVector(startLocation, endLocation))
                
                moveBegan()
                slimeSprite.playSound(slimeSprite.jumpSound)
                
                
            }
            powerIndicator.position.y = 100*100
            powerIndicator.hidden = true
        }
        
        slimeTouch = false
        
    }

    /**
     Draws the vector power indicator
     
     - Parameters:
     - startPoint: Start CGPoint of the vector
     - endPoint: End CGPoint of the vector

     */
    func updatePowerIndicator(startPoint:CGPoint, endPoint:CGPoint) {
        
        var vector = calculateJumpVector(startPoint,endPoint)
        powerIndicator.fillColor = SKColor.greenColor()
        var zeroedX = endPoint.x - startPoint.x
        var zeroedY = endPoint.y - startPoint.y
        var scaler = CGFloat(0)
        var dirx = CGFloat(-1), diry = CGFloat(-1)
        
        if zeroedY < 0 {
            diry = 1
            
            if zeroedX < 0 {
                dirx = 1
            }
        } else  {
            diry = -1
            
            if zeroedX < 0 {
                dirx = 1
            }
        }
        

        
        if (sqrt(pow(zeroedX,2)) > sqrt(pow(zeroedY,2))){
            scaler = zeroedX
        } else {
            scaler = zeroedY

        }
        
        var angle = atan2(vector.dx, vector.dy) - CGFloat(M_PI/2)
        
        scaler = sqrt(scaler * scaler)
        if (scaler < 3 && scaler > 3) || (scaler > -3 && scaler < -3) {
            scaler = 3
        }
        
        
        var rotateAction = SKAction.rotateToAngle(-angle, duration: 0)
        var scaleAction = SKAction.scaleXTo(scaler/4, duration: 0)
        

        var moveActionX = SKAction.moveToX(powerIndicator.frame.width/2*dirx - 3 * dirx,duration: 0)
        var moveActionY = SKAction.moveToY(powerIndicator.frame.height/2*diry - 3 * diry, duration: 0)
        
        powerIndicator.runAction(moveActionX)
        powerIndicator.runAction(moveActionY)

        powerIndicator.runAction(rotateAction)
        powerIndicator.runAction(scaleAction)
            }
    
    /**
     Calculates the jump vector
     
     - Parameters:
     - startPoint: Start (first touch) CGPoint of the vector
     - endPoint: End (release touch) CGPoint of the vector
     
     - Returns: Power CGVector
     */
    func calculateJumpVector(startPoint:CGPoint, _ endPoint:CGPoint) -> CGVector {
        var multiplier:CGFloat = 0.115
        var x = (startPoint.x - endPoint.x)
        var y = (startPoint.y - endPoint.y)
        var mag = sqrt(x*x+y*y);
        let POWER_MAX:CGFloat = 55
        
        if mag > POWER_MAX {
            x = x * (POWER_MAX / mag)
            y = y * (POWER_MAX / mag)
            mag = sqrt(x*x+y*y)
        }
        
        if isBunker {
            mag /= 2
        }
     

        
        x = x*mag
        y = y*mag
        var ptu = 1.0 / sqrt(SKPhysicsBody(rectangleOfSize: CGSizeMake(1.0,1.0)).mass) / 100
        self.physicsWorld.gravity.dy = -4.9
        let vector = CGVectorMake(x*multiplier*ptu, y*multiplier*ptu)
        
        return vector
    }
    
    /**
     Opens the settings dialog
     */
    func openSettings() {
        var settingsNode = OptionsDialog()

        if !self.overlay!.settings.isOpened {
            settingsNode.createDialog()
            settingsNode.container!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            self.overlay!.addChild(settingsNode)
            overlay!.settings = settingsNode
        }
        
    }
    
    /**
     Checks if slimeSprite has stopped moving horizontally
     
     - Returns: True if movement stopped
     */
    func checkIfMovementStopped() -> Bool {
        
        if (slimeSprite != nil) {
            
            if slimeSprite.position.x / slimeSprite.oldLocation.x < 1.00001 && slimeSprite.position.x / slimeSprite.oldLocation.x > 0.99999 {
                
                lastMoved!++
            } else {
                lastMoved = 0
                
            }
            
            slimeSprite.oldLocation = slimeSprite.position
            
        }
        
        if lastMoved > 30 {
            moveEnded()
            return true
        }
        return false
    }
    
    /**
     Handles actions when starting movement
     */
    func moveBegan() {
        self.overlay!.moves++
        isMoving = true
        lastMoved = 0
        self.overlay?.movesLabel.fontColor = SKColor.redColor()
        slimeSprite.isOnGround(false)
        
        
    }
    
    /**
     Handles actions when ending movement
     */
    func moveEnded() {
        isMoving = false
        self.overlay?.movesLabel.fontColor = SKColor.greenColor()
        checkIfGoal()
        slimeSprite.isOnGround(true)
        
    }
    
    /**
     Checks if slimeSprite has reached the goal node and creates the end game dialog if true
     */
    func checkIfGoal() {
        if (isGoal && !gameOver) {
            
            if (overlay?.moves)! < currentLevel.highScore || currentLevel.highScore < 0 {
                saveHighScore((overlay?.moves)!, level: currentLevel)
                highScoreMade = true
            }
            
            overlay?.addChild(createEndGameMenu())
        }
    }
    
    /**
     Animates moving obstacles
     */
    func animateMovingObstacles() {
        let obstacle = self.world!.childNodeWithName("vertical_moving_wall")
        //var directionUp:Bool = true
        
        if let wall = obstacle {
            
            let minY = 0 - groundSprite1!.frame.height/2
            let maxY = minY + 450
            /*
            if wall.position.y < minY && !directionUp {
            directionUp = true
            } else if wall.position.y > maxY && directionUp {
            directionUp = false
            }
            */
            var moveDown = SKAction.moveToY(minY, duration: 3)
            var moveUp = SKAction.moveToY(maxY, duration: 3)
            
            
            let sequence = SKAction.sequence([moveUp,moveDown])
            
            wall.runAction(SKAction.repeatActionForever(sequence))
            
        }
        
    }
    
    /**
     Creates the end game dialog
     
     - Returns: SKNode of the dialog
     */
    func createEndGameMenu() -> SKNode {
        let endNode = SKNode()
        let containerWidth = CGFloat(300)
        let containerHeight = CGFloat(200)
        gameOver = true
        
        let containerNode = SKShapeNode(rectOfSize: CGSizeMake(containerWidth,containerHeight), cornerRadius: 0.5)
        containerNode.name = "container"
        containerNode.fillColor = SKColor.grayColor()
        
        let victoryLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        containerNode.addChild(victoryLabel)
        if highScoreMade {
            victoryLabel.text = "LEVEL PASSED - NEW HIGHSCORE"
        } else {
            victoryLabel.text = "LEVEL PASSED"
        }
        victoryLabel.fontSize = CGFloat(16)
        victoryLabel.position.x = CGRectGetMidX(containerNode.frame)
        victoryLabel.position.y = CGRectGetMidY(containerNode.frame) + containerNode.frame.height / 6
        
        let movesLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        containerNode.addChild(movesLabel)
        movesLabel.fontSize = CGFloat(16)
        movesLabel.text = "MOVES: \(overlay!.moves)"
        movesLabel.position.x = CGRectGetMidX(containerNode.frame)
        movesLabel.position.y = CGRectGetMidY(containerNode.frame) - containerNode.frame.height / 6
        
        let continueLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        containerNode.addChild(continueLabel)
        continueLabel.text = "Tap anywhere to return to menu"
        continueLabel.fontSize = CGFloat(14)
        continueLabel.position.x = CGRectGetMidX(containerNode.frame)
        continueLabel.position.y = CGRectGetMidY(containerNode.frame) - containerNode.frame.height / 2 + continueLabel.frame.height
        endNode.addChild(containerNode)
        
        return endNode
    }
    
    /**
     Returns to main menu
     */
    func changeSceneToMainMenu() {
        let startScene = StartScene(size: self.size)
        let transition = SKTransition.doorsCloseVerticalWithDuration(0.5)
        self.view?.presentScene(startScene, transition: transition)
    }
    
    /**
     Restarts the current level
     */
    func restartLevel() {
        self.overlay!.settings.close()
        var level = LevelNode(parentFrame: self.frame)
        
        if currentLevel.name == "level1" {
            level = levelFactory.createLevel1()
        } else if currentLevel.name == "level2" {
            level = levelFactory.createLevel2()
        } else if currentLevel.name == "level3" {
            level = levelFactory.createLevel3()
        } 
        
        let startScene = GameScene(size: self.size, level: level)
        let transition = SKTransition.doorwayWithDuration(0.5)
        self.view?.presentScene(startScene, transition: transition)
    }
    
    
}