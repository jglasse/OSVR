//
//  OverlayScene.swift
//
//  Created by Jeff Glasse on 10/22/2015.
//  Copyright © 2016 Jeffery Glasse. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import Foundation

class OverlayScene: SKScene {
    let pauseNode = SKLabelNode(text: "PAUSE")
    let orientationIndicatorNode = SKLabelNode(text: "0")
    let titleNode = SKLabelNode()
    let indicatorNode = SKSpriteNode(color: UIColor.black, size: CGSize(width: 170, height: 70))
    let cropNode = SKCropNode()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let togglePlayNotificationKey = "com.kogeto.togglePlayNotificationKey"
    var owner:VRViewController?
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        if self.pauseNode.contains(location) {
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

        
        self.backgroundColor = UIColor.clear
        
        let spriteIndent = size.width/14
        self.pauseNode.text = "PAUSE"
        self.pauseNode.fontSize = 24
        self.pauseNode.position = CGPoint(x: spriteIndent + 5 , y: size.height - 40)
        
        self.titleNode.text = "Jessica and Friends"
        self.titleNode.fontColor = UIColor.white
        self.titleNode.fontSize = 24
        self.titleNode.position = CGPoint(x: self.size.width/2, y: 10)
        self.orientationIndicatorNode.text = "0"
        self.orientationIndicatorNode.fontSize = 24
        self.orientationIndicatorNode.position = CGPoint(x: size.width - spriteIndent , y: size.height - 40)
        
        
     
        
        
        
        
    // create indicator Node
        
        self.indicatorNode.alpha = 0.45
        self.indicatorNode.position = CGPoint(x: self.size.width/2+160, y: self.size.height/4+7)

        
    // create mask for indicatorNode
        
        let mask = SKSpriteNode(color: UIColor.green, size: CGSize(width: size.width-170, height: size.height/5.5+6))
        
        mask.position = CGPoint(x: self.size.width/2, y: self.size.height/4+7)
        
      //  cropNode.position = CGPointMake(self.size.width/2, self.size.height/4+7)
        cropNode.maskNode = mask

        
        
   
        
        
        
        self.addChild(self.titleNode)
        cropNode.addChild(self.indicatorNode)
        self.addChild(self.cropNode)
        
        self.addChild(self.pauseNode)
        self.addChild(self.orientationIndicatorNode)



        


    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

    
}
