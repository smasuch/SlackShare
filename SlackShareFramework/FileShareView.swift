//
//  FileShareView.swift
//  SlackShare
//
//  Created by Steven Masuch on 2015-10-23.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Foundation
import AppKit

public class FileShareView: NSView, ShareViewProtocol
{
    @IBOutlet var selectorView: TeamChannelSelectorView?
    @IBOutlet var imagePreviewView: NSImageView?
    @IBOutlet var filenameView: NSTextField?
    
    public override init(frame frameRect:NSRect) {
        selectorView = TeamChannelSelectorView(frame: NSRect.zero)
        imagePreviewView = NSImageView(frame: NSRect.zero)
        filenameView = NSTextField(frame: NSRect.zero)
        super.init(frame: frameRect)
    }
    
    public required init?(coder: NSCoder) {
        if let codedSelectorView = coder.decodeObjectForKey("selectorViews") as? TeamChannelSelectorView {
            selectorView = codedSelectorView
        } else {
            selectorView = TeamChannelSelectorView(frame: NSRect.zero)
        }
        
        if let codedImagePreviewView = coder.decodeObjectForKey("imagePreviewView") as? NSImageView {
            imagePreviewView = codedImagePreviewView
        } else {
            imagePreviewView = NSImageView(frame: NSRect.zero)
        }
        
        if let codedFilenameView = coder.decodeObjectForKey("filenameView") as? NSTextField {
            filenameView = codedFilenameView
        } else {
            filenameView = NSTextField(frame: NSRect.zero)
        }
        
        super.init(coder: coder)
    }
    
    public func setTeamNames(names: Array<String>) {
        selectorView?.teamNames = names
    }
    
    public func setChannelNames(names: Array<String>) {
        selectorView?.channelNames = names
    }
    
    public func setPreviewImage(image: NSImage) {
        imagePreviewView?.image = image
    }
    
    public func setFilename(filename: String) {
        filenameView?.stringValue = filename
    }
    
    public func getSelectedTeamName() -> String {
        return selectorView?.teamMenu?.selectedItem?.title ?? ""
    }
    
    public func getSelectedChannelName() -> String {
        if let selectedRow = selectorView?.channelTable?.selectedRow, channelName = selectorView?.channelNames[selectedRow] {
            return channelName
        }
        
        return ""
    }
}
