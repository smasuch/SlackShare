//
//  SharePresenter.swift
//  SlackShare
//
//  Created by Steven Masuch on 2015-09-21.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Cocoa

public class SharePresenter {
    public var shareView: ShareViewProtocol?
    public let interactor: ShareInteractor
    public let navigator: ShareNavigator
    
    public init(creatingNavigator:ShareNavigator) {
        navigator = creatingNavigator
        interactor = ShareInteractor()
        interactor.presenter = self
    }
    
    // Takes in a list of team names to display
    func showTeamNames(names: [String]) {
        shareView?.setTeamNames(names)
    }
    
    func teamNameSelected(name: String) {
        // Tell the interactor about the team name being selected - it'll give us channel names
        interactor.teamNameSelected(name)
    }

    
    // Takes in a list of channels (presumably for the selected team) to display
    func showChannelNames(names: [String]) {
        shareView?.setChannelNames(names)
    }
    
    func showFilePreviewImage(previewImage: NSImage) {
        shareView?.setPreviewImage(previewImage)
    }
    
    func showFilename(filename: String) {
        shareView?.setFilename(filename)
    }
    
    // Auth window button pressed
    @IBAction func authenticateButtonPressed(sender: AnyObject?) {
        navigator.presentAuthenticationView()
    }
    
    public func share() {
        self.shareButtonPressed(nil)
    }
    
    // The share button was pressed, so tell the interactor
    @IBAction func shareButtonPressed(sender: AnyObject?) {
        interactor.uploadFile(shareView!.getSelectedTeamName(), channelName: shareView!.getSelectedChannelName())
    }
    
    // The cancel button was pressed, so tell the navigator
    @IBAction func cancelButtonPressed(sender: AnyObject?) {
        
    }
    
    // The sharing is continuing, tell the view
    func shareProgressUpdated(percentage: CGFloat) {
        
    }
    
    // The sharing is complete, tell the view
    func sharingComplete() {
        
    }
    
    // The sharing ran into an error
    func errorEncounteredWhileSharing(error: String) {
        
    }
    

}
