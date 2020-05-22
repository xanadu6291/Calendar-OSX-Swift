# Calendar-OSX-Swift

This is a Swift conversion of  [Gyetván András](https://github.com/gyetvan-andras)'s repository [Calendar-OSX](https://github.com/gyetvan-andras/Calendar-OSX) which is written in Objective-C.

<img width="480" alt="dark_mode" src="https://user-images.githubusercontent.com/13963864/82581350-6e55bb00-9bcb-11ea-893b-ece34e7986f2.png">

<img width="480" alt="light_mode" src="https://user-images.githubusercontent.com/13963864/82581769-06ec3b00-9bcc-11ea-9bcd-f4c76427b75a.png">

## Description

***

Basic function is same as [original](https://github.com/gyetvan-andras/Calendar-OSX).

Here, I describe the difference between [original](https://github.com/gyetvan-andras/Calendar-OSX):

1. Fix for crash on empty calendar cell selection.
2. Fix for misplacing of bottom line and default selection circle.
3. Chaned top line into bottom line. It's my favorite. ;-P
4. Add coloring of Sunday and Saturday.
5. Add Support for switching to dark mode.
6. Add Japanese Holiday coloring (Using [fumiyasac](https://github.com/fumiyasac)'s [CalculateCalendarLogic.swift](https://github.com/fumiyasac/handMadeCalendarOfSwift/blob/master/handmadeCalenderSampleOfSwift/CalculateCalendarLogic.swift)) in Japanese localization.

***

## Usage

Usage is same as [original](https://github.com/gyetvan-andras/Calendar-OSX). In Summary:

1. Copy all the files in the MLCalendar group to your project.
2. MLCalendarView is subclass of NSViewController which can be used as any other view.
3. You can change the default colors used by the calendar by the properties as follows:

   ```swift
   var backgroundColor: NSColor?
   var textColor: NSColor?
   var holiDayColor: NSColor?
   var saturDayColor: NSColor?
   var selectionColor: NSColor?
   var todayMarkerColor: NSColor?
   var dayMarkerColor: NSColor
   ```
4. Off cource, **Calendar-OSX-Swift** have delegate same as  [original](https://github.com/gyetvan-andras/Calendar-OSX).

   ```swift
   protocol MLCalendarViewDelegate {
       func didSelectDate(selectedDate: Date)
   }
   ```
***

## Sample Application

The Xcode project is sample of **Calendar-OSX-Swift** using **NSPopover**, same as [original](https://github.com/gyetvan-andras/Calendar-OSX).
