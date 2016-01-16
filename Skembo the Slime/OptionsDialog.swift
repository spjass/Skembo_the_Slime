//
//  OptionsDialog.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 30.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit

class OptionsDialog:SKNode {
    
    var container:SKShapeNode?
    let title = "SETTINGS"
    let titleNode = SKLabelNode(fontNamed: "GillSans-Bold")
    var isOpened = false
    var soundEnabled = true
    var powerEnabled = true
    var isInitialized = false
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Creates the options dialog window
     */
    func createDialog() {
        
        
        let containerWidth = CGFloat(300)
        let containerHeight = CGFloat(200)
        
        container = SKShapeNode(rectOfSize: CGSizeMake(containerWidth,containerHeight), cornerRadius: 0.5)
        container!.name = "options_container"
        container!.fillColor = SKColor.grayColor()
        
        let continueLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        continueLabel.fontSize = 20
        continueLabel.text = "Continue game"
        continueLabel.name = "continue_label"
        
        let menuLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        menuLabel.fontSize = 20
        menuLabel.text = "Back to main menu"
        menuLabel.name = "menu_label"
        
        let restartLevelLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        restartLevelLabel.fontSize = 20
        restartLevelLabel.text = "Restart level"
        restartLevelLabel.name = "restart_label"
        
        let soundToggleNode = SKNode()
        
        let soundLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        soundLabel.fontSize = 20
        soundLabel.text = "Sound enabled: "
        soundLabel.position.x = -containerWidth / 2 + soundLabel.frame.width / 2 + 15
        soundLabel.name = "sound_label"
        
        let soundBoolLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        soundBoolLabel.fontSize = 20
        soundBoolLabel.text = "YES"
        soundBoolLabel.position.x = containerWidth / 2 - soundBoolLabel.frame.width / 2 - 15
        soundBoolLabel.name = "sound_bool"
        
        soundToggleNode.addChild(soundLabel)
        soundToggleNode.addChild(soundBoolLabel)
        soundToggleNode.name = "sound_node"
        
        let powerVectorToggleNode = SKNode()
        
        let powerLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        powerLabel.fontSize = 20
        powerLabel.text = "Show power vector: "
        powerLabel.position.x = -containerWidth / 2 + powerLabel.frame.width / 2 + 15
        powerLabel.name = "power_label"
        
        let powerBoolLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        powerBoolLabel.fontSize = 20
        powerBoolLabel.text = "YES"
        powerBoolLabel.position.x = containerWidth / 2 - powerBoolLabel.frame.width / 2 - 15
        powerBoolLabel.name = "power_bool"
        
        powerVectorToggleNode.addChild(powerLabel)
        powerVectorToggleNode.addChild(powerBoolLabel)
        powerVectorToggleNode.name = "power_node"
        
        
        
        
        
        menuLabel.position = CGPointMake(CGRectGetMidX(container!.frame), CGRectGetMidY(container!.frame))
        menuLabel.position.y = -containerHeight / 2 + menuLabel.frame.size.height
        
        continueLabel.position = CGPointMake(CGRectGetMidX(container!.frame), CGRectGetMidY(container!.frame))
        restartLevelLabel.position = CGPointMake(CGRectGetMidX(container!.frame), CGRectGetMidY(container!.frame))
        
        restartLevelLabel.position.y = menuLabel.position.y + restartLevelLabel.frame.height * 1.5
        continueLabel.position.y = restartLevelLabel.position.y + restartLevelLabel.frame.height * 1.5

        titleNode.fontSize = 25
        titleNode.text = title
        titleNode.position = CGPointMake(CGRectGetMidX(container!.frame), CGRectGetMidY(container!.frame))
        
        titleNode.position.y = titleNode.position.y + container!.frame.height/2 - titleNode.frame.height * 1.5
        
        powerVectorToggleNode.position.y = titleNode.position.y - powerLabel.frame.size.height * 1.5
        
        soundToggleNode.position.y = powerVectorToggleNode.position.y - soundLabel.frame.size.height * 1.5
        
        
        isOpened = true
        
        self.addChild(container!)
        container!.addChild(titleNode)
        container!.addChild(continueLabel)
        container!.addChild(menuLabel)
        container!.addChild(powerVectorToggleNode)
        container!.addChild(soundToggleNode)
        container!.addChild(restartLevelLabel)
        
        initOptionsValues()
    }
    
    /**
     Initializes the options values from NSUserDefaults
     */
    func initOptionsValues() {

        soundEnabled = getSoundOption()
        powerEnabled = getPowerOption()
        isInitialized = true
        
        setColours()
    }
    
    func setColours() {
        
        let soundLabel = childNodeWithName("options_container")!.childNodeWithName("sound_node")!.childNodeWithName("sound_bool") as! SKLabelNode
        let powerLabel = childNodeWithName("options_container")!.childNodeWithName("power_node")?.childNodeWithName("power_bool") as! SKLabelNode
        
        if soundEnabled {
            soundLabel.fontColor = SKColor.greenColor()
            soundLabel.text = "YES"
        } else {
            soundLabel.fontColor = SKColor.redColor()
            soundLabel.text = "NO"

        }
        
        if powerEnabled {
            powerLabel.fontColor = SKColor.greenColor()
            powerLabel.text = "YES"

        } else {
            powerLabel.fontColor = SKColor.redColor()
            powerLabel.text = "NO"

        }
    }
    
    /**
     Handles the touch events of the dialog window
     */
    func touchHandle(touch:UITouch) {
        let location = touch.locationInNode(self)
        let node = self.nodeAtPoint(location)

        
        if node.name == "continue_label" {
            let scene = self.scene as! GameScene

            if soundEnabled && !scene.isPlayingMusic {

                scene.musicPlayer.play()
            }
            
            if !soundEnabled && scene.isPlayingMusic {
                scene.musicPlayer.pause()
            }
            
            close()
        }
        
        if node.name == "menu_label" {
            let scene = self.scene as! GameScene

            scene.changeSceneToMainMenu()
        }
        
        if node.name == "restart_label" {
            let gameScene = self.scene as! GameScene
            gameScene.restartLevel()
        }
        
        if node.name == "sound_node" || node.parent?.name == "sound_node" {

            if soundEnabled {
                soundEnabled = false
            } else {
                soundEnabled = true
            }
            
        }

        if node.name == "power_node" || node.parent?.name == "power_node" {
            
            if powerEnabled {
                powerEnabled = false
            } else {
                powerEnabled = true
            }
        }
        
        if isInitialized {
            setColours()
        }
        
        
    }
    
    /**
     Closes the dialog window and saves changes
     */
    func close() {
        self.removeFromParent()
        isOpened = false
        saveSoundOption(soundEnabled)
        savePowerOption(powerEnabled)
    }
}