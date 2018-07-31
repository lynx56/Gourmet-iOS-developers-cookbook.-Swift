import Foundation
import Speech
import PlaygroundSupport

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

let helper = SpeachHelper()
try! helper.speakString("Бедных людей удовлетворить труднее всего. Дайте им что-то бесплатно, они решат, что это ловушка. Скажите им, что это лишь небольшая инвестиция, скажут - много не заработать. Скажите им вложиться по крупному, скажут что у них нет денег. Скажите им попробовать новые темы, скажут - нет опыта. Скажите им,что это традиционный бизнес, скажут что это тяжело. Скажите им, что это новая бизнес-модель, они скажут - пирамида . Скажите им, открыть магазин, скажут - нет свободы. Скажите им начать новый бизнес,скажут что нет доказательств что новый бизнес пойдет. Они имеют нечто общее: Любят запрашивать Google, слушаться друзей, таких же безнадежных, как и они сами, они пребывают в раздумьях больше, чем профессор университета и делают меньше чем слепой. Просто спросите их, что они могут? Они не ответят вам. Мой вывод: Вместо того, чтобы ваше сердце билось быстрее, почему бы просто не действовать немного быстрее; вместо того, чтобы просто пребывать в раздумьях, почему бы не сделать то, о чем вы думаете. Бедные люди терпят неудачи из-за одной общей черты: Их Вся Жизнь Проходит в Ожидании.", languageCode: "ru_ru"){
    DispatchQueue.main.async {
        print("Completed")
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true

