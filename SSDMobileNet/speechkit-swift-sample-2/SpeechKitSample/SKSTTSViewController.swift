//
//  SKSTTSViewController.swift
//  SpeechKitSample
//
//  This Controller is built to demonstrate how to perform TTS.
//
//  TTS is the transformation of text into speech.
//
//  When performing speech synthesis with SpeechKit, you have a variety of options. Here we demonstrate
//  Language. But you can also specify the Voice. If you do not, then the default voice will be used
//  for the given language.
//
//  Supported languages and voices can be found here:
//  http://dragonmobile.nuancemobiledeveloper.com/public/index.php?task=supportedLanguages
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

import UIKit
import SpeechKit

class SKSTTSViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate, SKTransactionDelegate, SKAudioPlayerDelegate {
    
    // State Logic: IDLE <-> PLAYING <-> PAUSED
    enum SKSState {
        case idle
        case playing
        case paused
    }

    // User interface
    @IBOutlet weak var ttsTextView: UITextView?
    @IBOutlet weak var logTextView: UITextView?
    @IBOutlet weak var toggleTtsButton: UIButton?
    @IBOutlet weak var clearLogsButton: UIButton?
    @IBOutlet weak var languageTextView: UITextField?
    
    // Settings
    var language: String!
    
    var skSession:SKSession?
    var skTransaction:SKTransaction?
    
    var state = SKSState.idle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        language = LANGUAGE
        self.languageTextView!.text = language
        
        state = .idle
        skTransaction = nil
        
        // Create a session
        skSession = SKSession(url: URL(string: SKSServerUrl), appToken: SKSAppKey)
        
        if (skSession == nil) {
            let alertView = UIAlertController(title: "SpeechKit", message: "Failed to initialize SpeechKit session.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertView.addAction(defaultAction)
            present(alertView, animated: true, completion: nil)
            return
        }

        // listen to audio events
        skSession?.audioPlayer.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    // MARK: - TTS Transactions
    @IBAction func toggleTts() {
        switch state {
        case .idle:
            if(skTransaction == nil) {
                skTransaction = skSession!.speak(ttsTextView?.text,
                                                 withLanguage: language,
                                                 options: nil,
                                                 delegate: self)
            } else {
                skTransaction!.cancel()
                resetTransaction()
            }

        case .playing:
            skSession!.audioPlayer.pause()
            self.toggleTtsButton?.setTitle("speakString", for: UIControlState())
            state = .paused

        case .paused:
            skSession!.audioPlayer.play()
            self.toggleTtsButton?.setTitle("pause", for: UIControlState())
            state = .playing
        }
    }
    
    // MARK - SKTransactionDelegate
    
    func transaction(_ transaction: SKTransaction!, didReceive audio: SKAudio!) {
        log("didReceiveAudio")
    }
    
    func transaction(_ transaction: SKTransaction!, didFinishWithSuggestion suggestion: String) {
        log("didFinishWithSuggestion")
    }
    
    func transaction(_ transaction: SKTransaction!, didFailWithError error: Error!, suggestion: String) {
        log(String(format: "didFailWithError: %@. %@", arguments: [error.localizedDescription, suggestion]))
        
        // Something went wrong. Ensure that your credentials are correct.
        // The user could also be offline, so be sure to handle this case appropriately.
        
        resetTransaction()
    }
    
    // MARK - SKAudioPlayerDelegate
    
    func audioPlayer(_ player: SKAudioPlayer!, willBeginPlaying audio: SKAudio!) {
        log("willBeginPlaying")
        
        // The TTS Audio will begin playing.

        state = .playing
        self.toggleTtsButton?.setTitle("pause", for: UIControlState())
    }
    
    func audioPlayer(_ player: SKAudioPlayer!, didFinishPlaying audio: SKAudio!) {
        log("didFinishPlaying")
        
        // The TTS Audio has finished playing.

        state = .idle
        resetTransaction()
    }
    
    // MARK: - Other Actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = event?.allTouches?.first
        if (languageTextView!.isFirstResponder && touch!.view != languageTextView) {
            languageTextView!.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func useLanguage(_ sender: UITextField) {
        language = sender.text
    }
    
    @IBAction func clearLogs(_ sender: UIButton) {
        logTextView!.text = ""
    }
    
    //MARK - Helpers
    
    func log(_ message: String) {
        logTextView!.text = logTextView!.text.appendingFormat("%@\n", message)
    }
    
    func resetTransaction() {
        OperationQueue.main.addOperation({
            self.skTransaction = nil
            self.toggleTtsButton?.setTitle("speakString", for: UIControlState())
        })
    }
}
