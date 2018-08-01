//
//  SpeechHelper.swift
//  QRCodesReader
//
//  Created by lynx on 31/07/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import Foundation
import Speech

class SpeachHelper: NSObject, AVSpeechSynthesizerDelegate{
    var rate: Float = 0.5
    var completion: (()->Void)?
    var languageCode = Locale.current.languageCode
    
    func performSpeech(text: String){
        let utterance = AVSpeechUtterance(string: text)
        
        // Slow down the rate
        let rateRange = AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate + rateRange * rate
        
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        synthesizer.speak(utterance)
    }
    
    static func speakString(_ string: String, withCompletion completion: @escaping ()->Void){
        let helper = SpeachHelper()
        helper.completion = completion
        helper.performSpeech(text: string)
    }
    
    func speakString(_ string: String, withCompletion completion: @escaping ()->Void){
        self.completion = completion
        self.performSpeech(text: string)
    }
    
    func speakString(_ string: String, languageCode: String, withCompletion completion: @escaping ()->Void) throws{
        if Locale.availableIdentifiers.first(where: {$0.lowercased() == languageCode.lowercased()}) != nil{
            self.languageCode = languageCode
        }else{
            throw SpeekError.LanguageIsNotSupported
        }
        
        self.completion = completion
        self.performSpeech(text: string)
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        completion?()
    }
    
    enum SpeekError: Error{
        case LanguageIsNotSupported
    }
}
