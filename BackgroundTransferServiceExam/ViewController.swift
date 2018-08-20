//
//  ViewController.swift
//  BackgroundTransferServiceExam
//
//  Created by Hoan Nguyen on 9/6/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
class ViewController: UIViewController {
    @IBOutlet weak var tblFile: UITableView!

    var filesToDownload = [FileDownloadInfo]()
    var downloadQueue = OperationQueue()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblFile.register(UINib(nibName: "DownloadItemCell", bundle: nil), forCellReuseIdentifier: "DownloadItemCell")
        tblFile.dataSource = self
        tblFile.delaysContentTouches = false
        for case let scrollView as UIScrollView in tblFile.subviews {
            scrollView.delaysContentTouches = false
        }
        //init data
        downloadQueue.maxConcurrentOperationCount = 2
        
        filesToDownload.append(FileDownloadInfo(fileTitle: "iOS Programming Guide", downloadResource: "http://www.sample-videos.com/video/mp4/240/big_buck_bunny_240p_30mb.mp4"))
        filesToDownload.append(FileDownloadInfo(fileTitle: "Human Interface Guidelines", downloadResource: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"))
        filesToDownload.append(FileDownloadInfo(fileTitle: "Networking Overview", downloadResource: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"))
        filesToDownload.append(FileDownloadInfo(fileTitle: "AV Foundation", downloadResource: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"))
        filesToDownload.append(FileDownloadInfo(fileTitle: "iPhone User Guide", downloadResource: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"))
    }

    @IBAction func didTapBtnDownloadAll(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapBtnPauseAll(_ sender: UIButton) {
        
    }
    
}


extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filesToDownload.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadItemCell", for: indexPath) as! DownloadItemCell
        
        if indexPath.row < self.filesToDownload.count {
            let downloadItem = filesToDownload[indexPath.row]
            cell.delegate = nil
            cell.lblTitle.text = downloadItem.state.rawValue
            if downloadItem.state == .downloading {
                cell.btnStartPause.setTitle("P", for: .normal)
            }
            else {
                cell.btnStartPause.setTitle("S", for: .normal)
            }
            
            cell.progressView.progress = downloadItem.downloadProgress
            cell.indexPath = indexPath
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

extension ViewController : DownloadItemCellDelegate {
    
    func didTapBtnCancel(cell: DownloadItemCell, indexPath: IndexPath) {
        if indexPath.row < filesToDownload.count {
            let item = filesToDownload[indexPath.row]
            if item.state == .downloading {
                item.downloadRequest.cancel()
            }
        }
    }
    
    func didTapBtnStartPause(cell: DownloadItemCell, indexPath: IndexPath) {
        if indexPath.row < filesToDownload.count {
            let item = filesToDownload[indexPath.row]
            if item.state == .completed {
                
                if let fileURL = item.getFileURL() {
                    let vidController = VidViewController(nibName: "VidViewController", bundle: nil)
                    vidController.asset = AVAsset(url: fileURL)
                    self.navigationController?.pushViewController(vidController, animated: true)
                }
                
                return
            }
            
            if item.state == .downloading {
                //suppend
                item.downloadRequest.suspend()
            }
            else {
                //enqueue
                item.delegate = self
                if item.taskResumeData != nil {
                    item.downloadRequest = Alamofire.download(resumingWith: item.taskResumeData!, to: item.destination)
                }
                
                let op = DownloadOperation(fileDownloadInfo: item)
                downloadQueue.addOperation(op)
                item.state = .pending
            }
        }
    }
}

extension ViewController : FileDownloadInfoDelegate {
    func didUpdateInfo(fileDownloadInfo: FileDownloadInfo) {
        if let index =  filesToDownload.index(of: fileDownloadInfo) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tblFile.cellForRow(at: indexPath) as? DownloadItemCell {
                if cell.indexPath == indexPath {
                    cell.lblTitle.text = fileDownloadInfo.state.rawValue
                    if fileDownloadInfo.state == .downloading {
                        cell.btnStartPause.setTitle("P", for: .normal)
                    }
                    else {
                        cell.btnStartPause.setTitle("S", for: .normal)
                    }
                    
                    cell.progressView.progress = fileDownloadInfo.downloadProgress
                }
            }
        }
    }
}


