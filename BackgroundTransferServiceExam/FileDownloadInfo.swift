//
//  FileDownloadInfo.swift
//  BackgroundTransferServiceExam
//
//  Created by Hoan Nguyen on 9/6/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

import UIKit
import Alamofire
enum DownloadState : String{
    case none = "READY TO DOWNLOAD"
    case pending = "PENDING"
    case downloading = "DOWNLOADING"
    case paused = "PAUSED"
    case completed = "COMPLETED"
    case error = "ERROR"
}

protocol FileDownloadInfoDelegate : class {
    func didUpdateInfo(fileDownloadInfo : FileDownloadInfo)
}

class FileDownloadInfo: NSObject {
    
    weak var delegate : FileDownloadInfoDelegate?
    var destination: DownloadRequest.DownloadFileDestination
    var fileTitle : String
    var downloadResource : String
    var downloadRequest : DownloadRequest
    var taskResumeData : Data?
    var downloadProgress : Float{
        didSet {
            DispatchQueue.main.async {
                if (self.delegate != nil) {
                    self.delegate?.didUpdateInfo(fileDownloadInfo: self)
                }
            }
        }
    }
    
    var state : DownloadState{
        didSet {
            if state == .completed {
                taskResumeData = nil
            }
            DispatchQueue.main.async {
                if (self.delegate != nil) {
                    self.delegate?.didUpdateInfo(fileDownloadInfo: self)
                }
            }
        }
    }
    
    var taskIdentifier : CLong
    init(fileTitle : String, downloadResource : String) {
        
        self.fileTitle = fileTitle
        
        self.destination = { _, _ in
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                        .userDomainMask, true)[0]
                let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
                let fileURL = documentsURL.appendingPathComponent(fileTitle+"tmpdata.mp4")
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        self.downloadResource = downloadResource
        self.downloadRequest = Alamofire.download(downloadResource, to: self.destination)
        self.taskIdentifier = -1
        self.downloadProgress = 0.0
        self.state = .none
    }
    
    func getFileURL() -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
        let fileURL = documentsURL.appendingPathComponent(fileTitle+"tmpdata.mp4")
        return fileURL
    }
}
