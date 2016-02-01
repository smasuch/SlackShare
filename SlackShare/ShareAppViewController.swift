//
//  ShareAppViewController.swift
//  SlackShare
//
//  Created by Steven Masuch on 2015-10-12.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Foundation
import AppKit
import SlackShareFramework

class ShareAppViewController: NSViewController
{
    @IBOutlet var channelsTableView: NSTableView?
    @IBOutlet var messageTextView: NSTextView?
    @IBOutlet var imageWell: NSImageView?
    @IBOutlet var channelMenu: NSMenu?
    var authController: OAuthWindow?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @IBAction func addNewTeam(sender: AnyObject?)
    {
        authController = OAuthWindow(windowNibName: "OAuthWindow")
        authController?.authURL = NSURL(string: "https://slack.com/oauth/authorize?client_id=2152506032.4191239709&state=AAAAA")
        authController?.showWindow(nil)
    }
    
    @IBAction func selectTeam(sender: AnyObject?)
    {
        
    }
    
    @IBAction func share(sender: AnyObject?)
    {
        
    }
    
}