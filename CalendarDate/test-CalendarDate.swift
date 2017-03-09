import Foundation
// test-CalendarDate version 1.10, 2017.3.10, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
let calendar: Calendar = Calendar(identifier: .gregorian)
let Date20170201: Date = calendar.date(from: DateComponents(year:2017, month:2, day:1))!
let Date20160201: Date = calendar.date(from: DateComponents(year:2016, month:2, day:1))!
let Date15800201: Date = calendar.date(from: DateComponents(year:1580, month:2, day:1))!
let Date20180201: Date = calendar.date(from: DateComponents(year:2018, month:2, day:1))!
let Date20170301: Date = calendar.date(from: DateComponents(year:2017, month:3, day:1))!
let Date20170202: Date = calendar.date(from: DateComponents(year:2017, month:2, day:2))!
let Date20200504: Date = calendar.date(from: DateComponents(year:2020, month:5, day:4))!
let Date20131029: Date = calendar.date(from: DateComponents(year:2013, month:10, day:29))!
let Date15170201: Date = calendar.date(from: DateComponents(year:1517, month:2, day:1))!
let Date20160229: Date = calendar.date(from: DateComponents(year:2016, month:2, day:29))!
let Date15810201: Date = calendar.date(from: DateComponents(year:1581, month:2, day:1))!
let Date15820201: Date = calendar.date(from: DateComponents(year:1582, month:2, day:1))!
let Date99991201: Date = calendar.date(from: DateComponents(year:9999, month:12, day:1))!
let Date100000101: Date = calendar.date(from: DateComponents(year:10000, month:1, day:1))!
let Date120170201: Date = calendar.date(from: DateComponents(year:12017, month:2, day:1))!
let Date120170202: Date = calendar.date(from: DateComponents(year:12017, month:2, day:2))!
var returnSet:(date:Date?, status:Bool)
let testDataSet: [(condition:String, targetDate:Date, offsetYear:Int, offsetMonth:Int, offsetDay:Int, returnDate:Date)] = [
  (condition:"2017/2/1 after 1 year", targetDate:Date20170201, offsetYear:1, offsetMonth:0, offsetDay:0, returnDate:Date20180201),
  (condition:"2017/2/1 after 1 month", targetDate:Date20170201, offsetYear:0, offsetMonth:1, offsetDay:0, returnDate:Date20170301),
  (condition:"2017/2/1 after 1 day", targetDate:Date20170201, offsetYear:0, offsetMonth:0, offsetDay:1, returnDate:Date20170202),
  (condition:"2017/2/1 after 3 years, 3 months and 3 days", targetDate:Date20170201, offsetYear:3, offsetMonth:3, offsetDay:3, returnDate:Date20200504),
  (condition:"2017/2/1 before 3 years, 3 months and 3 days", targetDate:Date20170201, offsetYear:-3, offsetMonth:-3, offsetDay:-3, returnDate:Date20131029),
  (condition:"2017/2/1 before 500 years", targetDate:Date20170201, offsetYear:-500, offsetMonth:0, offsetDay:0, returnDate:Date15170201),
  (condition:"2017/2/1 after 28 days", targetDate:Date20170201, offsetYear:0, offsetMonth:0, offsetDay:28, returnDate:Date20170301),
  (condition:"2016/2/1 after 28 days", targetDate:Date20160201, offsetYear:0, offsetMonth:0, offsetDay:28, returnDate:Date20160229),
  (condition:"1580/2/1 after 1 year", targetDate:Date15800201, offsetYear:1, offsetMonth:0, offsetDay:0, returnDate:Date15810201),
  (condition:"1581/2/1 after 1 year", targetDate:Date15810201, offsetYear:1, offsetMonth:0, offsetDay:0, returnDate:Date15820201),
  (condition:"1582/2/1 before 1 year", targetDate:Date15820201, offsetYear:-1, offsetMonth:0, offsetDay:0, returnDate:Date15810201),
  (condition:"9999/12/1 after 1 month", targetDate:Date99991201, offsetYear:0, offsetMonth:1, offsetDay:0, returnDate:Date100000101),
  (condition:"10000/1/1 before 1 month", targetDate:Date100000101, offsetYear:0, offsetMonth:-1, offsetDay:0, returnDate:Date99991201),
  (condition:"12017/2/1 after 1 day", targetDate:Date120170201, offsetYear:0, offsetMonth:0, offsetDay:1, returnDate:Date120170202)]
for n in testDataSet {
  returnSet = CalendarDate(targetDate: n.targetDate).get(offsetYear: n.offsetYear, offsetMonth: n.offsetMonth, offsetDay: n.offsetDay)
  print("[Test condition: \(n.condition)]")
  if returnSet.status {
    print("\(calendar.component(.year, from:returnSet.date!))/\(calendar.component(.month, from:returnSet.date!))/\(calendar.component(.day, from:returnSet.date!))", terminator:"")
    if returnSet.date! == n.returnDate { print("\u{001B}[0;32m => OK\u{001B}[0;30m") } else { print("\u{001B}[0;31m => NG\u{001B}[0;30m") }
  } else {
    print(returnSet, terminator:"")
    if returnSet.date == nil { print("\u{001B}[0;32m => OK\u{001B}[0;30m") } else { print("\u{001B}[0;31m => NG\u{001B}[0;30m") }
  }
}
let calendarDate:CalendarDate = CalendarDate(targetDate:nil)
returnSet = calendarDate.get(offsetYear:1,offsetMonth:0,offsetDay:0)
print("Today on next year is \(returnSet.date!)")
