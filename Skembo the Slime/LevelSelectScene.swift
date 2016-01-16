//
//  LevelSelectScene.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 5.1.2016.
//  Copyright © 2016 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

class LevelSelectScene:SKScene {
    
    
    let TITLE = "Select level"
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blueColor()
        self.scaleMode = SKSceneScaleMode.AspectFill
        self.addChild(self.createTitle())
        self.addChild(self.createLevelButtons())
        self.addChild(self.createBackButton())
        
    }
    
    /**
     Creates the title node
     
     - Returns: SKLabelNode of the title
     */
    func createTitle() -> SKLabelNode {
        let helloNode = SKLabelNode(fontNamed: "GillSans-Bold")
        helloNode.name = self.TITLE
        helloNode.text = self.TITLE
        helloNode.fontSize = CGFloat(50)
        helloNode.position = CGPointMake(CGRectGetMidX(self.frame),  self.frame.height * (4/5))
        
        return helloNode
    }
    
    /**
     Creates icons, buttons and stats of all levels

     - Returns: Node containing the level icons, buttons and labels
     */
    func createLevelButtons() -> SKNode {
        let container = SKNode()
        let size = CGSizeMake(self.frame.width / 6, self.frame.height / 6)
        
        let level1Button = SKShapeNode(rectOfSize: size)
        let level2Button = SKShapeNode(rectOfSize: size)
        let level3Button = SKShapeNode(rectOfSize: size)
        
        let level1Label = SKLabelNode(fontNamed: "GillSans-Bold")
        let level2Label = SKLabelNode(fontNamed: "GillSans-Bold")
        let level3Label = SKLabelNode(fontNamed: "GillSans-Bold")
        
        let level1HighScoreLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        let level2HighScoreLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        let level3HighScoreLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        
        level1Button.name = "level1"
        level2Button.name = "level2"
        level3Button.name = "level3"
        level1Label.name = "level1"
        level2Label.name = "level2"
        level3Label.name = "level3"
        level1HighScoreLabel.name = "level1"
        level2HighScoreLabel.name = "level2"
        level3HighScoreLabel.name = "level3"


        level1Label.fontSize = 14
        level2Label.fontSize = 14
        level3Label.fontSize = 14
        level1Label.text = "Level 1"
        level2Label.text = "Level 2"
        level3Label.text = "Level 3"
        
        level1HighScoreLabel.fontSize = 14
        level2HighScoreLabel.fontSize = 14
        level3HighScoreLabel.fontSize = 14

        var hs1 = getHighScore("level1")
        var hs2 = getHighScore("level2")
        var hs3 = getHighScore("level3")

        if hs1 < 0 {
            level1HighScoreLabel.text = "Best: -"
        } else {
            level1HighScoreLabel.text = "Best: \(hs1)"
        }
        
        if hs2 < 0 {
            level2HighScoreLabel.text = "Best: -"
        } else {
            level2HighScoreLabel.text = "Best: \(hs2)"
        }
        
        if hs3 < 0 {
            level3HighScoreLabel.text = "Best: -"
        } else {
            level3HighScoreLabel.text = "Best: \(hs3)"
        }



        level2Button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        level1Button.position = level2Button.position
        level1Button.position.x = level2Button.position.x - size.width * 1.5
        level3Button.position = level2Button.position
        level3Button.position.x = level2Button.position.x + size.width * 1.5
        
        level1Label.position = CGPointMake(level1Button.position.x, level1Button.position.y - size.height * 1.2)
        level2Label.position = CGPointMake(level2Button.position.x, level2Button.position.y - size.height * 1.2)
        level3Label.position = CGPointMake(level3Button.position.x, level3Button.position.y - size.height * 1.2)
        
        level1HighScoreLabel.position = CGPointMake(level1Label.position.x, level1Label.position.y - level1Label.frame.height / 2 - level1HighScoreLabel.frame.height)
        level2HighScoreLabel.position = CGPointMake(level2Label.position.x, level2Label.position.y - level2Label.frame.height / 2 - level2HighScoreLabel.frame.height)
        level3HighScoreLabel.position = CGPointMake(level3Label.position.x, level3Label.position.y - level3Label.frame.height / 2 - level3HighScoreLabel.frame.height)
        
        level1Button.fillColor = SKColor.whiteColor()
        level2Button.fillColor = SKColor.whiteColor()
        level3Button.fillColor = SKColor.whiteColor()
        
        level1Button.setTiledFillTexture("brick_texture", tileSize: CGSizeMake(64,64))
        level2Button.setTiledFillTexture("ice_texture", tileSize: CGSizeMake(64,64))
        level3Button.setTiledFillTexture("sandrock_texture", tileSize: CGSizeMake(64,64))
        
        container.addChild(level1Button)
        container.addChild(level2Button)
        container.addChild(level3Button)
        container.addChild(level1Label)
        container.addChild(level2Label)
        container.addChild(level3Label)
        container.addChild(level1HighScoreLabel)
        container.addChild(level2HighScoreLabel)
        container.addChild(level3HighScoreLabel)

        
        return container
        
    }
    
    /**
     Creates a back button
     
     - Returns: SKLabelNode of the button
     */
    func createBackButton() -> SKLabelNode {
        let backButton = SKLabelNode(fontNamed: "GillSans-Bold")
        backButton.name = "back_button"
        
        backButton.fontSize = 22
        backButton.text = "BACK"
        backButton.position = CGPointMake(self.frame.width/2, backButton.frame.height * 1.5)
        
        return backButton
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.locationInNode(self)
        let node = self.nodeAtPoint(location!)
        let levelFactory = LevelFactory(parentFrame: self.frame)
        var gameScene = GameScene(size: self.frame.size)
        let transition = SKTransition.doorsOpenVerticalWithDuration(1.5)

        if node.name == "level1" {
            gameScene = GameScene(size: self.frame.size, level: levelFactory.createLevel1())
            self.view?.presentScene(gameScene, transition: transition)
        }
        
        if node.name == "level2" {
            gameScene = GameScene(size: self.frame.size, level: levelFactory.createLevel2())
            self.view?.presentScene(gameScene, transition: transition)

        }
        
        if node.name == "level3" {
            gameScene = GameScene(size: self.frame.size, level: levelFactory.createLevel3())
            self.view?.presentScene(gameScene, transition: transition)

        }
        
        if node.name == "back_button" {
            let startScene = StartScene(size: self.size)
            let transition = SKTransition.fadeWithDuration(0.5)
            self.view?.presentScene(startScene, transition: transition)
        }
    }
}

