//
//  SKSAboutViewController.swift
//  SpeechKitSample
//
//  Screen to display extra info about SpeechKit.
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

import UIKit

class SKSAboutViewController : UIViewController {

    @IBOutlet weak var versionTextView: UITextView?
    @IBOutlet weak var urlTextView: UITextView?
    @IBOutlet weak var emailTextView: UITextView?
    @IBOutlet weak var componentTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appVersionFromConfig = Bundle.main.object(forInfoDictionaryKey: "AppVersion")
        let appVersion = String(format: "SpeechKit SampleApp v%@", arguments: [String(describing: appVersionFromConfig!)])
        
        versionTextView!.text = appVersion
        
        let urlHtml = "<a>http://developer.nuance.com</a>"
        
        urlTextView!.attributedText = textToHtml(urlHtml)
        
        let emailHtml = "<a>developerrelations@nuance.com</a>"
        
        emailTextView!.attributedText = textToHtml(emailHtml)
        
        let sdkVersionFromConfig = Bundle.main.object(forInfoDictionaryKey: "SdkVersion")
        let sdkVersion = String(format: "SpeechKit SDK %@", arguments: [String(describing: sdkVersionFromConfig!)])
        
        componentTextView!.text = sdkVersion
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textToHtml(_ text: String!) -> NSAttributedString {
        do {
            return try NSAttributedString(data: text.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        } catch {
            return NSAttributedString(string: "")
        }
    }
}
