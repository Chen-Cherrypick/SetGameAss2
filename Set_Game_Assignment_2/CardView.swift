//
//  CardView.swift
//  Set_Game_Assignment_2
//
//  Created by Chen Shoresh on 30/06/2021.
//

import UIKit

class CardView: UIView {
    
    
    var color: String = "pink" {
        didSet {
            switch color {
            case "pink": colorUI = UIColor.systemPink
            case "purple": colorUI = UIColor.purple
            case "grey": colorUI = UIColor.gray
            default: break
            }}
    }
    var shading: String = "solid" {
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }
    var shape: String = "◼︎" {
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }
    var text: String = "" {
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }
    var number: String = "one" { didSet {
        switch number {
        case "one": text = "\(shape)"
        case "two": text = "\(shape)\(shape)"
        case "three": text = "\(shape)\(shape)\(shape)"
        default: break
        }
    }}
    
    var label: UILabel = .init()
    
    
    var colorUI : UIColor = UIColor.black {
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }
    
    var isSelected:Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var isMatched: Bool? = nil { didSet { setNeedsDisplay(); setNeedsLayout() } }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(label)
        
        label.textAlignment = .center
        label.text = text
        label.attributedText = getAttributes(withColor: colorUI, withText: text)
        label.minimumScaleFactor = 100/UIFont.labelFontSize
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.frame = bounds.inset(by: UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0))
        
        configureState()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    
    private func getAttributes(withColor color: UIColor, withText text: String) -> NSAttributedString {
        
        var attributes: [NSAttributedString.Key : Any] = [:]
        switch self.shading {
        case "open":
            attributes[.foregroundColor] = color
            attributes[.strokeWidth] = 5
        case "stripped":
            attributes[.foregroundColor] = color.withAlphaComponent(0.15)
            attributes[.strokeWidth] = -1
        case "solid":
            attributes[.foregroundColor] = color
            attributes[.strokeWidth] = -1
        default:
            attributes[.foregroundColor] = color
            attributes[.strokeWidth] = 5
        }
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    private func configureState() {
        backgroundColor = #colorLiteral(red: 0.9561466575, green: 0.9503033757, blue: 0.8274206519, alpha: 1)
        isOpaque = false
        contentMode = .redraw
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 5.0
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        if isSelected {          // highlight selected card view
            layer.borderColor = Colors.pink.cgColor
        }  else {
//             pinLabel.isHidden = true
        }
        if let matched = isMatched { // highlight matched 3 cards
//            pinLabel.isHidden = false
            if matched {
                layer.borderColor = Colors.green.cgColor
            } else {
                layer.borderColor = Colors.red.cgColor
            }
        }
    }
    
    struct Colors {
        static let red = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        static let green = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        static let peach = #colorLiteral(red: 1, green: 0.7970929146, blue: 0.784461081, alpha: 1)
        static let pink = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    }
    
}


extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
