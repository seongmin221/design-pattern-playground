//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport


class ButtonBuilder {
    
    private let baseButton = UIButton()
    
    func setSize(to size: CGSize) -> ButtonBuilder {
        self.baseButton.frame.size = size
        return self
    }
    
    func setBackground(to color: UIColor) -> ButtonBuilder {
        self.baseButton.backgroundColor = color
        return self
    }
    
    func setCornerRadius(to radius: CGFloat) -> ButtonBuilder {
        self.baseButton.layer.masksToBounds = true
        self.baseButton.layer.cornerRadius = 15
        return self
    }
        
    func returnResult() -> UIButton {
        return self.baseButton
    }
}


class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        
        
        let builtButton = ButtonBuilder()
            .setSize(to: .init(width: 50, height: 50))
            .setBackground(to: .systemBlue)
            .setCornerRadius(to: 15)
            .returnResult()
        
        
        
        view.addSubview(builtButton)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
