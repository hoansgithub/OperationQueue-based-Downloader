//
//  FlexibleVideoLayer.swift
//  BackgroundTransferServiceExam
//
//  Created by Hoan Nguyen on 9/8/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
class FlexibleVideoLayer: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
