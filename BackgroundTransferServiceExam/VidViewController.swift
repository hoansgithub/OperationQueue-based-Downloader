//
//  VidViewController.swift
//  BackgroundTransferServiceExam
//
//  Created by Hoan Nguyen on 9/8/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
class VidViewController: UIViewController {
    @IBOutlet weak var playerView: FlexibleVideoLayer!
    private (set) var player = AVPlayer()
    var asset:AVAsset?
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let superLayer = playerView.layer as? AVPlayerLayer
        {
            superLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            superLayer.player = player
        }
        loadVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if ( player.currentItem != nil) {
            player.pause()
            player.replaceCurrentItem(with: nil)
        }
    }
    
    func loadVideo() {
        if let mAsset = asset {
            mAsset.loadValuesAsynchronously(forKeys: ["duration"], completionHandler: { [weak self] in
                let item = AVPlayerItem(asset: mAsset)
                self?.player.replaceCurrentItem(with: item)
                self?.player.play()
            })
        }
    }

    
    deinit {
        print("Vid deinit")
    }
}
