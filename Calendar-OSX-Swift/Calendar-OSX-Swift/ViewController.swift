//
//  ViewController.swift
//  Calendar-OSX-Swift
//
//  Created by 桃源老師 on 2020/05/12.
//  Copyright © 2020 桃源老師. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, MLCalendarViewDelegate {
    func didSelectDate(selectedDate: Date) {
        self.calendarPopover.close()
        self.dateField.stringValue = self.dateFormatter.string(from:selectedDate)
    }
    
    @IBAction func showCalendar(_ sender: Any) {
        self.createCalendarPopover()
        
        let date:Date = self.dateFormatter.date(from: self.dateField.stringValue)!
        self.calendarView.date = date
        self.calendarView.selectedDate = date
        let btn:NSButton = sender as! NSButton
        let cellRect:NSRect = btn.bounds
        self.calendarPopover.show(relativeTo: cellRect, of: btn, preferredEdge: NSRectEdge.maxY)
    }
    @IBOutlet weak var dateField: NSTextField!
    @IBOutlet weak var dateFormatter: DateFormatter!
    var calendarPopover:NSPopover = NSPopover()
    var calendarView:MLCalendarView = MLCalendarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateField.stringValue = self.dateFormatter.string(from:Date())

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func createCalendarPopover() {
        var myPopover:NSPopover = self.calendarPopover
        if (!myPopover.isShown) {
            myPopover = NSPopover()
            self.calendarView = MLCalendarView()
            self.calendarView.delegate = self
            myPopover.contentViewController = self.calendarView
            myPopover.appearance = NSAppearance.init(named: NSAppearance.Name.aqua)
            myPopover.animates = true
            myPopover.behavior = NSPopover.Behavior.transient
        }
        self.calendarPopover = myPopover
    }
}

