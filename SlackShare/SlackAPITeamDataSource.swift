//
//  TeamDataSource.swift
//  SlackShare
//
//  Created by Steven Masuch on 2015-10-12.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Foundation

public struct teamInfo {
    var name: String
    var token: String
    var channels: Array<channelInfo>?
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionaryRepresentation = Dictionary<String, AnyObject>()
        dictionaryRepresentation["name"] = name
        dictionaryRepresentation["token"] = token
        if let channels = channels {
             dictionaryRepresentation["channels"] = channels.map {$0.toDictionary()}
        }
        return dictionaryRepresentation
    }
    
    static func fromDictionary(sourceDictionary: Dictionary<String, AnyObject>) -> teamInfo? {
        if let name = sourceDictionary["name"] as? String,
           let token = sourceDictionary["token"] as? String {
             let channelsDictionary : Array<Dictionary<String, AnyObject>> = sourceDictionary["channels"] as! Array<Dictionary<String, AnyObject>>
                let channels = channelsDictionary.map{ channelInfo.fromDictionary($0) } as? Array<channelInfo>
            return teamInfo(name: name, token: token, channels:channels)
        } else {
            return nil
        }
    }
}

public struct channelInfo {
    var id: String
    public var name: String
    var selectedForShare: Bool
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        var dictionaryRepresentation = Dictionary<String, AnyObject>()
        dictionaryRepresentation["id"] = id
        dictionaryRepresentation["name"] = name
        dictionaryRepresentation["selectedForShare"] = selectedForShare
        return dictionaryRepresentation
    }
    
    static func fromDictionary(sourceDictionary: Dictionary<String, AnyObject>) -> channelInfo? {
        if let id = sourceDictionary["id"] as? String,
           let name = sourceDictionary["name"] as? String,
           let selectedForShare = sourceDictionary["selectedForShare"] as? Bool {
            return channelInfo(id: id, name: name, selectedForShare: selectedForShare)
        } else {
            return nil;
        }
    }
}

protocol SlackAPITeamDataSourceAudience
{
    func teamDataSource(dataSource: SlackAPITeamDataSource, didGetChannelsForTeam team: teamInfo)
}

class SlackAPITeamDataSource
{
    var teams: Dictionary<String, teamInfo>
    var session: NSURLSession?
    var audienceMember: SlackAPITeamDataSourceAudience?

    init() {
        teams = [String: teamInfo]();
    }
    
    func addTeamWithToken(token: String) {
        // Make a call to get the team info
        // Open a connection
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        session = NSURLSession(configuration: configuration)
        let channelsRequest = NSMutableURLRequest(URL: NSURL(string: "https://slack.com/api/channels.list")!)
        channelsRequest.HTTPMethod = "POST"
        channelsRequest.HTTPBody = "excludeArchived=1&token=\(token)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let channelsTask = session?.dataTaskWithRequest(channelsRequest) {
            data, response, error in
            if (error == nil) {
                if let responseJSON = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) {
                    print(responseJSON)
                                        
                    var channels = [channelInfo]()
                    
                    if let channelsArray = responseJSON["channels"] as? Array<[String: AnyObject]> {
                        for channel in channelsArray {
                            if let channelName = channel["name"] as? String, channelID = channel["id"] as? String {
                                let thisChannel = channelInfo(id: channelID, name: channelName, selectedForShare: false)
                                channels.append(thisChannel)
                            }
                        }
                    }
                    
                    if var existingTeamInfo = self.teams[token] {
                        existingTeamInfo.channels = channels
                        self.teams[token] = existingTeamInfo
                    } else {
                        let team = teamInfo(name: "", token: token, channels: channels)
                        self.teams[token] = team
                    }
                    
                    self.audienceMember?.teamDataSource(self, didGetChannelsForTeam: self.teams[token]!)
                }
            }
        }
        channelsTask?.resume()
        
        
        // Now get the team name
        let nameRequest = NSMutableURLRequest(URL: NSURL(string: "https://slack.com/api/team.info")!)
        nameRequest.HTTPMethod = "POST"
        nameRequest.HTTPBody = "token=\(token)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let nameTask = session?.dataTaskWithRequest(nameRequest) {
            data, response, error in
            if (error == nil) {
                if let responseJSON = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) {
                    print(responseJSON)
                    
                    if let recievedTeamInfo = responseJSON["team"] as? NSDictionary, teamName = recievedTeamInfo["name"] as? String {
                        if var existingTeamInfo = self.teams[token] {
                            existingTeamInfo.name = teamName
                            self.teams[token] = existingTeamInfo
                        } else {
                            let team = teamInfo(name: teamName, token: token, channels: nil)
                            self.teams[token] = team
                        }
                    }
                    
                    self.audienceMember?.teamDataSource(self, didGetChannelsForTeam: self.teams[token]!)
                }
            }
        }
        nameTask?.resume()
    }
    
    func removeTeamWithToken(token: String) {
        
    }
    
    func channelsForTeamName(name: String) -> Array<channelInfo>? {
        let team = teams.values.filter({$0.name == name})
        return team.first?.channels
    }
    
}
