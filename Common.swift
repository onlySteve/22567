//
//  Common.swift
//  BugWise
//
//  Created by olbu on 5/30/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import SVProgressHUD

func BoldFontWithSize(size: CGFloat = 15) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
}

func RegularFontWithSize(size: CGFloat = 15) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

struct CommonAppearance {
    static let greyColor = UIColor(netHex: 0xC8C7CC)
    static let lightGreyColor = UIColor(netHex: 0xECECEC)
    static let lightDarkColor = UIColor(netHex: 0x343434)
    static let redColor = UIColor(netHex: 0xEE5928)
    static let orangeColor = UIColor(netHex: 0xF7941F)
    static let blueColor = UIColor(netHex: 0x195FAE)
    static let lighBlueColor = UIColor(netHex: 0x1D74BC)
    static let yellowToOrangeColor = UIColor(netHex: 0xF28621)
    static let strongRedColor = UIColor(netHex: 0xEB1F05)
    
    static let boldGreyColor = UIColor(netHex: 0x8A8A8F)
}

struct CommonConstants {
    static let homeAlertsHeight: CGFloat = 200.0
    static let headerHeight: CGFloat = 200.0
    static let surveillanceHeaderHeight: CGFloat = 70.0
    static let surveillanceFooterHeight: CGFloat = 80.0
    static let duplicationsFooterHeight: CGFloat = 150.0
    static let interactionsFooterHeight: CGFloat = 240.0
    static let interactionsHeaderHeight: CGFloat = 180.0
}

struct NavigationBarAppearance {
    static let backgroundColor = UIColor(netHex: 0xF9F9F9)
    static let itemsColor = CommonAppearance.lighBlueColor
    
    static let textColor = UIColor.black
    static let font = BoldFontWithSize(size: 18)
    
    static let textAttributes: [String : Any] = [NSForegroundColorAttributeName: textColor, NSFontAttributeName: font]
}

struct TabBarAppearance {
    static let itemsColor = CommonAppearance.lighBlueColor
    static let backgroundColor = UIColor(netHex: 0xF9F9F9)
    static let font = RegularFontWithSize(size: 14)
    static let textAttributes: [String : Any] = [NSFontAttributeName: font]
}

struct ExternalURL {
    static let keyRequest = URL(string: "http://a-zmeds.com/pd-app-key-request-page/")
}


func openURL(_ url: URL?) {
    if let url = url, UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}


// A delay function
func delay(_ seconds: Double, completion: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(seconds * 1000.0))) {
        completion()
    }
}

func showHud() {
    SVProgressHUD.show()
}

func showHud(success:Bool = true, time: Double = 1.5, message: String = "", completion: voidBlock?) {
    UIApplication.shared.beginIgnoringInteractionEvents()
    success ? SVProgressHUD.showSuccess(withStatus: message) : SVProgressHUD.showError(withStatus: message)
    
    delay(time, completion: {
        hideHud()
        completion?()
    })
}

func hideHud() {
        SVProgressHUD.dismiss()
    if UIApplication.shared.isIgnoringInteractionEvents {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

