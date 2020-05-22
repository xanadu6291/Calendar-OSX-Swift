[Japanese][[English](README.md)]

# Calendar-OSX-Swift

これは [Gyetván András](https://github.com/gyetvan-andras)さんのObjective-Cで書かれたリポジトリ [Calendar-OSX](https://github.com/gyetvan-andras/Calendar-OSX)のSwift変換版です。

<img width="480" alt="dark_mode" src="https://user-images.githubusercontent.com/13963864/82581350-6e55bb00-9bcb-11ea-893b-ece34e7986f2.png">

<img width="480" alt="light_mode" src="https://user-images.githubusercontent.com/13963864/82581769-06ec3b00-9bcc-11ea-9bcd-f4c76427b75a.png">

***

## 説明

 基本的な機能は[オリジナル](https://github.com/gyetvan-andras/Calendar-OSX)と同じです。

[オリジナル](https://github.com/gyetvan-andras/Calendar-OSX)との違いは： 

1. 数字の書いていないカレンダーセルを選択したときのクラッシュを対策。
2. デフォルトの選択（赤い円）と下線（緑の下線）の位置がずれることがあることへの対策。
3. 数字の上の線（グレー）を下に移動。これは私の好みです ;-P
4. 土曜日と日曜日のカラーリングを追加。
5. OSのダークモードへの対応
6. 日本語ローカリゼーションの元での日本の祝祭日のカラーリングを追加 （[fumiyasac](https://github.com/fumiyasac)さんの[CalculateCalendarLogic.swift](https://github.com/fumiyasac/handMadeCalendarOfSwift/blob/master/handmadeCalenderSampleOfSwift/CalculateCalendarLogic.swift)を利用）。

***

## 使い方

使い方は[オリジナル](https://github.com/gyetvan-andras/Calendar-OSX)と同じです。サマライズすると：

1. MLCalendarグループの全てのファイルをあなたのプロジェクトにコピーしてください。

2. MLCalendarViewはNSViewControllerのサブクラスです。他のどんなビューとしても使えます。

3. カレンダーで使用しているデフォルトの色は、次のプロパティで変更できます。

   ```swift
   var backgroundColor: NSColor?
   var textColor: NSColor?
   var holiDayColor: NSColor?
   var saturDayColor: NSColor?
   var selectionColor: NSColor?
   var todayMarkerColor: NSColor?
   var dayMarkerColor: NSColor
   ```

4. もちろん、**Calendar-OSX-Swift**は [オリジナル](https://github.com/gyetvan-andras/Calendar-OSX)同様にデリゲートを持ちます。

   ```swift
   protocol MLCalendarViewDelegate {
       func didSelectDate(selectedDate: Date)
   }
   ```

***

## サンプルアプリケーション

Xcodeは、[オリジナル](https://github.com/gyetvan-andras/Calendar-OSX)同様、**NSPopover**,を用いた **Calendar-OSX-Swift**のサンプルです。
