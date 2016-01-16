//
//  UserDefaultsHelper.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 5.1.2016.
//  Copyright © 2016 Juho Rautio. All rights reserved.
//

import Foundation
let defaults = NSUserDefaults.standardUserDefaults()

/**
 Gets the sound option from NSUserDefaults
 
 - Returns: True if sound option enabled
 */
func getSoundOption() -> Bool {
    
    if let enabled = defaults.objectForKey("sound_enabled") {
        return enabled as! Bool
    } else {
        defaults.setBool(true, forKey: "sound_enabled")
        return true
    }
}

/**
 Saves the sound option to NSUserDefaults
 
 - Parameters:
 - enabled: True if sound enabled

 */
func saveSoundOption(enabled:Bool) {
    defaults.setBool(enabled, forKey: "sound_enabled")
}

/**
 Gets the option for displaying the power vector from NSUserDefaults
 
 - Returns: True if enabled
 */
func getPowerOption() -> Bool {
    if let enabled = defaults.objectForKey("power_enabled") {
        return enabled as! Bool
    } else {
        defaults.setBool(true, forKey: "power_enabled")
        return true
    }}

/**
 Saves the option for displaying the power vector in NSUserDefaults
 
 - Parameters:
 - enabled: True if enabled

 */
func savePowerOption(enabled:Bool) {
    defaults.setBool(enabled, forKey: "power_enabled")
}

func getHighScore(level:LevelNode) -> Int {
    if let enabled = defaults.objectForKey(level.name!) {
        return enabled as! Int
    } else {
        defaults.setInteger(-1, forKey: level.name!)
        return -1
    }
}

/**
 Saves the highscore for selected level to NSUserDefaults
 
 - Parameters:
 - score: Score to save
 - level: LevelNode to save the score for

 */
func saveHighScore(score:Int, level:LevelNode) {
    defaults.setInteger(score, forKey: level.name!)
}

/**
 Returns the score of a selected level from NSUserDefaults
 
 - Parameters:
 - style: The style of the bicycle

 - Returns: A beautiful, brand-new bicycle, custom built
 just for you.
 */
func getHighScore(levelName:String) -> Int {
    if let enabled = defaults.objectForKey(levelName) {
        return enabled as! Int
    } else {
        defaults.setInteger(-1, forKey: levelName)
        return -1
    }
}

/**
 Saves the highscore for selected level in NSUserDefaults
 
 - Parameters:
 - score: Score to save
 - levelName: Name of the level

 */
func saveHighScore(score:Int, levelName:String) {
    defaults.setInteger(score, forKey: levelName)
}