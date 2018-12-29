//
//  TextToSpeech.swift
//  Dragon_Speech
//
//  Created by Kim Do on 11/12/18.
//  Copyright © 2018 Kim Do. All rights reserved.
//

import Foundation
import AVFoundation

class TextToSpeech {
   var utterance   : AVSpeechUtterance
   let synthesizer : AVSpeechSynthesizer

   init() {
      utterance       = AVSpeechUtterance(string: "")
      synthesizer = AVSpeechSynthesizer()
   }
   
   func speak(text : String){
      utterance       = AVSpeechUtterance(string: text)
      utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
      utterance.rate  = 0.5
      
      synthesizer.speak(utterance)
   }
}
