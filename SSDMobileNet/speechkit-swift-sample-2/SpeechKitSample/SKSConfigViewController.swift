//
//  SKSConfigViewController.swift
//  SpeechKitSample
//
//  Read-only screen to view configuration parameters set in SKSConfiguration.mm
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

import UIKit

class SKSConfigViewController : UIViewController {
    
    @IBOutlet weak var appId: UITextView?
    @IBOutlet weak var appKey: UITextView?
    @IBOutlet weak var contextTag: UITextView?
    @IBOutlet weak var serverHost: UITextView?
    @IBOutlet weak var serverPort: UITextView?

    @IBOutlet weak var appIdHeight: NSLayoutConstraint?
    @IBOutlet weak var appKeyHeight: NSLayoutConstraint?
    @IBOutlet weak var contextTagHeight: NSLayoutConstraint?
    @IBOutlet weak var serverHostHeight: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appId!.text = SKSAppId
        appKey!.text = SKSAppKey
        contextTag!.text = SKSNLUContextTag
        serverHost!.text = SKSServerHost
        serverPort!.text = SKSServerPort
        
        appIdHeight!.constant = textViewHeight(appId)
        appKeyHeight!.constant = textViewHeight(appKey)
        contextTagHeight!.constant = textViewHeight(contextTag)
        serverHostHeight!.constant = textViewHeight(serverHost)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewHeight(_ view: UITextView!) -> CGFloat {
        view.sizeToFit()
        return view.frame.size.height
    }
}
