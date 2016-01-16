//
//  MySpriteView.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 7.1.2016.
//  Copyright © 2016 Juho Rautio. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class MySpriteView:SKView {
    var musicPlayer:AVAudioPlayer!
    var isPlaying = false
    
    convenience init() {
        self.init()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        
        do {
            try self.musicPlayer = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("menu_music", withExtension: "mp3")!)
        } catch {
            NSLog("audio not found")
        }
    }
    
    /**
     Starts playing the intro music
     */
    func playMusic() {
        if !isPlaying && getSoundOption() {
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            isPlaying = true
        }
    }
    
    /**
     Stops playing the intro music
     */
    func stopMusic() {
        if isPlaying {
            musicPlayer.stop()
            isPlaying = false
        }
    }
    
}