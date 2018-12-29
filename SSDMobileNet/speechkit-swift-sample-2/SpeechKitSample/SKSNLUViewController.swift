//
//  SKSNLUViewController.swift
//  SpeechKitSample
//
//  This Controller is built to demonstrate how to perform NLU (Natural Language Understanding).
//
//  This Controller is very similar to SKSASRViewController. Much of the code is duplicated for clarity.
//
//  NLU is the transformation of text into meaning.
//
//  When performing speech recognition with SpeechKit, you have a variety of options. Here we demonstrate
//  Detection Type and Language.
//
//  The Context Tag is assigned in the system configuration upon deployment of an NLU model.
//  Combined with the App ID, it will be used to find the correct NLU version to query.
//
//  Languages can also be configured. Supported languages can be found here:
//  http://dragonmobile.nuancemobiledeveloper.com/public/index.php?task=supportedLanguages
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

import UIKit
import SpeechKit

class SKSNLUViewController : UIViewController, UITextFieldDelegate, SKTransactionDelegate {
    
    // State Logic: IDLE -> LISTENING -> PROCESSING -> repeat
    enum SKSState {
        case idle
        case listening
        case processing
    }
    
    // User interface
    @IBOutlet weak var toggleRecogButton: UIButton?
    @IBOutlet weak var logTextView: UITextView?
    @IBOutlet weak var clearLogsButton: UIButton?
    @IBOutlet weak var endpointerTypeSegmentControl: UISegmentedControl?
    @IBOutlet weak var volumeLevelProgressView: UIProgressView?
    @IBOutlet weak var contextTagTextView: UITextField?
    @IBOutlet weak var languageTextView: UITextField?
    
    // Settings
    var language: String!
    var contextTag: String!
    var endpointer: SKTransactionEndOfSpeechDetection!
    
    var skSession:SKSession?
    var skTransaction:SKTransaction?
    
    var state = SKSState.idle
    
    var volumePollTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endpointer = .short
        language = LANGUAGE
        self.languageTextView!.text = language
        contextTag = SKSNLUContextTag
        self.contextTagTextView!.text = contextTag
        
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
        
        loadEarcons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func releaseServerResources() {
        if (state == .idle) {
            // Nothing to do since there is no ongoing recognition
        }
        else if (state == .listening) {
            // Ends the ongoing recording.
            stopRecording()
        }
        else if (state == .processing) {
            // Ends the ongoing recording and cancel the server recognition
            // This cancel request will generate an internal onError callback
            // even if the server returns a successful recognition.
            cancel()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - ASR Actions
    @IBAction func toggleRecognition() {
        switch state {
        case .idle:
            recognize()
        case .listening:
            stopRecording()
        case .processing:
            cancel()
        }
    }
    
    func recognize() {
        // Start listening to the user.
        toggleRecogButton?.setTitle("Stop", for: UIControlState())
        skTransaction = skSession!.recognize(withService: contextTag,
                                                        detection: endpointer,
                                                        language: language,
                                                        data: nil,
                                                        options: nil,
                                                        delegate: self)        
    }
    
    func stopRecording() {
        // Stop recording the user.
        skTransaction!.stopRecording()
        
        // Disable the button until we received notification that the transaction is completed.
        toggleRecogButton?.isEnabled = false
    }
    
    func cancel() {
        // Cancel the Reco transaction.
        // This will only cancel if we have not received a response from the server yet.
        skTransaction!.cancel()
    }
    
    // MARK: - SKTransactionDelegate
    
    func transactionDidBeginRecording(_ transaction: SKTransaction!) {
        log("transactionDidBeginRecording")
        
        state = .listening
        startPollingVolume()
        toggleRecogButton?.setTitle("Listening..", for: UIControlState())
    }
    
    func transactionDidFinishRecording(_ transaction: SKTransaction!) {
        log("transactionDidFinishRecording")
        
        state = .processing
        stopPollingVolume()
        toggleRecogButton?.setTitle("Processing..", for: UIControlState())
    }
    
    func transaction(_ transaction: SKTransaction!, didReceive recognition: SKRecognition!) {
        log(String(format: "didReceiveRecognition: %@", arguments: [recognition.text]))
    }
    
    func transaction(_ transaction: SKTransaction!, didReceiveServiceResponse response: [AnyHashable : Any]!) {
        log(String(format: "didReceiveServiceResponse: %@", arguments: [response]))

    }
    
    func transaction(_ transaction: SKTransaction!, didReceive interpretation: SKInterpretation!) {
        log(String(format: "didReceiveInterpretation: %@", arguments: [interpretation.result]))
        state = .idle
        resetTransaction()
    }
    
    func transaction(_ transaction: SKTransaction!, didFinishWithSuggestion suggestion: String) {
        log("didFinishWithSuggestion")
        
        state = .idle
        resetTransaction()
    }
    
    func transaction(_ transaction: SKTransaction!, didFailWithError error: Error!, suggestion: String) {
        log(String(format: "didFailWithError: %@. %@", arguments: [error.localizedDescription, suggestion]))
        
        // Something went wrong. Ensure that your credentials are correct.
        // The user could also be offline, so be sure to handle this case appropriately.
        
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
    
    @IBAction func selectEndpointerType(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if(index == 0){
            endpointer! = .long
        } else if (index == 1){
            endpointer! = .short
        } else if (index == 2){
            endpointer! = .none
        }
    }
    
    @IBAction func useNLUModel(_ sender: UITextField) {
        contextTag = sender.text
    }
    
    @IBAction func useLanguage(_ sender: UITextField) {
        language = sender.text
    }
    
    @IBAction func clearLogs(_ sender: UIButton) {
        logTextView!.text = ""
    }
    
    // MARK: - Volume level
    
    func startPollingVolume() {
        // Every 50 milliseconds we should update the volume meter in our UI.
        volumePollTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(SKSNLUViewController.pollVolume), userInfo: nil, repeats: true)
    }
    
    func pollVolume() {
        let volumeLevel = skTransaction!.audioLevel
        volumeLevelProgressView!.setProgress(volumeLevel / Float(100), animated: true)
    }
    
    func stopPollingVolume() {
        volumePollTimer!.invalidate()
        volumePollTimer = nil
        volumeLevelProgressView!.setProgress(Float(0), animated: true)
    }
    
    //MARK - Helpers
    
    func log(_ message: String) {
        logTextView!.text = logTextView!.text.appendingFormat("%@\n", message)
    }
    
    func resetTransaction() {
        OperationQueue.main.addOperation({
            self.skTransaction = nil
            self.toggleRecogButton?.setTitle("recognizeWithService", for: UIControlState())
            self.toggleRecogButton?.isEnabled = true
        })
    }
    
    func loadEarcons() {
        let startEarconPath = Bundle.main.path(forResource: "sk_start", ofType: "pcm")
        let stopEarconPath = Bundle.main.path(forResource: "sk_stop", ofType: "pcm")
        let errorEarconPath = Bundle.main.path(forResource: "sk_error", ofType: "pcm")
        let audioFormat = SKPCMFormat()
        audioFormat.sampleFormat = .signedLinear16
        audioFormat.sampleRate = 16000
        audioFormat.channels = 1
        
        skSession!.startEarcon = SKAudioFile(url: URL(fileURLWithPath: startEarconPath!), pcmFormat: audioFormat)
        skSession!.endEarcon = SKAudioFile(url: URL(fileURLWithPath: stopEarconPath!), pcmFormat: audioFormat)
        skSession!.errorEarcon = SKAudioFile(url: URL(fileURLWithPath: errorEarconPath!), pcmFormat: audioFormat)
    }
    
}
