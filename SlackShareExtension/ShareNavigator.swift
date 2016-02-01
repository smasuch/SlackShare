//
//  ShareNavigator.swift
//  SlackShare
//
//  Created by Steven Masuch on 2015-10-05.
//  Copyright © 2015 Zanopan. All rights reserved.
//

import Foundation

class ShareNavigator: NSObject {
    var presenter: SharePresenter
    var interactor: ShareInteractor
    
    override init() {
        presenter = SharePresenter()
        interactor = ShareInteractor()
        super.init()
    }
}
