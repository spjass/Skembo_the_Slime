//
//  ViewController.swift
//  Skembo the Slime
//
//  Created by Juho Rautio on 5.11.2015.
//  Copyright © 2015 Juho Rautio. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class ViewController: UIViewController {
    
    var spriteView:MySpriteView!
    var musicPlayer:AVAudioPlayer!
    var isMusicPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spriteView = self.view as! MySpriteView
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("memory warning")
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let startScene = StartScene(size: self.spriteView.bounds.size)

        spriteView.presentScene(startScene)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
}

