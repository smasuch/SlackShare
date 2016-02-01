//
//  ShareNavigator.swift
//  SlackShare
//
//  Created by Steven Masuch on 2015-10-24.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Foundation

public protocol ShareNavigator {
    
    func presentAuthenticationView()
    func authenticationViewCompleted(token: String)
    func sharingComplete()
}