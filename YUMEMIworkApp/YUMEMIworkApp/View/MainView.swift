//
//  MainView.swift
//  YUMEMIworkApp
//
//  Created by Daichi Hayashi on 2020/02/04.
//  Copyright © 2020 Daichi Hayashi. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

class CustomHUDView: PKHUDSquareBaseView {

    override init(image: UIImage?, title: String?, subtitle: String?) {
        super.init(image: image, title: title, subtitle: subtitle)

        titleLabel.textColor = UIColor.lightGray
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
