//
//  SetTitle.swift
//  Calendar-OSX-Swift
//
//  Created by 桃源老師 on 2020/05/22.
//  Copyright © 2020 桃源老師. All rights reserved.
//

import Cocoa

class SetTitle: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.title = "Calendar-OSX-Swift"
    }

}
