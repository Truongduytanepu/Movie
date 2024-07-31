//
//  Frame2.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/04/2024.
//

import Foundation
import UIKit

struct Frame2: BaseFrame {
    var background: AppImage.ImageName = .frame2
    
    var camera = ComponentLocation(x: 0, y: 10, width: 375, height: 500, rotationAngle: 0)
    
    var poster = ComponentLocation(x: 42, y: 274, width: 190, height: 111, rotationAngle: 0)
    
    var secondPoster: ComponentLocation? = ComponentLocation(x: 21.95, y: 54.83, width: 56.35, height: 68.48, rotationAngle: 0.0)
    
    var title = LabelProperties(font: AppFont.get(fontName: .poppinsBlack, size: 32),
                                textColor: UIColor(rgb: 0xECFCFF),
                                location: ComponentLocation(x: 23, y: 387, width: 350, height: 100, rotationAngle: 0.0), numberOfLines: 2,
                                textBorder: (color: .red, width: 10.0))
    
    var secondTitle: LabelProperties? = nil
    
    var date = LabelProperties(font: AppFont.get(fontName: .poppinsRegular, size: 10),
                               textColor: UIColor(rgb: 0x000000),
                               location: ComponentLocation(x: -70, y: 95, width: 220, height: 38.0, rotationAngle: 90.0), numberOfLines: 1)
    
    var address = LabelProperties(font: AppFont.get(fontName: .poppinsRegular, size: 10),
                                  textColor: UIColor(rgb: 0x000000),
                                  location: ComponentLocation(x: -60, y: 95, width: 220, height: 38.0, rotationAngle: 90.0), numberOfLines: 2)
}
