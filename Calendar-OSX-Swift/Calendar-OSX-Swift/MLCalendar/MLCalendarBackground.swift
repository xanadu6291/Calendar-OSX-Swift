//
//  MLCalendarBackground.swift
//  Calendar-OSX-Swift
//
//  Created by 桃源老師 on 2020/05/12.
//  Copyright © 2020 桃源老師. All rights reserved.
//

import Cocoa

class MLCalendarBackground: NSView {
    
    var backgroundColor: NSColor?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commmonInit()
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        commmonInit()
    }
    
    func commmonInit() {
        self.backgroundColor = NSColor.white
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.backgroundColor!.set()
        self.bounds.fill()

        // Drawing code here.
    }
    
}
