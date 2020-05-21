//
//  AppDelegate.swift
//  Calendar-OSX-Swift
//
//  Created by 桃源老師 on 2020/05/12.
//  Copyright © 2020 桃源老師. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed()->Bool {
        return true
    }
}

