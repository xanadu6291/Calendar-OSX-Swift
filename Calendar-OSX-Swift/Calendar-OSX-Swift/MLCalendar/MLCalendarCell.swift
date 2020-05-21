//
//  MLCalendarCell.swift
//  Calendar-OSX-Swift
//
//  Created by 桃源老師 on 2020/05/12.
//  Copyright © 2020 桃源老師. All rights reserved.
//

import Cocoa

class MLCalendarCell: NSButton {
    
    var owner: MLCalendarView?
    // Value Observing with KVO
    @objc dynamic var representedDate: Date?
    var _representedDate: Date?
    // Value Observing with KVO
    @objc dynamic var selected: Bool = false
    var _selected: Bool?
    var weekDay: NSInteger?
    // Value for KVO
    var observation1: NSKeyValueObservation?
    var observation2: NSKeyValueObservation?

    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commmonInit()
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        commmonInit()
    }
    
    func commmonInit() {
        self.isBordered = false
        self.representedDate = nil
        self.weekDay = 0
        // KVO similar with Objective-C setter/getter
        observation1 = observe(
            \.representedDate,
            options: [.old, .new]
        ) { object, change in
            self.setRepresentedDate(representedDate: self.representedDate ?? Date())
        }
        observation2 = observe(
            \.selected,
            options: [.old, .new]
        ) { object, change in
            self.setSelected(selected: self.selected)
        }
    }
    
    func isToday() -> Bool {
        // In original, parameter for d2 is row date, which resulting diffrence between initial position of selection and bottom line.
        // The fix is make toUTC function as Class function, and use it here!!
        let tempDate = MLCalendarView.toUTC(d: Date())
        if((self.representedDate) != nil) {
            return MLCalendarView.isSameDate(d1: self.representedDate, d2: tempDate)
        } else {
            return false;
        }
    }
    // This is setter method of Objective-C which called based on property change.
    func setSelected(selected: Bool) {
        _selected = selected
        self.needsDisplay = true
    }
    // This is setter method of Objective-C which called based on property change.
    func setRepresentedDate(representedDate: Date) {
        _representedDate = representedDate
        if((_representedDate) != nil) {
            var cal: Calendar = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "UTC")!
            //let unitFlags = Calendar.Unit.day
            let components:DateComponents = cal.dateComponents([.day], from: _representedDate! as Date)
            let day = components.day
            self.title = NSString(format: "%ld",day!) as String
        } else {
            self.title = ""
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if(self.owner != nil) {
            NSGraphicsContext.saveGraphicsState()
            let bounds = self.bounds
            self.owner!.backgroundColor!.set()
            bounds.fill()
            if((self.representedDate) != nil) {
                //selection
                if(self.selected) {
                    var circeRect: NSRect = NSInsetRect(bounds, CGFloat(3.5 as Float), CGFloat(3.5 as Float))
                    circeRect.origin.y += 1
                    let bzc: NSBezierPath = NSBezierPath(ovalIn: circeRect)
                    self.owner!.selectionColor!.set()
                    bzc.fill()
                }
                let aParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
                aParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
                aParagraphStyle.alignment = NSTextAlignment.center
                
                // title of buttons
                // Coloring days (Sun, Sat, Japanese Holiday)
                var attrs:NSDictionary
                switch self.weekDay {
                case 0:
                attrs = [NSAttributedString.Key.paragraphStyle:aParagraphStyle as Any, NSAttributedString.Key.font:self.font!, NSAttributedString.Key.foregroundColor:self.owner!.holiDayColor!]
                case 1:
                    attrs = [NSAttributedString.Key.paragraphStyle:aParagraphStyle as Any, NSAttributedString.Key.font:self.font!, NSAttributedString.Key.foregroundColor:self.owner!.holiDayColor!]
                case 7:
                    attrs = [NSAttributedString.Key.paragraphStyle:aParagraphStyle as Any, NSAttributedString.Key.font:self.font!, NSAttributedString.Key.foregroundColor:self.owner!.saturDayColor!]
                default:
                    attrs = [NSAttributedString.Key.paragraphStyle:aParagraphStyle as Any, NSAttributedString.Key.font:self.font!, NSAttributedString.Key.foregroundColor:self.owner!.textColor!]
                }
                let size:NSSize = self.title.size(withAttributes: attrs as? [NSAttributedString.Key : Any])
                let r:NSRect = NSMakeRect(bounds.origin.x, bounds.origin.y + ((bounds.size.height - size.height)/2.0) - 1, bounds.size.width, size.height)
                self.title.draw(in: r, withAttributes: attrs as? [NSAttributedString.Key : Any])
                
                // Line
                // Y axsis of topline move and line was NSMinY in Original, but I dislike. Changed to NSMaxY.
                let topLine: NSBezierPath = NSBezierPath()
                topLine.move(to: NSMakePoint(NSMinX(bounds), NSMaxY(bounds)))
                topLine.line(to: NSMakePoint(NSMaxX(bounds), NSMaxY(bounds)))
                self.owner!.dayMarkerColor!.set()
                topLine.lineWidth = CGFloat(0.3 as Float)
                topLine.stroke()
                if(self.isToday()) {
                    self.owner!.todayMarkerColor!.set()
                    let bottomLine: NSBezierPath = NSBezierPath()
                    bottomLine.move(to: NSMakePoint(NSMinX(bounds), NSMaxY(bounds)))
                    bottomLine.line(to: NSMakePoint(NSMaxX(bounds), NSMaxY(bounds)))
                    bottomLine.lineWidth = CGFloat(4.0 as Float)
                    bottomLine.stroke()
                }
            }
            NSGraphicsContext.restoreGraphicsState()
        }
    }
}
