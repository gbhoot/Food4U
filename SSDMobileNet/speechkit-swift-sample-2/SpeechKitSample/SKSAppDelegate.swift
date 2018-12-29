//
//  SKSAppDelegate.swift
//  SpeechKitSample
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

import UIKit

@UIApplicationMain
class SKSAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        // WARNING! Note that UI logic can be very different and therefore,
        // the implementation below might not be portable...
        
        let viewCtrls = (window?.rootViewController)?.childViewControllers
        
        // There will be at least one child view controller: SKSMainViewController and possibly
        // a second one if the user selected one from the main window when something happened
        // for this application to lose focus (i.e. user press 'Home', launch another app, receives
        // a call, etc.).
        // The main view does not feed any data to the network like ASR or TTS views would do.
        // But it will be invoked here in case enhancements are required.

        for viewCtrl in viewCtrls! {
            if viewCtrl is SKSMainViewController {
                let ctrl:SKSMainViewController = viewCtrl as! SKSMainViewController
                ctrl.releaseServerResources()
            }
            else if viewCtrl is SKSASRViewController {
                let ctrl:SKSASRViewController = viewCtrl as! SKSASRViewController
                ctrl.releaseServerResources()
            }
            else if viewCtrl is SKSNLUViewController {
                let ctrl:SKSNLUViewController = viewCtrl as! SKSNLUViewController
                ctrl.releaseServerResources()
            }
        }
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

