//
//  MyAlert.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 19.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import SwiftEntryKit
import QuickLayout
import ChameleonFramework

class MyAlert{
    static func show(title: String, description: String, buttonTxt: String){
        var attributes: EKAttributes
        attributes = .centerFloat
        attributes.windowLevel = .alerts
        attributes.hapticFeedbackType = .success
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.screenBackground = .color(color: UIColor(hexString: "#000000", withAlpha: 0.5))
        attributes.entryBackground = .color(color: UIColor.white.withAlphaComponent(0.98))
        attributes.entranceAnimation = .init(scale: .init(from: 0.9, to: 1, duration: 0.4, spring: .init(damping: 0.8, initialVelocity: 0)), fade: .init(from: 0, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(scale: .init(from: 1, to: 0.4, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)), fade: .init(from: 1, to: 0, duration: 0.2))
        attributes.displayDuration = .infinity
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont(name: "SFProDisplay-Regular", size: 30)!, color: UIColor.flatMagenta(), alignment: .center))
        let description = EKProperty.LabelContent(text: description, style: .init(font: UIFont(name: "SFProDisplay-Regular", size: 20)!, color: UIColor.flatMagenta(), alignment: .center))
        let button = EKProperty.ButtonContent(label: .init(text: buttonTxt, style: .init(font: UIFont(name:"SFProDisplay-Regular" , size: 20)!, color: UIColor.flatWhite())), backgroundColor: UIColor.flatMagenta(), highlightedBackgroundColor: UIColor.black)
        
        let message = EKPopUpMessage(themeImage: nil, title: title, description: description, button: button) {
            SwiftEntryKit.dismiss()
        }
        
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

