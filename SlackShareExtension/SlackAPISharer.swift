//
//  SlackAPIConnection.swift
//  SlackShare
//
//  Created by Steven Masuch on 2015-09-21.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Cocoa

protocol SlackAPISharerDelegate {
    
}

public class SlackAPISharer: NSObject, NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDelegate {
    
    var session: NSURLSession?
    var uploadData: NSMutableData?
    var delegate: SlackAPISharerDelegate?
    var token: String?
    
    public override init() {
        uploadData = NSMutableData()
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("background-thing")
        config.sharedContainerIdentifier = "group.com.zanopan.slackshare"
        super.init()
        session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        uploadData!.appendData(data)
    }

    
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        NSLog("Session completed a task...")

    }
    
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        NSLog("Sent \(totalBytesSent) of \(totalBytesExpectedToSend)")
    }
    
    func uploadFile(url: NSURL, channelID: String) {
        uploadData = NSMutableData()
        
        let uploadRequest = NSMutableURLRequest(URL: NSURL(string: "https://slack.com/api/files.upload?token=" + token! + "&channels=" + channelID)!)
        uploadRequest.HTTPMethod = "POST"

        uploadRequest.setValue("multipart/form-data", forHTTPHeaderField: "enctype")
        
        let boundary = "0xKhTmLbOuNdArY"
        let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        
        let contentType = "multipart/form-data; charset=\(charset); boundary=\(boundary)"
        uploadRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")

        let tempPostData = NSMutableData()
        tempPostData.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        tempPostData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"testfile\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        tempPostData.appendData("Content-Type: application/octet-stream\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        tempPostData.appendData(NSData(contentsOfURL: url)!)
        tempPostData.appendData("\r\n--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    
        uploadRequest.HTTPBody = tempPostData;
        
        let uploadTask = session?.dataTaskWithRequest(uploadRequest);
        
        uploadTask?.resume()
    }
    
    func sendText(text: String) {
        
    }
    
}
