//
//  GameOverlay.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 29.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverlay : SKNode {
    let movesLabel:SKLabelNode = SKLabelNode(fontNamed: "Kailasa-Bold")
    var moves:Int
    var par:Int
    var settings = OptionsDialog()
    let parLabel:SKLabelNode = SKLabelNode(fontNamed: "Kailasa-Bold")
    let highScoreLabel = SKLabelNode(fontNamed: "Kailasa-Bold")
    let settingsSprite = SKSpriteNode(imageNamed: "settings_icon")
    var highScore:Int!
    var size = CGSizeMake(0,0)
    
    override init() {
        self.moves = 0
        self.par = 0
        

        movesLabel.text = ("Moves: \(self.moves)")
        movesLabel.fontSize = 25
        movesLabel.fontColor = SKColor.darkGrayColor()
        
        highScoreLabel.fontSize = 25
        highScoreLabel.fontColor = SKColor.darkGrayColor()
        highScoreLabel.text = "Best: 0"
        
        settingsSprite.setScale(0.5)
        settingsSprite.name = "settings"

        
        super.init()
        
        
        self.addChild(movesLabel)
        self.addChild(settingsSprite)
        self.addChild(highScoreLabel)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Initializes positions of the labels
     
     - Parameters:
     - size: size of the parent view
     */
    func initLabels(size:CGSize) {
        self.size = size
        movesLabel.position = CGPointMake(30 - size.width/2 + movesLabel.frame.size.width/2, size.height/2 - movesLabel.frame.size.height - 20)
        settingsSprite.position = CGPointMake(size.width/2 - settingsSprite.frame.width/2 - CGFloat(20), size.height/2 - settingsSprite.frame.height/2 - CGFloat(20))
        highScoreLabel.position = CGPointMake(30 - size.width/2 + highScoreLabel.frame.size.width/2, movesLabel.position.y - movesLabel.frame.height * 1.5)
    }
    
    /**
     Updates overlay labels
     */
    func update() {
        movesLabel.text = ("Moves: \(self.moves)")
        
        if highScore < 0 {
            highScoreLabel.text = "Best: -"
        } else {
            highScoreLabel.text = "Best: \(highScore)"
        }
        
        movesLabel.position.x = 30 - size.width/2 + movesLabel.frame.size.width/2
        highScoreLabel.position.x = 30 - size.width/2 + highScoreLabel.frame.size.width/2
    }
    
    
}