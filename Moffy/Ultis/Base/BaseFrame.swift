//
//  BaseFrame.swift
//  Moffy
//
//  Created by Trương Duy Tân on 18/04/2024.
//

import UIKit

protocol BaseFrame {
    var background: AppImage.ImageName { get }
    var camera: ComponentLocation { get }
    var poster: ComponentLocation { get }
    var secondPoster: ComponentLocation? { get }
    var title: LabelProperties { get }
    var secondTitle: LabelProperties? { get }
    var date: LabelProperties { get }
    var address: LabelProperties { get }
}
