import  UIKit
import PlaygroundSupport

extension UIView{
func shake(){
    let numbersShakes = 8
    
    let transform1 = CGAffineTransform(translationX: 2, y: -2)
    let transform2 = CGAffineTransform(translationX: -2, y: 2)
    let animationBlock = {
    for i in 0..<numbersShakes{
        let progress = Double(i) / Double(numbersShakes)
        let duration = 1.0 / Double(numbersShakes)
        UIView.addKeyframe(withRelativeStartTime: progress, relativeDuration: duration, animations: {
            self.transform = i%2 == 0 ? transform1 : transform2
        })
        UIView.addKeyframe(withRelativeStartTime: Double(numbersShakes - 1) / Double(numbersShakes), relativeDuration: 1.0 / Double(numbersShakes), animations: {
            self.transform = CGAffineTransform.identity
        })
    }}
    
    UIView.animateKeyframes(withDuration: 1, delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: 0), animations: animationBlock, completion: nil)
}
}

let origin = CGPoint(x: 50, y: 150)
let view = UIView(frame: CGRect(origin: origin, size: CGSize(width:50,height: 100)))

PlaygroundPage.current.liveView = view

view.backgroundColor = UIColor.blue

view.shake()

PlaygroundPage.current.needsIndefiniteExecution = true
