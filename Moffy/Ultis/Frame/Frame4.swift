//
//  Frame4.swift
//  Moffy
//
//  Created by Trương Duy Tân on 26/04/2024.
//

import Foundation
import UIKit

struct Frame4: BaseFrame {
    var background: AppImage.ImageName = .frame4

    var camera = ComponentLocation(x: 0, y: 10, width: 375, height: 500, rotationAngle: 0)

    var poster = ComponentLocation(x: 261.92, y: 307.53, width: 96, height: 150, rotationAngle: -8.43)

    var secondPoster: ComponentLocation? = ComponentLocation(x: 21.95, y: 54.83, width: 56.35, height: 68.48, rotationAngle: 0.0)

    var title = LabelProperties(font: UIFont(name: "Times New Roman", size: 32) ?? UIFont.systemFont(ofSize: 32),
                                textColor: UIColor(rgb: 0x671B00),
                                location: ComponentLocation(x: 20, y: 434.38, width: 201, height: 37, rotationAngle: 0.0), numberOfLines: 1)

    var secondTitle: LabelProperties? = nil

    var date = LabelProperties(font: AppFont.get(fontName: .poppinsRegular, size: 10),
                               textColor: UIColor(rgb: 0x000000),
                               location: ComponentLocation(x: -300 + 9 + 18 + 20, y: 0, width: 600, height: 18.0, rotationAngle: 90.0), numberOfLines: 1)

    var address = LabelProperties(font: UIFont(name: "Times New Roman", size: 12) ?? UIFont.systemFont(ofSize: 12),
                                  textColor: UIColor(rgb: 0x671B00),
                                  location: ComponentLocation(x: 20, y: 470, width: 193, height: 37, rotationAngle: 0.0), numberOfLines: 1)
}



