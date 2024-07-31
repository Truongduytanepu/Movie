//
//  Frame3.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/04/2024.
//

import Foundation
import UIKit

struct Frame3: BaseFrame {
    var background: AppImage.ImageName = .frame3

    var camera = ComponentLocation(x: 0, y: 10, width: 375, height: 500, rotationAngle: 0)

    var poster = ComponentLocation(x: 229, y: 336, width: 136, height: 104, rotationAngle: 0.0)

    var secondPoster: ComponentLocation? = ComponentLocation(x: 21.95, y: 54.83, width: 56.35, height: 68.48, rotationAngle: 0.0)

    var title = LabelProperties(font: AppFont.get(fontName: .utmavoBold, size: 24),
                                textColor: UIColor(rgb: 0xFFFFFF),
                                location: ComponentLocation(x: 21.5, y: 455.5, width: 278, height: 35, rotationAngle: 0.0), numberOfLines: 1)

    var secondTitle: LabelProperties? = nil

    var date = LabelProperties(font: AppFont.get(fontName: .poppinsRegular, size: 10),
                               textColor: UIColor(rgb: 0x000000),
                               location: ComponentLocation(x: -300 + 9 + 18 + 20, y: 0, width: 600, height: 18.0, rotationAngle: 90.0), numberOfLines: 1)

    var address = LabelProperties(font: AppFont.get(fontName: .montserrat, size: 12),
                                  textColor: UIColor(rgb: 0x000000),
                                  location: ComponentLocation(x: 36.3, y: 41, width: 282.33, height: 32, rotationAngle: 0.0), numberOfLines: 1)
}

