//
//  OAuthWindow.swift
//  SlackShare
//
//  Created by Steven Masuch on 2015-10-06.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Cocoa
import WebKit

public class OAuthWindow: NSWindowController, WebFrameLoadDelegate {
    
    @IBOutlet var webView: WebView?
    public var authURL: NSURL?
    weak var teamDataSource: SlackAPITeamDataSource?
    var session : NSURLSession?
    var navigator: ShareNavigator?
    
    public override func windowDidLoad() {
        super.windowDidLoad()
        
        if (authURL != nil) {
            // Let's see if this works...
            webView?.frameLoadDelegate = self
            webView?.mainFrameURL = authURL?.absoluteString
        }
    }
    
    public func webView(sender: WebView!, didStartProvisionalLoadForFrame frame: WebFrame!) {
        NSLog("Data source from provinsional load??? : %@", frame.dataSource!.initialRequest)
    }
    
    public func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
        NSLog("Data source??? : %@", frame.dataSource!.request)
        
        if let queryString = frame.dataSource?.request.URL?.query
        {
            let components = queryString.componentsSeparatedByString("&")
            func isCodeParameter(parameter: String) -> Bool {
                return parameter.hasPrefix("code")
            }
            let codeParameters = components.filter(isCodeParameter)
            if let firstCodeParameter = codeParameters.first {
                if let code = firstCodeParameter.componentsSeparatedByString("=").last {
                    getAuthTokenFromCode(code)
                }
            }
        }
    }
    
    public func getAuthTokenFromCode(code: String)
    {
        // Open a connection
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        session = NSURLSession(configuration: configuration)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://slack.com/api/oauth.access")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "code=\(code)&client_secret=a7cff0c17b3d3f05d92ea6d1719ad958&client_id=2152506032.4191239709".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let task = session?.dataTaskWithRequest(request) {
            data, response, error in
            if (error == nil) {
                if let responseJSON = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) {
                    print(responseJSON)
                    if let authToken = responseJSON["access_token"] as? String {
                        self.navigator?.authenticationViewCompleted(authToken)
                    }
                }
                
            }
        }
        task?.resume()
    }

    
}
