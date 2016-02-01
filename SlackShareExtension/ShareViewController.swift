//
//  ShareViewController.swift
//  SlackShareExtension
//
//  Created by Steven Masuch on 2015-09-21.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Cocoa
import QuickLook
import SlackShareFramework

class ShareViewController: NSViewController, ShareNavigator {
    
    var authWindow: OAuthWindow?
    var authViewController: OAuthViewController?
    @IBOutlet var shareView: FileShareView?
    var presenter: SharePresenter?

    override var nibName: String? {
        return "ShareViewController"
    }

    override func loadView() {
        super.loadView()
        
        // Create the presenter & interactor, and wire them together
        presenter = SharePresenter(creatingNavigator:self)
        presenter?.shareView = shareView
        
        // Insert code here to customize the view
        let item = self.extensionContext!.inputItems[0] as! NSExtensionItem
        if let attachments = item.attachments {
            NSLog("Attachments = %@", attachments as NSArray)
            let firstAttachment = attachments[0] as! NSItemProvider;
            firstAttachment.loadItemForTypeIdentifier("public.file-url", options: nil) {(itemData, error) in
                NSLog("We got to the first attachment")
                if let url = itemData as? NSURL {
                    self.presenter?.interactor.fileURL = url
                }
            }
            
        } else {
            NSLog("No Attachments")
        }
    }
    
    @IBAction func openWebView(sender: AnyObject?) {
        authViewController = OAuthViewController.newAuthVC()
        authViewController?.navigator = self
        authViewController?.authURL = NSURL(string: "https://slack.com/oauth/authorize?client_id=2152506032.4191239709&state=AAAAA")
        authViewController?.view.frame = self.view.bounds
        self.view.addSubview(authViewController!.view);
    }

    @IBAction func send(sender: AnyObject?) {
        presenter?.share()
    }

    @IBAction func cancel(sender: AnyObject?) {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequestWithError(cancelError)
    }
    
    func presentAuthenticationView() {
        openWebView(nil)
    }
    
    func authenticationViewCompleted(token: String) {
        presenter?.interactor.authTokenRecieved(token)
        dispatch_async(dispatch_get_main_queue()) {
            self.authViewController?.view.removeFromSuperview()
        }
    }
    
    func sharingComplete() {
        let outputItem = NSExtensionItem()
        // Complete implementation by setting the appropriate value on the output item
        
        let outputItems = [outputItem]
        // Close the extension
        self.extensionContext!.completeRequestReturningItems(outputItems, completionHandler: nil)
    }

}
