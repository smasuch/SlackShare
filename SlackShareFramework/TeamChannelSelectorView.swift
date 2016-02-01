//
//  TeamChannelSelectorView.swift
//  SlackShare
//
//  Created by Steven Masuch on 2015-10-23.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Foundation
import AppKit

class TeamChannelSelectorView: NSView, NSTableViewDataSource
{
    @IBOutlet var teamMenu: NSPopUpButton?
    @IBOutlet var channelTable: NSTableView?
    
    var channelNames: Array<String> {
        didSet {
            channelTable?.reloadData()
            channelTable?.setNeedsDisplay()
        }
    }
    var teamNames: Array<String> {
        didSet {
            teamMenu?.removeAllItems()
            teamMenu?.addItemsWithTitles(teamNames)
            teamMenu?.setNeedsDisplay()
        }
    }
    
    override init(frame frameRect: NSRect) {
        teamMenu = NSPopUpButton()
        channelTable = NSTableView()
        channelNames = []
        teamNames = []
        super.init(frame:frameRect)
        channelTable?.setDataSource(self)
    }
    
    override func resizeSubviewsWithOldSize(oldSize: NSSize) {
        super.resizeSubviewsWithOldSize(oldSize)
        let menuHeight = teamMenu?.frame.size.height ?? 0.0
        teamMenu?.frame = NSRect(x: 0.0, y: frame.size.height - menuHeight, width: frame.size.width, height: menuHeight)
        channelTable?.frame = NSRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height - (menuHeight + 20.0))
    }
    
    required init?(coder: NSCoder) {
        if let menu = coder.decodeObjectForKey("menu") as? NSPopUpButton {
            teamMenu = menu
        } else {
            teamMenu = NSPopUpButton()
        }
        
        if let table = coder.decodeObjectForKey("table") as? NSTableView {
            channelTable = table
        } else {
            channelTable = NSTableView()
        }
        
        channelNames = []
        teamNames = []
        
        super.init(coder: coder)
        
        channelTable?.setDataSource(self)
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return channelNames.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return channelNames[row]
    }

}
