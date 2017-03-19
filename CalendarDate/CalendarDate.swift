import Foundation
// CalendarDate version 1.31, 2017.3.19, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
// Usage:
// let calendarDate:CalendarDate = CalendarDate()
// calendarDate.generate(dateString:"20170317") // To set baseDate. If argument is nil, today is set automatically.
// calendarDate.offset(dateString:"20200724") // To set offsetDate. If argument is nil, today is set automatically.
// calendarDate.adjust(commandString:"3y2m1w", direction:-1) // To set offsetDate with difference from baseDate.
//   // commandString for year is numeric with "y", for month is numeric with "m",
//   //               for week is numeric with "w" and for day is numeric with "d".
//   // direction for future is 1 and for past is -1.
// let returnDate:(baseDate:Date?, offsetDate:Date?, status:Int32) = calendarDate.get()
//   Returned values are below.
//   If status is 0, terminated normally.
//   If status is 5, commandString format is illegal.
//   If status is 6, dateString format is illegal.
//   If status is 7, Specified term is out of range from A.D.1582 to A.D.9999.
//   If status is 8, direction value is illegal.
//   If status is 9, adjust method error.
//
class CalendarDate {
  private let calendar: Calendar
  private var baseDate:Date?
  private var offsetDate:Date?
  private var status:Int32
  init (baseDate:Date? = nil, offsetDate:Date? = nil, status:Int32 = 0,
        calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) {
    self.calendar = calendar
    self.baseDate = baseDate
    self.offsetDate = offsetDate
    self.status = status
  }
  // This method sets baseDate by string with "yyyyMMdd".
  func generate(dateString:String?) {
    status = 0
    baseDate = self.stringToDate(dateString:dateString)
  }
  // This method sets offsetDate by string with "yyyyMMdd".
  func offset(dateString:String?) {
    status = 0
    offsetDate = self.stringToDate(dateString:dateString)
  }
  // This method is used by generate() or offset().
  func stringToDate(dateString:String?) -> Date? {
    var date:Date?
    if dateString == nil {
      let now:Date = Date()
      let year:Int = calendar.component(.year, from: now)
      let month:Int = calendar.component(.month, from: now)
      let day:Int = calendar.component(.day, from: now)
      date = calendar.date(from: DateComponents(year:year, month:month, day:day))!
    } else {
      let format:DateFormatter = DateFormatter()
      format.dateFormat = "yyyyMMdd"
      date = format.date(from: dateString!)
    }
    if date == nil {
      status = 6
    } else {
      let year:Int = calendar.component(.year, from:date!)
      if !(1582...9999 ~= year) {
        date = nil
        status = 7
      }
    }
    return date
  }
  // This method sets offsetDate by commandString with "nynmnwnd" and sets direction by 1/-1.
  func adjust(commandString:String?, direction:Int) {
    status = 0
    offsetDate = nil
    if baseDate == nil {
      status = 9
      return
    }
    if direction != 1 && direction != -1 {
      status = 8
      return
    }
    var buffer:String = ""
    var offsetYear:Int = 0
    var offsetMonth:Int = 0
    var offsetDay:Int = 0
    for char in commandString!.characters {
      switch char {
      case "d","w","m","y":
        if buffer == "" { buffer = "1" }
        if char == "d" { offsetDay += Int(buffer)! }
        if char == "w" { offsetDay += Int(buffer)! * 7 }
        if char == "m" { offsetMonth += Int(buffer)! }
        if char == "y" { offsetYear += Int(buffer)! }
        buffer = ""
      case "0"..."9":
        buffer += String(char)
      default:
        status = 5
        return
      }
    }
    if buffer != "" {
      offsetDay += Int(buffer)!
      buffer = ""
    }
    offsetDate = baseDate
    offsetDate = calendar.date(byAdding: .year, value: (offsetYear * direction), to: offsetDate!)
    offsetDate = calendar.date(byAdding: .month, value: (offsetMonth * direction), to: offsetDate!)
    offsetDate = calendar.date(byAdding: .day, value: (offsetDay * direction), to: offsetDate!)
    let year:Int = calendar.component(.year, from:offsetDate!)
    if !(1582...9999 ~= year) {
      offsetDate = nil
      status = 7
    }
  }
  // This method gets results data set.
  func get() -> (baseDate:Date?, offsetDate:Date?, status:Int32) {
    return (baseDate, offsetDate, status)
  }
}


#if TEST
// test-CalendarDate version 1.31, 2017.3.19, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
let now:Date = Date()
let year:Int = calendar.component(.year, from:now)
let month:Int = calendar.component(.month, from:now)
let day:Int = calendar.component(.day, from:now)
let today:Date = calendar.date(from: DateComponents(year:year, month:month, day:day))!
let ymwd_after_today:Date = calendar.date(from: DateComponents(year:(year + 1), month:(month + 1), day:(day + 8)))!
let ymwd_before_today:Date = calendar.date(from: DateComponents(year:(year - 1), month:(month - 1), day:(day - 8)))!
let date20170201:Date = calendar.date(from: DateComponents(year:2017, month:2, day:1))!
let date20180309:Date = calendar.date(from: DateComponents(year:2018, month:3, day:9))!
let date20151224:Date = calendar.date(from: DateComponents(year:2015, month:12, day:24))!
let date15820101:Date = calendar.date(from: DateComponents(year:1582, month:1, day:1))!
let date99991231:Date = calendar.date(from: DateComponents(year:9999, month:12, day:31))!
let date15830209:Date = calendar.date(from: DateComponents(year:1583, month:2, day:9))!
let date99981122:Date = calendar.date(from: DateComponents(year:9998, month:11, day:22))!
var calendarDate:CalendarDate = CalendarDate()
var returnSet:(baseDate:Date?, offsetDate:Date?, status:Int32) = calendarDate.get()
print("[Blank CalendarDate instance]",terminator:"")
if returnSet.baseDate == nil && returnSet.offsetDate == nil && returnSet.status == 0 {
  print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
} else {
  print("\u{001B}[0;31m => NG\u{001B}[0;30m")
  if returnSet.baseDate != nil { print("baseDate=\(returnSet.baseDate)") }
  if returnSet.offsetDate != nil { print("offsetDate=\(returnSet.offsetDate)") }
  if returnSet.status != 0 { print("status=\(returnSet.status)") }
}
var testCondition:[(condition:String, dateString:String?, commandString:String?, direction:Int, baseDate:Date?, offsetDate:Date?, status:Int32)] = [
  (condition:"[Set today into baseDate]", dateString:nil, commandString:nil, direction:0, baseDate:today, offsetDate:nil, status:0),
  (condition:"[Set error string into baseDate]", dateString:"error_string", commandString:nil, direction:0, baseDate:nil, offsetDate:nil, status:6),
  (condition:"[Set 20170201 into baseDate]", dateString:"20170201", commandString:nil, direction:0, baseDate:date20170201, offsetDate:nil, status:0)]
calendarDate = CalendarDate()
for n in testCondition {
  calendarDate.generate(dateString:n.dateString)
  returnSet = calendarDate.get()
  print(n.condition,terminator:"")
  if returnSet.baseDate == n.baseDate && returnSet.offsetDate == n.offsetDate && returnSet.status == n.status {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDate != n.baseDate { print("baseDate=\(returnSet.baseDate)") }
    if returnSet.offsetDate != n.offsetDate { print("offsetDate=\(returnSet.offsetDate)") }
    if returnSet.status != n.status { print("status=\(returnSet.status)") }
  }
}
testCondition = [
  (condition:"[Set ymwd into commandString and direction is 1]", dateString:nil, commandString:"ymwd", direction:1, baseDate:date20170201, offsetDate:date20180309, status:0),
  (condition:"[Set error string into commandString and direction is 1]", dateString:nil, commandString:"error_string", direction:1, baseDate:date20170201, offsetDate:nil, status:5),
  (condition:"[Set ymwd into commandString and direction is -1]", dateString:nil, commandString:"ymwd", direction:-1, baseDate:date20170201, offsetDate:date20151224, status:0),
  (condition:"[Set ymwd into commandString and direction is 0]", dateString:nil, commandString:"ymwd", direction:0, baseDate:date20170201, offsetDate:nil, status:8)]
for n in testCondition {
  calendarDate.adjust(commandString:n.commandString, direction:n.direction)
  returnSet = calendarDate.get()
  print(n.condition,terminator:"")
  if returnSet.baseDate == n.baseDate && returnSet.offsetDate == n.offsetDate && returnSet.status == n.status {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDate != n.baseDate { print("baseDate=\(returnSet.baseDate)") }
    if returnSet.offsetDate != n.offsetDate { print("offsetDate=\(returnSet.offsetDate)") }
    if returnSet.status != n.status { print("status=\(returnSet.status)") }
  }
}
testCondition = [
  (condition:"[Set today into offsetDate]", dateString:nil, commandString:nil, direction:0, baseDate:nil, offsetDate:today, status:0),
  (condition:"[Set error string into offsetDate]", dateString:"error_string", commandString:nil, direction:0, baseDate:nil, offsetDate:nil, status:6),
  (condition:"[Set 20170201 into offsetDate]", dateString:"20170201", commandString:nil, direction:0, baseDate:nil, offsetDate:date20170201, status:0)]
calendarDate = CalendarDate()
for n in testCondition {
  calendarDate.offset(dateString:n.dateString)
  returnSet = calendarDate.get()
  print(n.condition,terminator:"")
  if returnSet.baseDate == n.baseDate && returnSet.offsetDate == n.offsetDate && returnSet.status == n.status {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDate != n.baseDate { print("baseDate=\(returnSet.baseDate)") }
    if returnSet.offsetDate != n.offsetDate { print("offsetDate=\(returnSet.offsetDate)") }
    if returnSet.status != n.status { print("status=\(returnSet.status)") }
  }
}
testCondition = [
  (condition:"[Set ymwd into commandString and direction is 1]", dateString:nil, commandString:"ymwd", direction:1, baseDate:nil, offsetDate:nil, status:9),
  (condition:"[Set error string into commandString and direction is 1]", dateString:nil, commandString:"error_string", direction:1, baseDate:nil, offsetDate:nil, status:9),
  (condition:"[Set ymwd into commandString and direction is -1]", dateString:nil, commandString:"ymwd", direction:-1, baseDate:nil, offsetDate:nil, status:9),
  (condition:"[Set ymwd into commandString and direction is 0]", dateString:nil, commandString:"ymwd", direction:0, baseDate:nil, offsetDate:nil, status:9)]
for n in testCondition {
  calendarDate.adjust(commandString:n.commandString, direction:n.direction)
  returnSet = calendarDate.get()
  print(n.condition,terminator:"")
  if returnSet.baseDate == n.baseDate && returnSet.offsetDate == n.offsetDate && returnSet.status == n.status {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDate != n.baseDate { print("baseDate=\(returnSet.baseDate)") }
    if returnSet.offsetDate != n.offsetDate { print("offsetDate=\(returnSet.offsetDate)") }
    if returnSet.status != n.status { print("status=\(returnSet.status)") }
  }
}
testCondition = [
  (condition:"[Set 15800101 into baseDate]", dateString:"15800101", commandString:nil, direction:0, baseDate:nil, offsetDate:nil, status:7),
  (condition:"[Set 100000101 into baseDate]", dateString:"100000101", commandString:nil, direction:0, baseDate:nil, offsetDate:nil, status:6),
  (condition:"[Set 99991231 into baseDate]", dateString:"99991231", commandString:nil, direction:0, baseDate:date99991231, offsetDate:nil, status:0),
  (condition:"[Set 15820101 into baseDate]", dateString:"15820101", commandString:nil, direction:0, baseDate:date15820101, offsetDate:nil, status:0)]
for n in testCondition {
  calendarDate.generate(dateString:n.dateString)
  returnSet = calendarDate.get()
  print(n.condition,terminator:"")
  if returnSet.baseDate == n.baseDate && returnSet.offsetDate == n.offsetDate && returnSet.status == n.status {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDate != n.baseDate { print("baseDate=\(returnSet.baseDate)") }
    if returnSet.offsetDate != n.offsetDate { print("offsetDate=\(returnSet.offsetDate)") }
    if returnSet.status != n.status { print("status=\(returnSet.status)") }
  }
}
testCondition = [
  (condition:"[Set ymwd into commandString and direction is 1]", dateString:nil, commandString:"ymwd", direction:1, baseDate:date15820101, offsetDate:date15830209, status:0),
  (condition:"[Set ymwd into commandString and direction is -1]", dateString:nil, commandString:"ymwd", direction:-1, baseDate:date15820101, offsetDate:nil, status:7)]
for n in testCondition {
  calendarDate.adjust(commandString:n.commandString, direction:n.direction)
  returnSet = calendarDate.get()
  print(n.condition,terminator:"")
  if returnSet.baseDate == n.baseDate && returnSet.offsetDate == n.offsetDate && returnSet.status == n.status {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDate != n.baseDate { print("baseDate=\(returnSet.baseDate)") }
    if returnSet.offsetDate != n.offsetDate { print("offsetDate=\(returnSet.offsetDate)") }
    if returnSet.status != n.status { print("status=\(returnSet.status)") }
  }
}
testCondition = [
  (condition:"[Set 100000101 into offsetDate]", dateString:"100000101", commandString:nil, direction:0, baseDate:date15820101, offsetDate:nil, status:6),
  (condition:"[Set 15800101 into offsetDate]", dateString:"15800101", commandString:nil, direction:0, baseDate:date15820101, offsetDate:nil, status:7),
  (condition:"[Set 99991231 into offsetDate]", dateString:"99991231", commandString:nil, direction:0, baseDate:date15820101, offsetDate:date99991231, status:0)]
for n in testCondition {
  calendarDate.offset(dateString:n.dateString)
  returnSet = calendarDate.get()
  print(n.condition,terminator:"")
  if returnSet.baseDate == n.baseDate && returnSet.offsetDate == n.offsetDate && returnSet.status == n.status {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDate != n.baseDate { print("baseDate=\(returnSet.baseDate)") }
    if returnSet.offsetDate != n.offsetDate { print("offsetDate=\(returnSet.offsetDate)") }
    if returnSet.status != n.status { print("status=\(returnSet.status)") }
  }
}
calendarDate.generate(dateString:"99991231")
testCondition = [
  (condition:"[Set ymwd into commandString and direction is 1]", dateString:nil, commandString:"ymwd", direction:1, baseDate:date99991231, offsetDate:nil, status:7),
  (condition:"[Set ymwd into commandString and direction is -1]", dateString:nil, commandString:"ymwd", direction:-1, baseDate:date99991231, offsetDate:date99981122, status:0)]
for n in testCondition {
  calendarDate.adjust(commandString:n.commandString, direction:n.direction)
  returnSet = calendarDate.get()
  print(n.condition,terminator:"")
  if returnSet.baseDate == n.baseDate && returnSet.offsetDate == n.offsetDate && returnSet.status == n.status {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDate != n.baseDate { print("baseDate=\(returnSet.baseDate)") }
    if returnSet.offsetDate != n.offsetDate { print("offsetDate=\(returnSet.offsetDate)") }
    if returnSet.status != n.status { print("status=\(returnSet.status)") }
  }
}
#endif
