//
//  SKSAudioViewController.swift
//  SpeechKitSample
//
//  This Controller is built to demonstrate how to play an Audio file.
//
//  SpeechKit gives you the ability to play an audio file that is packaged with you application. This
//  is especially useful for playing earcons. Earcons are what notify the user of the listening state.
//
//  In this example we play a file stored in '/Resources'.
//
//  Note: We are using the same technique to play earcons in SKSASRViewController.m and SKSNLUViewController.m
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

import UIKit
import SpeechKit

class SKSAudioViewController : UIViewController, SKAudioPlayerDelegate {
    
    // User interface
    @IBOutlet weak var toggleAudioButton: UIButton?
    @IBOutlet weak var logTextView: UITextView?
    @IBOutlet weak var clearLogsButton: UIButton?
    @IBOutlet weak var repetitionStepper: UIStepper?
    @IBOutlet weak var repetitionText: UITextField?
    
    var skSession: SKSession?
    var audioFile: SKAudioFile?
    var repeatCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repetitionText!.text = String(Int(repetitionStepper!.value))
        
        // Create a session
        skSession = SKSession(url: URL(string: SKSServerUrl), appToken: SKSAppKey)
        
        if (skSession == nil) {
            let alertView = UIAlertController(title: "SpeechKit", message: "Failed to initialize SpeechKit session.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertView.addAction(defaultAction)
            present(alertView, animated: true, completion: nil)
            return
        }
        
        skSession!.audioPlayer.delegate = self
        
        // Create a SKAudio and load it from disk
        let filePath = Bundle.main.path(forResource: "sk_start", ofType: "pcm")
        let audioFormat = SKPCMFormat()
        audioFormat.sampleFormat = .signedLinear16
        audioFormat.sampleRate = 16000
        audioFormat.channels = 1
        audioFile = SKAudioFile(url: URL(fileURLWithPath: filePath!), pcmFormat: audioFormat)
        if(audioFile == nil) {
            let alertView = UIAlertController(title: "SpeechKit", message: "Failed to initialize SKAudio.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertView.addAction(defaultAction)
            present(alertView, animated: true, completion: nil)
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Audio Actions
    @IBAction func toggleAudioPlayback() {
        toggleAudioButton?.isEnabled = false
        
        repeatCount = Int(repetitionStepper!.value)
        var audioCreateCount = repeatCount
        
        skSession!.audioPlayer.play()
        
        while(audioCreateCount > 0) {
            skSession!.audioPlayer.enqueue(audioFile)
            audioCreateCount -= 1
        }
    }
    
    
    // MARK - SKAudioPlayerDelegate
    
    func audioPlayer(_ player: SKAudioPlayer!, willBeginPlaying audio: SKAudio!) {
        log("willBeginPlaying")
        
        // The SKAudio will begin playing.
    }
    
    func audioPlayer(_ player: SKAudioPlayer!, didFinishPlaying audio: SKAudio!) {
        log("didFinishPlaying")
        
        // The SKAudio has finished playing.
        
        // If the last SKAudio is finished playing then stop the SKAudioPlayer to free resources
        // and re-enable the enqueue button.
        repeatCount -= 1
        if (repeatCount == 0) {
            skSession!.audioPlayer.stop()
            toggleAudioButton!.isEnabled = true
        }
    }
    
    // MARK: - Other Actions
    
    @IBAction func clearLogs(_ sender: UIButton) {
        logTextView!.text = ""
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        repetitionText!.text = String(Int(repetitionStepper!.value))
    }
    
    //MARK - Helpers
    
    func log(_ message: String) {
        logTextView!.text = logTextView!.text.appendingFormat("%@\n", message)
    }
}
