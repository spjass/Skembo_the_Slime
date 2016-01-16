//
//  AboutScene.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 7.1.2016.
//  Copyright © 2016 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

class AboutScene:SKScene {
    
    let TITLE = "About"
    
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blueColor()
        self.scaleMode = SKSceneScaleMode.AspectFill
        self.addChild(self.createTitle())
        self.addChild(self.createCredits())
        self.addChild(self.createBackButton())

        
        
        
    }
    
    /**
     Creates the title label
     
     - Returns: SKLabelNode of the title
     */
    func createTitle() -> SKLabelNode {
        let title = SKLabelNode(fontNamed: "GillSans-Bold")
        title.position = CGPointMake(CGRectGetMidX(self.frame),  self.frame.height * (3/4))
        title.text = TITLE
        title.fontSize = 25
        
        return title
    }
    
    /**
     Creates credits -labels
     
     - Returns: Node containing the labels
     */
    func createCredits() -> SKNode {
        let creditsNode = SKNode()
        
        let row1Left = SKLabelNode(fontNamed: "GillSans-Bold")
        let row1Right = SKLabelNode(fontNamed: "GillSans-Bold")
        
        let row2Left = SKLabelNode(fontNamed: "GillSans-Bold")
        let row2Right = SKLabelNode(fontNamed: "GillSans-Bold")
        
        let row3Left = SKLabelNode(fontNamed: "GillSans-Bold")
        let row3Right = SKLabelNode(fontNamed: "GillSans-Bold")
        
        row1Left.fontSize = 20
        row1Right.fontSize = 20
        
        row2Left.fontSize = 20
        row2Right.fontSize = 20
        
        row3Left.fontSize = 20
        row3Right.fontSize = 20
        
        row1Left.text = "Coding"
        row1Right.text = "Juho Rautio"
        
        row2Left.text = "Graphics"
        row2Right.text = "Marita Kauppi & Juho Rautio"

        row3Left.text = "Music"
        row3Right.text = "Tristan Lohengrin"

        row1Left.position = CGPointMake(row1Left.frame.width / 2 + 30, 0)
        row2Left.position = CGPointMake(row2Left.frame.width / 2 + 30, row1Left.position.y - row2Left.frame.height * 1.5)
        row3Left.position = CGPointMake(row3Left.frame.width / 2 + 30, row2Left.position.y - row2Left.frame.height * 1.5)

        row1Right.position = row1Left.position
        row2Right.position = row2Left.position
        row3Right.position = row3Left.position
        
        row1Right.position.x = self.frame.width - row1Right.frame.width / 2 - 30
        row2Right.position.x = self.frame.width - row2Right.frame.width / 2 - 30
        row3Right.position.x = self.frame.width - row3Right.frame.width / 2 - 30

        
        creditsNode.addChild(row1Left)
        creditsNode.addChild(row2Left)
        creditsNode.addChild(row3Left)

        creditsNode.addChild(row1Right)
        creditsNode.addChild(row2Right)
        creditsNode.addChild(row3Right)
        
        
        creditsNode.position.y = CGRectGetMidY(self.frame)

        return creditsNode
        
    }
    
    /**
     Creates back button
     
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
        
        if node.name == "back_button" {
            let startScene = StartScene(size: self.size)
            let transition = SKTransition.fadeWithDuration(0.5)
            self.view?.presentScene(startScene, transition: transition)
        }
        
    }
    
}