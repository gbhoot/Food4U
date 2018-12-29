//
//  RecipeDetailViewController.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit
import SpeechKit
import AVFoundation

class RecipeDetailViewController: UIViewController, SKTransactionDelegate {
    
    // Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var directionsSV: UIStackView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var timerLabel: UIButton!
    
    
    // Variables
    var recipe: Recipe?
    var directions: [String]?
    var currentDirectionIndex: Int?
    let siri  = TextToSpeech()
    var counter : Int?
    var total = 0
    var isPause = false
    var timer : Timer?
   var isNextPage  = 0
   var isTimer     = false
   
   var transaction : SKTransaction?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwiper))
      swipeDown.direction = UISwipeGestureRecognizer.Direction.down
      self.view.addGestureRecognizer(swipeDown)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwiperRight))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwiperLeft))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        setupCurrentDirection()
        setupDirectionTimer()
      
      
//         kim-do.SSDMobileNet
         let activity = NSUserActivity(activityType: "kim-do.SSDMobileNet.recipeDetail")
         activity.title = "Recipe Detail"
         activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
        } else {
            // Fallback on earlier versions
        }
      
         self.userActivity = activity
         self.userActivity?.becomeCurrent()
      
         siri.synthesizer.delegate = self
    }
   
   // Functions
    func setupCurrentDirection() {
        guard let directionList = directions, let thisIdx = currentDirectionIndex else { return }
        let thisDir = directionList[thisIdx]
        directionsSV.addArrangedSubview(createDirection(directionStr: thisDir))
        stepLabel.text = "Step: \(thisIdx+1)"
    }
    
    func setupDirectionTimer() {
        guard let directionList = directions, let thisIdx = currentDirectionIndex else { return }
        let thisDir = directionList[thisIdx]
        var minutes = matches(for: "[0-9]+ minute[s]?", in: thisDir)
        for hour in matches(for: "[0-9]+ hour[s]?", in: thisDir) {
            let thisHour = Int(hour.split(separator: " ") [0])
            minutes.append(String(thisHour! * 60) + " minutes")
        }
      
        for step in minutes {
            total += Int(step.split(separator: " ")[0])!
        }
        
        siriSay()
    
        timerLabel.setTitle("\(total) minutes", for: .normal)
    }
    
    @IBAction func startTimerBtnClicked(_ sender: Any) {
        startTimer()
    }
    
    func siriSay() {
        var str = "\(directions![currentDirectionIndex!])"
        
        if total != 0{
            str +=  "Would you like me to start the timer?"
            isTimer = true
        }else{
            str += "Would you like me to take you to the next page?"
            isNextPage = 1
        }
        
        siri.speak(text: str)
    }
    
    func startTimer(){
        if total != 0{
            if counter == nil{
                counter = total * 60
            }
            
            if isPause == false{
                isPause = true
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            }else{
                isPause = false
                timer?.invalidate()
            }
        }else{
            //         currentDirectionIndex =
            respondToSwiperLeft()
        }
    }
    
    @objc func fireTimer() {
        counter! -= 1
        
        let minutes = counter! / 60
        let seconds = counter! % 60
        
        timerLabel.setTitle("\(minutes) : \(seconds) ", for: .normal)
        if total == 0{
            respondToSwiperLeft()
            timer?.invalidate()
        }
    }
    @objc func respondToSwiper() {
//    dismiss(animated: false, completion: nil)
//    dismiss(animated: false, completion: nil)
      unwindVCFromBottom(unwind: SB_UNWIND_SEGUE_TO_INFO_VC)
   }
    
    @objc func respondToSwiperLeft() {
        guard currentDirectionIndex! < (directions?.count)! - 1 else { return }
        
        guard let recipeDetailVC = storyboard?.instantiateViewController(withIdentifier: SB_ID_RECIPE_DETAIL) as? RecipeDetailViewController else { return }
        recipeDetailVC.directions = directions
        recipeDetailVC.currentDirectionIndex = self.currentDirectionIndex! + 1
        self.presentFromLeft(recipeDetailVC)
    }
    
    @objc func respondToSwiperRight() {
        guard currentDirectionIndex! > 0 else { return }
        
        guard let recipeDetailVC = storyboard?.instantiateViewController(withIdentifier: SB_ID_RECIPE_DETAIL) as? RecipeDetailViewController else { return }
        recipeDetailVC.directions = directions
        recipeDetailVC.currentDirectionIndex = self.currentDirectionIndex! - 1
        dismiss(animated: false, completion: nil)
        self.presentFromRight(recipeDetailVC)
    }
    
    func createDirection(directionStr: String) -> UIView {
        let stack = UIStackView()
        
        let directionLbl = UILabel()
        directionLbl.numberOfLines = 15
        directionLbl.lineBreakMode = .byWordWrapping
        directionLbl.text = directionStr
        directionLbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        stack.addArrangedSubview(directionLbl)
        siri.speak(text: directionStr)
        return stack
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
   
   func siri_repeat_direction(){
      siri.speak(text: directions![currentDirectionIndex!])
   }
   
   func startListen(){
      let url = "nmsps://NMDPTRIAL_kim_h_do_seven_gmail_com20181109212822@sslsandbox-nmdp.nuancemobility.net:443"
      let appToken = "e9dc7b3d5667f02f40e3d996ed48caa11b3dc9c6aba568c417652f88a186f98a6274c7b9dbb7e81b9ac1b188097b2925b8f2eb63975327afb8573759dd30e33f"
      let session = SKSession(url: URL(string: url), appToken: appToken)
      transaction =  session?.recognize(withType: SKTransactionSpeechTypeDictation,
                                        detection: .long, //need to work on check on type
         language: "eng-USA",
         delegate: self)
   }
   
   func transaction(_ transaction: SKTransaction!, didReceive recognition: SKRecognition!) {
      let command = recognition.text!
      if isNextPage == 1{
         if command.contains("Yes") || command.contains("yes") || command.contains("Yeah"){
            respondToSwiperLeft()
         }else if command.contains("No") || command.contains("no"){
            if (command.contains("No") || command.contains("no")) && currentDirectionIndex != 0{
               siri.speak(text: "Would you you like me to take you back to previous page?")
               isNextPage = -1
            }else{
               siri.speak(text: "Options Not Found. Please say Yes or No")
               startListen()
            }
            
         }
      }else if isNextPage == -1{
         if command.contains("Yes") || command.contains("yes") || command.contains("Yeah"){
            respondToSwiperRight()
         }else if command.contains("No") || command.contains("no"){
            siri.speak(text: "I am done with you boss!")
         }
      }else if isTimer{
         if command.contains("Yes") || command.contains("Yes"){
            startTimer()
         }else if !(command.contains("No") || command.contains("no")){
            siri.speak(text: "Options Not Found. Please say Yes or No")
            startListen()
         }
      }
      print(recognition.text!)
   }
}

extension RecipeDetailViewController: AVSpeechSynthesizerDelegate {
   func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
      print("all done")
      
      startListen()
   }
}
