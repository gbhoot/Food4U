//
//  SKSMainViewController.swift
//  SpeechKitSample
//
//  Initial screen.
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

import UIKit

class SKSMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var actionItems: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        actionItems = [
            [
                "title":"Core technologies",
                "values":[
                    ["Speech Recognition", "Cloud based ASR", "SegueRecog"],
                    ["Speech and Natural Language", "Cloud based ASR with NLU", "SegueNLU"],
                    ["Text and Natural Language", "Cloud based NLU (text input)", "SegueTextNLU"],
                    ["Speech Synthesis", "Cloud based TTS", "SegueTts"]
                ]
            ],
            [
                "title":"Utilities",
                "values": [
                    ["Audio Playback", "Loading and playing a resource", "SegueAudio"]
                ]
            ],
            [
                "title":"Miscellaneous",
                "values": [
                    ["Configuration", "Host URL, App ID, etc", "SegueConfig"],
                    ["About", "Learn more about SpeechKit", "SegueAbout"]
                ]
            ]
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated. 
    }
    
    func releaseServerResources() {
        // Depending if the application let data streaming (either ASR or TTS) continue,
        // or not, even if the user returns to the main window, additional logic could
        // be implemented here to cancel ongoing transactions.
    }

    /*
    * UITableViewDataSource
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = actionItems!.object(at: section) as! Dictionary<String, AnyObject>
        let subGroup = group["values"] as! Array<AnyObject>
        return subGroup.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return actionItems!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group = actionItems!.object(at: section) as! Dictionary<String, AnyObject>
        return group["title"] as? String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SkActionCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let sectionData = actionItems!.object(at: (indexPath as NSIndexPath).section) as! NSDictionary
        let rowData = (sectionData.value(forKey: "values")! as! NSArray).object(at: (indexPath as NSIndexPath).row) as! NSArray
        
        cell!.textLabel!.text = rowData[0] as? String
        cell!.detailTextLabel!.text = rowData[1] as? String
        return cell!
    }
    
    /*
    * UITableViewDelegate
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionData = actionItems!.object(at: (indexPath as NSIndexPath).section) as! NSDictionary
        let rowData = (sectionData.value(forKey: "values")! as! NSArray).object(at: (indexPath as NSIndexPath).row) as! NSArray
        
        performSegue(withIdentifier: rowData[2] as! String, sender: self)
    }

}

