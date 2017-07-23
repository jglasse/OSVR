//
//  AppDelegate.swift
//  LookerVRPlayer
//
//  Created by Jeffery Glasse on 10/18/15.
//  Copyright © 2016 Jeffery Glasse. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var videoPlayer: AVPlayer! // Global video player, accessible from all views and controllers
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let videoList = ["01 Jessica_Coachella","NY360_E2", "03 Laurel Dewitt NYC"]
        
        let currentVideo = videoList[1]
        
        let urlStr = Bundle.main.path(forResource: currentVideo, ofType: "mov")
        let url = URL(fileURLWithPath: urlStr!)
        let asset = AVURLAsset(url: url, options: nil)
        let playerItem = AVPlayerItem(asset: asset)
        self.videoPlayer = AVPlayer(playerItem: playerItem)
        self.videoPlayer.play()
        
        //create notification center for looping of video
        NotificationCenter.default.addObserver(self,
            selector: #selector(AppDelegate.playerItemDidReachEnd(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: self.videoPlayer.currentItem)

        
        return true
    }

    func playerItemDidReachEnd(_ notification: Notification) {
        self.videoPlayer.seek(to: kCMTimeZero)
        self.videoPlayer.play()
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

