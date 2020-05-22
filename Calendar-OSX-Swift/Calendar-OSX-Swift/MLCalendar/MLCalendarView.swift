//
//  MLCalendarView.swift
//  Calendar-OSX-Swift
//
//  Created by 桃源老師 on 2020/05/12.
//  Copyright © 2020 桃源老師. All rights reserved.
//

import Cocoa

protocol MLCalendarViewDelegate {
    func didSelectDate(selectedDate: Date)
}

class MLCalendarView: NSViewController {
   
    @IBOutlet weak var calendarTitle: NSTextField!
    @IBOutlet weak var prevBtnOutlet: NSButton!
    @IBOutlet weak var nextBtnOutlet: NSButton!
    @IBAction func nextMonth(_ sender: Any) {
        self.stepMonth(dm: 1)
    }
    @IBAction func prevMonth(_ sender: Any) {
        self.stepMonth(dm: -1)
    }
    var backgroundColor: NSColor?
    var textColor: NSColor?
    var holiDayColor: NSColor?
    var saturDayColor: NSColor?
    var selectionColor: NSColor?
    var todayMarkerColor: NSColor?
    var dayMarkerColor: NSColor?
    var delegate: MLCalendarViewDelegate?
    // Value Observing with KVO
    @objc dynamic var date: Date = Date()
    var _date: Date = Date()
    // Value Observing with KVO
    @objc dynamic var selectedDate: Date = Date()
    var _selectedDate: Date = Date()
    
    var dayLabels: NSMutableArray?
    var dayCells: NSMutableArray?
    // Value for KVO
    var observation1: NSKeyValueObservation?
    var observation2: NSKeyValueObservation?
    // Japanese Holiday check logic
    let holidayObject = CalculateCalendarLogic()
    var holidayFlag: Bool = false
    
    // Compare d1 and d2 is same date or not
    class func isSameDate(d1:Date?, d2:Date?) -> Bool {
        if((d1 != nil) && (d2 != nil)) {
            var cal:Calendar = Calendar.current
            cal.timeZone = TimeZone(abbreviation: "UTC")!
            // let unitFlags --- variable omitted because of swift syntax
            var components:DateComponents = cal.dateComponents([.day, .year, .month], from: d1! as Date)
            let ry = components.year
            let rm = components.month
            let rd = components.day
            components = cal.dateComponents([.day, .year, .month], from: d2! as Date)
            let ty = components.year
            let tm = components.month
            let td = components.day
            return (ry == ty && rm == tm && rd == td)
        } else {
            return false
        }
    }
    // Convert input date to UTC timezone
    // To use MLCalendarCell class, made this function as Class function.
    class func toUTC(d:Date)->Date {
        var cal: Calendar = Calendar.current
        // let unitFlags --- variable omitted because of swift syntax
        let components:DateComponents = cal.dateComponents([.day, .year, .month], from: d as Date)
        cal.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        return (cal.date(from: components)!)
    }
    // Never called?
    class func dd(d:Date)->NSString {
        var cal: Calendar = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        // let unitFlags --- variable omitted because of swift syntax
        let cpt:DateComponents = cal.dateComponents([.day, .year, .month], from: d)
        return NSString(format: "%ld-%ld-%ld", cpt.year!, cpt.month!, cpt.day!)
    }
    init() {
        super.init(nibName: "MLCalendarView", bundle: Bundle(for: type(of: self)))
        self.commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    func commonInit() {
        // Check current appearance is dark mode or not
        let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
        if !isDark {
            self.backgroundColor = NSColor.white
            self.textColor = NSColor.black
            self.dayMarkerColor = NSColor.darkGray
        } else {
            self.backgroundColor = NSColor.init(calibratedRed: 0x36/255.0, green: 0x35/255.0, blue: 0x34/255.0, alpha: 0xFF/255.0)/* 403C3DFF */
            // self.backgroundColor = NSColor.darkGray
            self.textColor = NSColor.white
            self.dayMarkerColor = NSColor.init(calibratedRed: 0xE6/255.0, green: 0xE6/255.0, blue: 0xE6/255.0, alpha: 0xFF/255.0)/* E6E6E6FF */
        }
        self.holiDayColor = NSColor.init(calibratedRed: 0xFF/255.0, green: 0x56/255.0, blue: 0x56/255.0, alpha: 0xFF/255.0)/* FF5656FF */
        self.saturDayColor = NSColor.init(calibratedRed: 0x7A/255.0, green: 0x7A/255.0, blue: 0xFF/255.0, alpha: 0xFF/255.0)/* 7A7AFFFF */
        self.selectionColor = NSColor.red
        self.todayMarkerColor = NSColor.green
        self.dayCells = NSMutableArray()
        var i = 0
        while i <= 6 {
            self.dayCells?.add(NSMutableArray())
            i += 1
        }
        // KVO similar with Objective-C setter/getter
        observation1 = observe(
            \.date,
            options: [.old, .new]
        ) { object, change in
            self.setDate(date: self.date)
        }
        observation2 = observe(
            \.selectedDate,
            options: [.old, .new]
        ) { object, change in
            self.setSelectedDate(selectedDate: self.selectedDate)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        // Image in button color setting for Dark Mode
        self.prevBtnOutlet.contentTintColor = textColor
        self.nextBtnOutlet.contentTintColor = textColor
        // Day of week set up
        self.dayLabels = NSMutableArray()
        for i in 1...7 {
            let _id = NSString(format: "day%d", i)
            let d:NSTextField = self.viewByID(_id: _id) as! NSTextField
            self.dayLabels!.add(d)
        }
        // 42 Day Button Setup (This functions ???)
        for row in 0..<6 {
            for col in 0..<7 {
                let i = (row*7)+col+1
                let _id = NSString(format: "c%d", i)
                let cell:MLCalendarCell = self.viewByID(_id: _id) as! MLCalendarCell
                cell.target = self
                cell.action = #selector(cellClicked)
                (self.dayCells![row] as AnyObject).add(cell)
                cell.owner = self
            }
        }
        // Day Of Week print function (This functions correctly)
        let df:DateFormatter! = DateFormatter()
        // Localization
        df.locale = Locale(identifier: NSLocalizedString("en", comment: "locale"))
        let days = df.shortStandaloneWeekdaySymbols
        for i in 0..<days!.count {
            let day:NSString = days![i].uppercased() as NSString
            let col = self.colForDay(day: i+1)
            let tf:NSTextField = self.dayLabels![col] as! NSTextField
            tf.textColor = textColor
            tf.backgroundColor = backgroundColor
            tf.stringValue = day as String
        }
        // BackgroundColor functions collectly
        let bv:MLCalendarBackground = self.view as! MLCalendarBackground
        bv.backgroundColor = self.backgroundColor
        //layoutCalendar()
    }
    // Connect view with id
    func viewByID(_id:NSString)->AnyObject? {
        for subview:NSView in self.view.subviews {
            if (subview.identifier == _id as NSUserInterfaceItemIdentifier) {
                return subview
            }
        }
        return nil
    }
    // Set Calendar title
    // This is setter method of Objective-C which called based on property change.
    func setDate(date: Date) {
        _date = MLCalendarView.toUTC(d: date)
        self.layoutCalendar()
        var cal: Calendar = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        // let unitFlags --- variable omitted because of swift syntax
        let components:DateComponents = cal.dateComponents([.day, .year, .month], from: date)
        let month = components.month!
        let year = components.year
        let df:DateFormatter = DateFormatter()
        var monthName:NSString = df.standaloneMonthSymbols[month-1] as NSString
        let mnFirstLetter = monthName.substring(to: 1).uppercased()
        let mnLastPart = monthName.substring(from: 1)
        monthName = NSString(format: "%@%@", mnFirstLetter, mnLastPart)
        // Localization
        let langStr = Locale.current.languageCode
        let localeSuffix:String = NSLocalizedString("Year", comment: "localeSuffix")
        var budgetDateSummary:NSString
        if (langStr == "ja") {
            budgetDateSummary = NSString(format: "%ld%@ %@", year!, localeSuffix, monthName)
        } else {
            budgetDateSummary = NSString(format: "%@, %ld", monthName, year!)
        }
        // For Dark/Light mode
        self.calendarTitle.textColor = textColor
        self.calendarTitle.backgroundColor = backgroundColor
        self.calendarTitle.stringValue = budgetDateSummary as String
    }
    // Set selected date
    // This is setter method of Objective-C which called based on property change.
    func setSelectedDate(selectedDate:Date) {
        _selectedDate = MLCalendarView.toUTC(d: selectedDate)
        for row in 0..<6 {
            for col in 0..<7 {
                let tempCell:NSMutableArray = (self.dayCells![row] as AnyObject) as! NSMutableArray
                let cell:MLCalendarCell = (tempCell[col] as AnyObject) as! MLCalendarCell
                let selected:Bool = MLCalendarView.isSameDate(d1: cell.representedDate, d2: _selectedDate)
                cell.selected = selected
            }
        }
    }
    // Selecter for cell click
    @objc func cellClicked(sender: AnyObject) {
        // Initialization of 42 day button click status
        for row in 0..<6 {
            for col in 0..<7 {
               let tempCell:NSMutableArray = (self.dayCells![row] as AnyObject) as! NSMutableArray
                let cell:MLCalendarCell = (tempCell[col] as AnyObject) as! MLCalendarCell
                cell.selected = false
            }
        }
        // Operation for button click
        let cell:MLCalendarCell = sender as! MLCalendarCell
        cell.selected = true
        // Fix for crash on Empty button selection. Original also have this issue!!
        if let cellRepDate:Date = cell.representedDate {
            _selectedDate = cellRepDate
        } else { return }
        
        if((self.delegate) != nil) {
            // Since respondsToSelector() is not avairable in current Swift, we need to use such a check statement.
            // Usage of selectedDate is differ from Original, so we use _selectedDate here.
            guard let _ = self.delegate?.didSelectDate(selectedDate: _selectedDate) else {
                return
            }
        }
    }
    //
    func monthDay(day:NSInteger)->Date {
        var cal: Calendar = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        // let unitFlags --- variable omitted because of swift syntax
        let components:DateComponents = cal.dateComponents([.day, .year, .month], from: _date)
        var comps:DateComponents = DateComponents()
        comps.day = day
        comps.year = components.year!
        comps.month = components.month!
        return cal.date(from: comps)!
    }
    // Calculate last day of week
    func lastDayOfTheMonth()->NSInteger {
        var cal: Calendar = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        let daysRange:Range = cal.range(of: .day, in: .month, for: date)!
        return daysRange.count
    }
    // Calculate column number of calendar
    func colForDay(day:NSInteger)->NSInteger {
        var cal: Calendar = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        var idx = day - cal.firstWeekday
        if(idx < 0){ idx = 7 + idx }
        return idx
    }
    // The Key function. Determin layout of calendar
    func layoutCalendar() {
        // if !self.view { return }
        // Initialize calendar button cell represented date and selected
        for row in 0..<6 {
            for col in 0..<7 {
                let tempCell:NSMutableArray = (self.dayCells![row] as AnyObject) as! NSMutableArray
                let cell:MLCalendarCell = (tempCell[col] as AnyObject) as! MLCalendarCell
                cell.representedDate = nil
                cell.selected = false
            }
        }
        var cal: Calendar = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        // let unitFlags --- variable omitted because of swift syntax
        let components = cal.dateComponents([.weekday], from: self.monthDay(day: 1))
        let firstDay:NSInteger = components.weekday!
        let lastDay:NSInteger = self.lastDayOfTheMonth()
        var col:NSInteger = self.colForDay(day: firstDay)
        var day = 1
        for row in 0..<6 {
            while col < 7 {
                if(day <= lastDay) {
                    let tempCell:NSMutableArray = (self.dayCells![row] as AnyObject) as! NSMutableArray
                    let cell:MLCalendarCell = (tempCell[col] as AnyObject) as! MLCalendarCell
                    let d:Date = self.monthDay(day: day)
                    let components:DateComponents = cal.dateComponents([.day, .year, .month, .weekday], from: d)
                    let weekDay = components.weekday
                    cell.representedDate = d
                    let selected:Bool = MLCalendarView.isSameDate(d1: d, d2: _selectedDate)
                    cell.selected = selected
                    // Days coloring
                    cell.weekDay = weekDay
                    // Japanese holiday logic
                    let langStr = Locale.current.languageCode
                    if (langStr == "ja") {
                        let yearJH = components.year
                        let monthJH = components.month
                        let dayJH = components.day
                        holidayFlag = holidayObject.judgeJapaneseHoliday(year: yearJH!, month: monthJH!, day: dayJH!)
                        if (holidayFlag) {
                            cell.weekDay = 0
                        }
                    }
                    day+=1
                }
                col+=1
            }
            col = 0
        }
    }
    // Step up/down month.
    func stepMonth(dm:NSInteger) {
        var cal: Calendar = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        // let unitFlags --- variable omitted because of swift syntax
        var components:DateComponents = cal.dateComponents([.day, .year, .month], from: date)
        var month:NSInteger = components.month! + dm
        var year:NSInteger = components.year!
        if(month > 12) {
            month = 1
            year+=1
        }
        if(month < 1) {
            month = 12
            year-=1
        }
        components.year = year
        components.month = month
        date = (cal.date(from: components as DateComponents)!)
    }
}
