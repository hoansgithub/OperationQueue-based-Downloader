//
//  DownloadItemCell.swift
//  BackgroundTransferServiceExam
//
//  Created by Hoan Nguyen on 9/6/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

import UIKit
protocol DownloadItemCellDelegate : class{
    func didTapBtnCancel(cell : DownloadItemCell , indexPath : IndexPath )
    func didTapBtnStartPause(cell : DownloadItemCell , indexPath : IndexPath)
}
class DownloadItemCell: UITableViewCell {

    var indexPath : IndexPath?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnStartPause: UIButton!
    weak var delegate : DownloadItemCellDelegate?
    
    @IBAction func didTapBtnStartPause(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            self.delegate?.didTapBtnStartPause(cell: self, indexPath: indexPath)
        }
    }
    @IBAction func didTapBtnCancel(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            self.delegate?.didTapBtnCancel(cell: self, indexPath: indexPath)
        }
    }
    
}
