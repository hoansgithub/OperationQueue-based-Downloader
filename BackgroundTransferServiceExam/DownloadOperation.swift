//
//  DownloadOperation.swift
//  BackgroundTransferServiceExam
//
//  Created by Hoan Nguyen on 9/7/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

import UIKit

class DownloadOperation: Operation {
    var _executing: Bool = false
    var _finished : Bool = false
    weak var fileDownloadInfo : FileDownloadInfo?

    
    init(fileDownloadInfo : FileDownloadInfo) {
        self.fileDownloadInfo = fileDownloadInfo
    }
    
    override var isExecuting: Bool {
        get { return _executing }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isFinished: Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        self.fileDownloadInfo?.state = .downloading
        isExecuting = true
        fileDownloadInfo?.downloadRequest.downloadProgress { [weak self](progress) in
            self?.fileDownloadInfo?.downloadProgress = Float(progress.fractionCompleted)
        }.responseData {[weak self] (response) in
            
            switch response.result {
            case .success(let data) :
                self?.fileDownloadInfo?.taskResumeData = data
                self?.fileDownloadInfo?.state = .completed
                self?.fileDownloadInfo?.downloadProgress = 1.0
                self?.isExecuting = false
                self?.isFinished = true
                break
            case .failure(_):
                if response.response?.statusCode == 200 {
                    self?.fileDownloadInfo?.taskResumeData = response.resumeData
                    self?.fileDownloadInfo?.state = .paused
                }
                else {
                    self?.fileDownloadInfo?.state = .error
                    print(response.error.debugDescription)
                }
                
                self?.isExecuting = false
                self?.isFinished = true
                break
            }
            
            
        }
    }
    
    override func cancel() {
        fileDownloadInfo?.downloadRequest.cancel()
        super.cancel()
    }

    deinit {
        print(fileDownloadInfo?.fileTitle ?? "" + " ended")
    }
}
