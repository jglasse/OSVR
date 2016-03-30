//
//  OverlayScene.swift
//
//  Created by Jeff Glasse on 10/22/2015.
//  Copyright (c) 2015 All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import Foundation

class OverlayScene: SKScene {
    let pauseNode = SKLabelNode(text: "PAUSE")
    let titleNode = SKLabelNode()
    let indicatorNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 170, height: 70))
    let cropNode = SKCropNode()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let togglePlayNotificationKey = "com.kogeto.togglePlayNotificationKey"
    var owner:VRViewController?
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
 
        
        if self.pauseNode.containsPoint(location) {
            
           self.togglePlay()

            
            
        }
    }
    
    func togglePlay() {
        if  (self.owner!.videoPlaying) {
            self.pauseNode.text =  "PLAY"
            self.owner?.videoNode?.pause()
            print("paused")
            print(appDelegate.videoPlayer.rate)
            self.owner?.videoPlaying = false
            
        }
        else {
            self.pauseNode.text = "PAUSE"
            self.owner?.videoNode?.play()
            print("playing")
            print(appDelegate.videoPlayer.rate)
            self.owner?.videoPlaying = true
          
        }

    
    
    }
    
        
    func hideUI() {
    
    
    
    
    }
    
    
    
    override init(size: CGSize) {
        super.init(size: size)
        print("Overlay Scene size:", size)

        
        self.backgroundColor = UIColor.clearColor()
        
        let spriteIndent = size.width/14
        self.pauseNode.text = "PAUSE"
        self.pauseNode.fontSize = 24
        self.pauseNode.position = CGPoint(x: spriteIndent + 5 , y: size.height - 40)
        
        self.titleNode.text = "Jessica and Friends"
        self.titleNode.fontColor = UIColor.whiteColor()
        self.titleNode.fontSize = 24
        self.titleNode.position = CGPoint(x: self.size.width/2, y: 10)
     
        
        
        
        
    // create indicator Node
        
        self.indicatorNode.alpha = 0.45
        self.indicatorNode.position = CGPointMake(self.size.width/2+160, self.size.height/4+7)

        
    // create mask for indicatorNode
        
        let mask = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: size.width-170, height: size.height/5.5+6))
        
        mask.position = CGPointMake(self.size.width/2, self.size.height/4+7)
        
      //  cropNode.position = CGPointMake(self.size.width/2, self.size.height/4+7)
        cropNode.maskNode = mask

        
        
   
        
        
        
        self.addChild(self.titleNode)
        cropNode.addChild(self.indicatorNode)
        self.addChild(self.cropNode)
        
        self.addChild(self.pauseNode)


        


    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

    
}
