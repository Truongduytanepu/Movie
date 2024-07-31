//
//  Frame5.swift
//  Moffy
//
//  Created by Trương Duy Tân on 24/04/2024.
//

import Foundation
import UIKit

struct Frame5: BaseFrame {
    var background: AppImage.ImageName = .frame5

    var camera = ComponentLocation(x: 0, y: 10, width: 375, height: 500, rotationAngle: 0)

    var poster = ComponentLocation(x: 207, y: 352, width: 160, height: 114, rotationAngle: 0)

    var secondPoster: ComponentLocation? = ComponentLocation(x: 21.95, y: 54.83, width: 56.35, height: 68.48, rotationAngle: 0.0)

    var title = LabelProperties(font: AppFont.get(fontName: .UTMCookies, size: 32),
                                textColor: UIColor(rgb: 0xFFA138),
                                location: ComponentLocation(x: 17, y: 375, width: 148, height: 50, rotationAngle: 0.0), numberOfLines: 1)

    var secondTitle: LabelProperties? = nil

    var date = LabelProperties(font: AppFont.get(fontName: .poppinsRegular, size: 10),
                               textColor: UIColor(rgb: 0x000000),
                               location: ComponentLocation(x: -300 + 9 + 18 + 20, y: 0, width: 600, height: 18.0, rotationAngle: 90.0), numberOfLines: 1)

    var address = LabelProperties(font: AppFont.get(fontName: .UTMCookies, size: 12),
                                  textColor: UIColor(rgb: 0xFFA138),
                                  location: ComponentLocation(x: 17, y: 435, width: 184, height: 16, rotationAngle: 0.0), numberOfLines: 1)
}


