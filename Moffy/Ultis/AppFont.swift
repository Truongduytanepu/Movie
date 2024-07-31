//
//  AppFont.swift
//  SelfieDemo
//
//  Created by Trịnh Xuân Minh on 16/08/2022.
//

import UIKit

struct AppFont {
    enum FontName: String {
        case pompiereRegular = "Pompiere-Regular"
        case iCielBambola = "iCielBambola"
        case utmBebas = "UTM Bebas"
        case playballRegular = "Playball-Regular"
        case manaropeSemibold = "manrope-semibold"
        case manaropeRegular = "manrope-light"
        case manaropeMedium = "manrope-medium"
        case quicksandBold = "Quicksand-Bold"
        case quicksandRegular = "Quicksand-Regular"
        case quicksandSemiBold = "Quicksand-SemiBold"
        case reenieBeanie = "ReenieBeanie"
        case poppinsRegular = "Poppins-Regular"
        case poppinsBlack = "Poppins-Black"
        case utmavoBold = "UTMAvoBold"
        case montserrat = "Montserrat-Regular"
        case UTMCookies = "UTM-Cookies"
    }

    static func get(fontName: FontName, size: CGFloat) -> UIFont {
        return UIFont(name: fontName.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
