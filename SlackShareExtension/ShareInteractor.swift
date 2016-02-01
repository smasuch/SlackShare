//
//  ShareInteractor.swift
//  SlackShare
//
//  Created by Steven Masuch on 2015-09-21.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Cocoa
import QuickLook

public enum ShareItemType {
    case Text
    case File
}

public class ShareInteractor: SlackAPISharerDelegate, SlackAPITeamDataSourceAudience {
    
    let sharer: SlackAPISharer
    let teamDataSource: SlackAPITeamDataSource
    var presenter: SharePresenter?
    public var fileURL: NSURL? {
        didSet {
            if let existingURL = fileURL {
                handleNewURL(existingURL)
            }
        }
    }
    
    init() {
        sharer = SlackAPISharer()
        teamDataSource = SlackAPITeamDataSource()
        sharer.delegate = self
        teamDataSource.audienceMember = self
    }
    
    func handleNewURL(newURL: NSURL) {
        // Tell the presenter the filename
        if let filename = newURL.lastPathComponent {
            presenter?.showFilename(filename)
        }
        
        // Give the presenter the image
        let quickLookIcon = QLThumbnailImageCreate(nil, newURL as CFURLRef, CGSizeMake(60.0, 60), nil);
        presenter?.showFilePreviewImage(NSImage(CGImage: quickLookIcon.takeUnretainedValue(), size: CGSizeMake(200.0, 200.0)))        
    }
    
    // Auth token recieved, tell the team data source
    public func authTokenRecieved(token: String) {
        teamDataSource.addTeamWithToken(token)
    }
    
    
    // Team data source updated, tell the presenter
    func teamDataSource(dataSource: SlackAPITeamDataSource, didGetChannelsForTeam team: teamInfo) {
        // Right now, we're using this for all updates
        if let channels = team.channels {
            presenter?.showChannelNames(channels.map({$0.name}))
        }
        presenter?.showTeamNames([team.name])
    }
    
    func teamNameSelected(name: String) {
        // Tell the interactor about the team name being selected - it'll give us channel names
        if let channels = teamDataSource.channelsForTeamName(name) {
            // Filter out the channel names
            presenter?.showChannelNames(channels.map({$0.name}))
        } else {
            // Show some sort of error?
        }
       
    }
    
    // Share some text
    
    // Upload a file and post a message about it to a channel
    func uploadFile(teamName: String, channelName: String) {
        func isRightTeam(team: teamInfo) -> Bool {
            return team.name == teamName
        }
        if let team = teamDataSource.teams.values.filter(isRightTeam).first {
            func isRightChannel(channel: channelInfo) -> Bool {
                return channel.name == channelName
            }
            if let channel = team.channels!.filter(isRightChannel).first {
                sharer.token = team.token
                sharer.uploadFile(fileURL!, channelID: channel.id)
            }
        }
    }
}
