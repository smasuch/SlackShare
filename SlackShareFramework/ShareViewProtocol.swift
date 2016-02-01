//
//  ShareViewProtocol.swift
//  SlackShare
//
//  Created by Steven Masuch on 2015-10-24.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Foundation

public protocol ShareViewProtocol {
    
    func setTeamNames(names: Array<String>)
    func setChannelNames(names: Array<String>)
    func setPreviewImage(image: NSImage)
    func setFilename(filename: String)
    
    func getSelectedTeamName() -> String
    func getSelectedChannelName() -> String
}
