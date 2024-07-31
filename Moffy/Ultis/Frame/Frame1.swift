//
//  Frame1.swift
//  Moffy
//
//  Created by Trương Duy Tân on 18/04/2024.
//

import Foundation
import UIKit

struct Frame1: BaseFrame {
    var background: AppImage.ImageName = .frame1

    var camera = ComponentLocation(x: 0, y: 10, width: 375, height: 500, rotationAngle: 0)

    var poster = ComponentLocation(x: 226.5, y: 353, width: 109, height: 144, rotationAngle: 0.0)

    var secondPoster: ComponentLocation? = ComponentLocation(x: 21.95, y: 54.83, width: 56.35, height: 68.48, rotationAngle: 0.0)

    var title = LabelProperties(font: AppFont.get(fontName: .reenieBeanie, size: 32),
                                textColor: UIColor(rgb: 0x744E30),
                                location: ComponentLocation(x: 36.3, y: 47, width: 282.33, height: 32, rotationAngle: 0.0), numberOfLines: 2, textAlignment: .center)

    var secondTitle: LabelProperties? = nil

    var date = LabelProperties(font: AppFont.get(fontName: .poppinsRegular, size: 10),
                               textColor: UIColor(rgb: 0x000000),
                               location: ComponentLocation(x: -110, y: 95, width: 350.0, height: 38.0, rotationAngle: 90.0), numberOfLines: 1)

    var address = LabelProperties(font: AppFont.get(fontName: .poppinsRegular, size: 10),
                                  textColor: UIColor(rgb: 0x000000),
                                  location: ComponentLocation(x: -130, y: 95, width: 350.0, height: 100, rotationAngle: 90.0), numberOfLines: 2)
}
