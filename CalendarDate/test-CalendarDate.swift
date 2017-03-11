import Foundation
// test-CalendarDate version 1.21, 2017.3.11, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
let Date20180201: Date = calendar.date(from: DateComponents(year:2018, month:2, day:1))!
let Date20170301: Date = calendar.date(from: DateComponents(year:2017, month:3, day:1))!
let Date20170202: Date = calendar.date(from: DateComponents(year:2017, month:2, day:2))!
let Date20200504: Date = calendar.date(from: DateComponents(year:2020, month:5, day:4))!
let Date20131029: Date = calendar.date(from: DateComponents(year:2013, month:10, day:29))!
let Date15170201: Date = calendar.date(from: DateComponents(year:1517, month:2, day:1))!
let Date20160229: Date = calendar.date(from: DateComponents(year:2016, month:2, day:29))!
let Date15810201: Date = calendar.date(from: DateComponents(year:1581, month:2, day:1))!
let Date15820201: Date = calendar.date(from: DateComponents(year:1582, month:2, day:1))!
let Date15820101: Date = calendar.date(from: DateComponents(year:1582, month:1, day:1))!
let Date99991201: Date = calendar.date(from: DateComponents(year:9999, month:12, day:1))!
let Date99991231: Date = calendar.date(from: DateComponents(year:9999, month:12, day:31))!
let Date100000101: Date = calendar.date(from: DateComponents(year:10000, month:1, day:1))!
let Date120170202: Date = calendar.date(from: DateComponents(year:12017, month:2, day:2))!
var calendarDate:CalendarDate
var returnSet:(date:Date?, status:Int)
var components:DateComponents
let testDataSet: [(condition:String, targetYear:Int, targetMonth:Int, targetDay:Int, offsetYear:Int, offsetMonth:Int, offsetDay:Int, returnDate:Date, status:Int)] = [
  (condition:"2017/2/1 after 1 year", targetYear:2017, targetMonth:2, targetDay:1, offsetYear:1, offsetMonth:0, offsetDay:0, returnDate:Date20180201, status:1),
  (condition:"2017/2/1 after 1 month", targetYear:2017, targetMonth:2, targetDay:1, offsetYear:0, offsetMonth:1, offsetDay:0, returnDate:Date20170301, status:1),
  (condition:"2017/2/1 after 1 day", targetYear:2017, targetMonth:2, targetDay:1, offsetYear:0, offsetMonth:0, offsetDay:1, returnDate:Date20170202, status:1),
  (condition:"2017/2/1 after 3 years, 3 months and 3 days", targetYear:2017, targetMonth:2, targetDay:1, offsetYear:3, offsetMonth:3, offsetDay:3, returnDate:Date20200504, status:1),
  (condition:"2017/2/1 before 3 years, 3 months and 3 days", targetYear:2017, targetMonth:2, targetDay:1, offsetYear:-3, offsetMonth:-3, offsetDay:-3, returnDate:Date20131029, status:-1),
  (condition:"2017/2/1 before 500 years", targetYear:2017, targetMonth:2, targetDay:1, offsetYear:-500, offsetMonth:0, offsetDay:0, returnDate:Date15170201, status:0),
  (condition:"2017/2/1 after 28 days", targetYear:2017, targetMonth:2, targetDay:1, offsetYear:0, offsetMonth:0, offsetDay:28, returnDate:Date20170301, status:1),
  (condition:"2016/2/1 after 28 days", targetYear:2016, targetMonth:2, targetDay:1, offsetYear:0, offsetMonth:0, offsetDay:28, returnDate:Date20160229, status:1),
  (condition:"1580/2/1 after 1 year", targetYear:1580, targetMonth:2, targetDay:1, offsetYear:1, offsetMonth:0, offsetDay:0, returnDate:Date15810201, status:0),
  (condition:"1581/2/1 after 1 year", targetYear:1581, targetMonth:2, targetDay:1, offsetYear:1, offsetMonth:0, offsetDay:0, returnDate:Date15820201, status:0),
  (condition:"1582/2/1 before 1 year", targetYear:1582, targetMonth:2, targetDay:1, offsetYear:-1, offsetMonth:0, offsetDay:0, returnDate:Date15810201, status:0),
  (condition:"1582/2/1 before 1 month", targetYear:1582, targetMonth:2, targetDay:1, offsetYear:0, offsetMonth:-1, offsetDay:0, returnDate:Date15820101, status:-1),
  (condition:"9999/12/1 after 1 month", targetYear:9999, targetMonth:12, targetDay:1, offsetYear:0, offsetMonth:1, offsetDay:0, returnDate:Date100000101, status:0),
  (condition:"9999/12/1 after 30 days", targetYear:9999, targetMonth:12, targetDay:1, offsetYear:0, offsetMonth:0, offsetDay:30, returnDate:Date99991231, status:1),
  (condition:"10000/1/1 before 1 month", targetYear:10000, targetMonth:1, targetDay:1, offsetYear:0, offsetMonth:-1, offsetDay:0, returnDate:Date99991201, status:1),
  (condition:"12017/2/1 after 1 day", targetYear:12017, targetMonth:2, targetDay:1, offsetYear:0, offsetMonth:0, offsetDay:1, returnDate:Date120170202, status:0)]
for n in testDataSet {
  calendarDate = CalendarDate(targetYear:n.targetYear, targetMonth:n.targetMonth, targetDay:n.targetDay)
  returnSet = calendarDate.get(offsetYear:n.offsetYear, offsetMonth:n.offsetMonth, offsetDay:n.offsetDay)
  print("[Test condition: \(n.condition)]")
  if returnSet.status != 0 {
    print("\(calendar.component(.year, from:returnSet.date!))/\(calendar.component(.month, from:returnSet.date!))/\(calendar.component(.day, from:returnSet.date!))", terminator:"")
    if returnSet.date! == n.returnDate && returnSet.status == n.status { print("\u{001B}[0;32m => OK\u{001B}[0;30m") } else { print("\u{001B}[0;31m => NG\u{001B}[0;30m") }
  } else {
    print(returnSet, terminator:"")
    if returnSet.date == nil { print("\u{001B}[0;32m => OK\u{001B}[0;30m") } else { print("\u{001B}[0;31m => NG\u{001B}[0;30m") }
  }
}
calendarDate = CalendarDate(targetYear:0, targetMonth:0, targetDay:0)
returnSet = calendarDate.get(offsetYear:1,offsetMonth:0,offsetDay:0)
components = calendar.dateComponents([.year, .month, .day], from:returnSet.date!)
print("Today on next year is \(components.year!)/\(components.month!)/\(components.day!)")
returnSet = calendarDate.get(offsetYear:0,offsetMonth:1,offsetDay:0)
components = calendar.dateComponents([.year, .month, .day], from:returnSet.date!)
print("Today on next month is \(components.year!)/\(components.month!)/\(components.day!)")
returnSet = calendarDate.get(offsetYear:0,offsetMonth:0,offsetDay:1)
components = calendar.dateComponents([.year, .month, .day], from:returnSet.date!)
print("Tomorrow is \(components.year!)/\(components.month!)/\(components.day!)")
