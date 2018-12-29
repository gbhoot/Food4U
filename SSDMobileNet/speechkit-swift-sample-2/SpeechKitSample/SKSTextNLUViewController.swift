//
//  SKSTextNLUViewController.swift
//  SpeechKitSample
//
//  This Controller is built to demonstrate how to perform NLU (Natural Language
//  Understanding) with text input instead of voice.
//
//  This Controller is very similar to SKSNLUViewController. Much of the code is duplicated
//  for clarity.
//
//  NLU is the transformation of text into meaning.
//
//  When performing speech recognition with SpeechKit, you have a variety of options. Here we
//  demonstrate Model ID and Language.
//
//  The Context Tag is assigned in the system configuration upon deployment of an NLU model.
//  Combined with the App ID, it will be used to find the correct NLU version to query.
//
//  Languages can be configured. Supported languages can be found here:
//  http://developer.nuance.com/public/index.php?task=supportedLanguages
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

import UIKit
import SpeechKit

class SKSTextNLUViewController : UIViewController, UITextFieldDelegate, SKTransactionDelegate {
    
    // State Logic: IDLE -> PROCESSING -> repeat
    enum SKSState {
        case idle
        case processing
    }
    
    // User interface
    @IBOutlet weak var toggleRecogButton: UIButton?
    @IBOutlet weak var logTextView: UITextView?
    @IBOutlet weak var clearLogsButton: UIButton?
    @IBOutlet weak var contextTagTextView: UITextField?
    @IBOutlet weak var languageTextView: UITextField?
    @IBOutlet weak var textInputTextView: UITextField?
    
    // Settings
    var language: String!
    var contextTag: String!
    var textInput: String!
    
    var skSession:SKSession?
    var skTransaction:SKTransaction?
    
    var state = SKSState.idle
    
    var volumePollTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: - ASR Actions
    @IBAction func toggleRecognition() {
        switch state {
        case .idle:
            recognize()
        default:
            break
        }
    }
    
    func recognize() {
        // Start listening to the user.
        toggleRecogButton?.setTitle("Stop", for: UIControlState())
        
        // Set appserver data
        let keys = ["text", "message"]
        let objects = [textInput as AnyObject, textInput as AnyObject] as [AnyObject]
        let data = NSDictionary(objects: objects, forKeys: keys as [NSCopying])
        
        skTransaction = skSession!.transaction(withService: contextTag,
                                                          language: language,
                                                          data: data as [NSObject : AnyObject],
                                                          options: nil,
                                                          delegate: self)
    }
    
    // MARK: - SKTransactionDelegate
    
    
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
    
    @IBAction func useNLUModel(_ sender: UITextField) {
        contextTag = sender.text
    }
    
    @IBAction func useLanguage(_ sender: UITextField) {
        language = sender.text
    }
    
    @IBAction func useTextInput(_ sender: UITextField) {
        textInput = sender.text
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
            self.toggleRecogButton?.setTitle("recognizeWithService", for: UIControlState())
            self.toggleRecogButton?.isEnabled = true
        })
    }
}
