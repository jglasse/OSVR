//
//  VRViewController.swift
//
//  Created by Jeffery Glasse on 10/1/15.
//  Copyright (c) 2015 Kogeto, Inc. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit     // for SKVideoNode
import AVFoundation  // for video playback engine


class VRViewController: UIViewController {
    
    let fileList = ["01 Jessica & Friends at Coachella.mp4", "02 EA Battlefield Hardline", "03 Laurel Dewitt NYC"]

    var cameraNode: SCNNode!
    var  tubeNode: SCNNode!
    var planeNode:SCNNode!
    var scnView:SCNView!
    var overlayScene: OverlayScene!
    var appDelegate: AppDelegate!
    
    
// utility functions for degrees to radians and vice versa
    
    func degreesToRadians(degrees: Float) -> Float {
        return (degrees * Float(M_PI)) / 180.0
    }
    
    func radiansToDegrees(radians: Float) -> Float {
        return (180.0/Float(M_PI)) * radians
    }

    
    func setCameraRotation(degrees: Float)
    {
    self.cameraNode.rotation = SCNVector4Make(0,0,1,degreesToRadians(degrees))
    
    }
    
    
// setup
    override func viewDidLoad() {
        let togglePlayNotificationKey = "com.kogeto.togglePlayNotificationKey"
        let videoWidth = 3840
        let videoHeight = 720
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "togglePlay", name: togglePlayNotificationKey, object: nil)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        super.viewDidLoad()
        
        // create a scene view with an empty scene

        let scene = SCNScene()

        
        // create the tube
        let tube = SCNTube(innerRadius: 1.99, outerRadius: 2, height: 3)
        self.tubeNode = SCNNode(geometry: tube)
        scene.rootNode.addChildNode(tubeNode)

       
        // assign singleton AVVIdeoPlayer As VideoNode within SKScene
        
        let videoNode = SKVideoNode(AVPlayer: appDelegate.videoPlayer)
        let spritescene = SKScene(size: CGSize(width: videoWidth, height: videoHeight))
        videoNode.position = CGPointMake(spritescene.size.width/2, spritescene.size.height/2)
        videoNode.size.width = spritescene.size.width
        videoNode.size.height = spritescene.size.height
        videoNode.xScale = -1.0;
        spritescene.addChild(videoNode)
        
        // assign SKScene-embedded video to tube geometry

        tube.firstMaterial?.diffuse.contents  = spritescene
        
        
        // create a plane and do the same
        let plane = SCNPlane(width: 2, height: 0.3)
        plane.firstMaterial?.diffuse.contents = spritescene
        let planeNode = SCNNode(geometry: plane)
        scene.rootNode.addChildNode(planeNode)
        planeNode.position=SCNVector3(x: 0, y: 0.35, z: -1)
        
        
        
        // create camera, add to the scene
        self.cameraNode = SCNNode()
        self.cameraNode.camera = SCNCamera()
       // self.cameraNode.rotation.w = 551.6668
        
        cameraNode.camera?.xFov = 10
        cameraNode.camera?.yFov = 74
        scene.rootNode.addChildNode( self.cameraNode)
        
        // place the camera
         self.cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
         self.cameraNode.rotation = SCNVector4Make(0,0,1,degreesToRadians(180))

        
        
        // retrieve the SCNView
        self.scnView = self.view as! SCNView
        
        // set the scene to the view
        self.scnView.scene = scene
        
        // allows the user to manipulate the camera
        self.scnView.allowsCameraControl = false
        
        // show statistics such as fps and timing information
        self.scnView.showsStatistics = false
        
        // configure the view and start playing
        self.scnView.backgroundColor = UIColor.blackColor()
        self.scnView.playing = true
        
        //create overlay
        
        self.overlayScene = OverlayScene(size: self.view.bounds.size)
        self.scnView.overlaySKScene = self.overlayScene
        self.overlayScene.owner = self

        
        

    }

    func togglePlay()
    {
        self.scnView.playing = !self.scnView.playing
    }
    
   @IBAction
    func handlePan(sender: UIPanGestureRecognizer)
        {
            switch(sender.state) {
            
            case .Ended:
                fallthrough
                
            case .Changed:
            
                let translation = sender.translationInView(sender.view!)
                
                let translationConverted:Float = Float(translation.x) / 200  *  Float(M_PI_4)
               let currentRotation = self.tubeNode.rotation.w

                self.tubeNode.rotation =  SCNVector4Make(0, 1, 0, currentRotation+translationConverted)
               
                
            sender.setTranslation(CGPointZero, inView: self.view)

                if (self.overlayScene.indicatorNode.position.x < 100) {
                    self.overlayScene.indicatorNode.position.x = 580}
                
                
                if (self.overlayScene.indicatorNode.position.x > 580) { self.overlayScene.indicatorNode.position.x = 100}
                
                self.overlayScene.indicatorNode.position = CGPoint(x: overlayScene.indicatorNode.position.x-translation.x/3, y: self.overlayScene.indicatorNode.position.y)
                

            
            default:
                break
 
            }
    
    }
    

       
    func renderer(aRenderer: SCNSceneRenderer!, updateAtTime time: NSTimeInterval) {
    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
            return .All
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    
}

