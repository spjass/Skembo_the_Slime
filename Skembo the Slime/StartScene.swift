//
//  StartScene.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 1.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class StartScene: SKScene {
    
    let TITLE = "Skembo the Slime"

    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blueColor()
        self.scaleMode = SKSceneScaleMode.AspectFill
        self.addChild(self.createTitle())
        self.addChild(self.createPlayButton())
        self.addChild(self.createAboutButton())
        
        var view = view as! MySpriteView
        view.playMusic()

        
        
    }
    
    /**
     Creates the title/logo

     - Returns: Node of the logo
     */
    func createTitle() -> SKSpriteNode {
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.setScale(1.5)
        logo.position = CGPointMake(CGRectGetMidX(self.frame),  self.frame.height * (3/4))
        
        return logo
    }
    
    /**
     Creates "START GAME" -button
     
     - Returns: SKLabelNode of the button
     */
    func createPlayButton() -> SKLabelNode {
        let playNode = SKLabelNode(fontNamed: "GillSans-Bold")
        playNode.text = "START GAME"

        playNode.fontSize = CGFloat(20)
        playNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        playNode.position.y -= playNode.frame.height * 3
        playNode.name = "play_button"
        
        return playNode
        
    }
    
    /**
     Creates "ABOUT" -button
     
     - Returns: SKLabelNode of the button
     */
    func createAboutButton() -> SKLabelNode {
        let aboutNode = SKLabelNode(fontNamed: "GillSans-Bold")
        aboutNode.text = "ABOUT"
        
        aboutNode.fontSize = 20
        aboutNode.position.y = self.childNodeWithName("play_button")!.position.y - aboutNode.frame.height * 2
        aboutNode.position.x = CGRectGetMidX(self.frame)
        aboutNode.name = "about_button"
        
        return aboutNode
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.locationInNode(self)
        let node = self.nodeAtPoint(location!)
        
        if node.name == "play_button" {
            let gameScene = LevelSelectScene(size: self.size)
            let transition = SKTransition.fadeWithDuration(0.5)
            self.view?.presentScene(gameScene, transition: transition)
        }
        
        if node.name == "about_button" {
            let aboutScene = AboutScene(size: self.size)
            let transition = SKTransition.fadeWithDuration(0.5)
            self.view?.presentScene(aboutScene, transition: transition)
        }

    }
    
    

}