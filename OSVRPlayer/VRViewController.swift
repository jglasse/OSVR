//
//  VRViewController.swift
//
//  Created by Jeffery Glasse on 10/1/15.
//  Copyright © 2016 Jeffery Glasse. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit     // for SKVideoNode
import AVFoundation  // for video playback engine


class VRViewController: UIViewController {
    
    var cameraNode: SCNNode!
    var tubeNode: SCNNode!
    var planeNode:SCNNode!
    var scnView:SCNView!
    var overlayScene: OverlayScene!
    var appDelegate: AppDelegate!
    var videoNode: SKVideoNode?
    var cameraAngleX : Float?
    var cameraAngleY : Float?
    var videoPlaying = false

    
    
    
// utility functions for degrees to radians and vice versa
    
    func degreesToRadians(_ degrees: Float) -> Float {
        return (degrees * Float(M_PI)) / 180.0
    }
    
    func radiansToDegrees(_ radians: Float) -> Float {
     var tempdegrees = (180.0/Float(M_PI)) * radians
        
        
        if  tempdegrees > 360 {tempdegrees = tempdegrees-360}
        else if tempdegrees < 0 {tempdegrees = tempdegrees+360}

        return tempdegrees
    }

    
    func setCameraRotation(_ radians: Float)
    {
        self.tubeNode.rotation =  SCNVector4Make(0, 1, 0, radians)
        let degrees = round(radiansToDegrees(radians))
        
        self.overlayScene.orientationIndicatorNode.text = "\(degrees)°"
        print("Camera Rotation (radians):", radians)
        print("Camera Rotation (degrees):", radiansToDegrees(radians))
    }
    
    
    
// setup
    override func viewDidLoad() {
        let togglePlayNotificationKey = "com.kogeto.togglePlayNotificationKey"
        let videoWidth = 3840
        let videoHeight = 720
        NotificationCenter.default.addObserver(self, selector: #selector(VRViewController.togglePlay), name: NSNotification.Name(rawValue: togglePlayNotificationKey), object: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        super.viewDidLoad()
        
        // create a scene view with an empty scene

        let scene = SCNScene()

        
        // create the tube
        let tube = SCNTube(innerRadius: 1.99, outerRadius: 2, height: 3)
        self.tubeNode = SCNNode(geometry: tube)
        scene.rootNode.addChildNode(tubeNode)

       
        // assign singleton AVVIdeoPlayer As VideoNode within SKScene
        self.videoNode = SKVideoNode(avPlayer: appDelegate.videoPlayer)
        let spritescene = SKScene(size: CGSize(width: videoWidth, height: videoHeight))
        self.videoNode!.position = CGPoint(x: spritescene.size.width/2, y: spritescene.size.height/2)
        self.videoNode!.size.width = spritescene.size.width
        self.videoNode!.size.height = spritescene.size.height
        self.videoNode!.xScale = -1.0;
        spritescene.addChild(self.videoNode!)
        
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
        self.scnView.backgroundColor = UIColor.black
        self.scnView.isPlaying = true
        
        //create overlay
        
        self.overlayScene = OverlayScene(size: self.view.bounds.size)
        self.scnView.overlaySKScene = self.overlayScene
        self.overlayScene.owner = self

        
        

    }

    func togglePlay()
    {
        self.videoNode?.pause()
    }
    
   @IBAction
    func handlePan(_ sender: UIPanGestureRecognizer)
        {
            switch(sender.state) {
            
            case .ended:
                fallthrough
                
            case .changed:
            
                let translation = sender.translation(in: sender.view!)
                
              let translationConverted:Float = Float(translation.x) / 100  *  Float(M_PI_4)
               let currentRotation = self.tubeNode.rotation.w
                
                self.setCameraRotation(currentRotation+translationConverted)
               
                
            sender.setTranslation(CGPoint.zero, in: self.view)

                if (self.overlayScene.indicatorNode.position.x < 100) {
                    self.overlayScene.indicatorNode.position.x = 580}
                
                
                if (self.overlayScene.indicatorNode.position.x > 580) { self.overlayScene.indicatorNode.position.x = 100}
                
                self.overlayScene.indicatorNode.position.x = overlayScene.indicatorNode.position.x-translation.x/1.6
            

            
            default:
                break
 
            }
    
    }
    

    
       
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}

