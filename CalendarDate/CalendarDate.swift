import Foundation
// CalendarDate version 1.30, 2017.3.17, (c)2017 Takeru-chan
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
  // If baseDate is not set, status is returned 6 as false.
  func generate(dateString:String?) {
		status = 0
    baseDate = self.stringToDate(dateString:dateString)
    if baseDate == nil { status = 6 }
  }
  // This method sets offsetDate by string with "yyyyMMdd".
  // If offsetDate is not set, status is returned 6 as false.
  func offset(dateString:String?) {
		status = 0
    offsetDate = self.stringToDate(dateString:dateString)
    if offsetDate == nil { status = 6 }
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
    return date
  }
  // This method sets offsetDate by commandString with "nynmnwnd" and sets direction by 1/-1.
  // If commandString or direction is unknown format, returns 5 as illegal status.
  func adjust(commandString:String?, direction:Int) {
    if direction != 1 && direction != -1 {
      status = 5
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
    if baseDate != nil {
      offsetDate = baseDate
      offsetDate = calendar.date(byAdding: .year, value: (offsetYear * direction), to: offsetDate!)
      offsetDate = calendar.date(byAdding: .month, value: (offsetMonth * direction), to: offsetDate!)
      offsetDate = calendar.date(byAdding: .day, value: (offsetDay * direction), to: offsetDate!)
    }
  }
  // This method gets results data set.
  // Gregorian calendar is available from 1582.
  // If output date is out of range from 1582 to 9999, status is returned 7 as false.
  func get() -> (baseDate:Date?, offsetDate:Date?, status:Int32) {
    if baseDate != nil {
      let baseYear:Int = calendar.component(.year, from:baseDate!)
      if !(1582...9999 ~= baseYear) {
        status = 7
      }
    }
    if offsetDate != nil {
      let offsetYear:Int = calendar.component(.year, from:offsetDate!)
      if !(1582...9999 ~= offsetYear) {
        status = 7
      }
    }
    return (baseDate, offsetDate, status)
  }
}


#if TEST
// test-CalendarDate version 1.30, 2017.3.17, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
let now:Date = Date()
let year:Int = calendar.component(.year, from:now)
let month:Int = calendar.component(.month, from:now)
let day:Int = calendar.component(.day, from:now)
let today:Date = calendar.date(from: DateComponents(year:year, month:month, day:day))!
let date20170201:Date = calendar.date(from: DateComponents(year:2017, month:2, day:1))!
var calendarDate:CalendarDate = CalendarDate()
var returnSet:(baseDate:Date?, offsetDate:Date?, status:Int32) = calendarDate.get()
print("[Blank CalendarDate instance]",terminator:"")
if returnSet.baseDate == nil && returnSet.offsetDate == nil && returnSet.status == 0 {
	print(" => OK")
} else {
	print(" => NG")
	if returnSet.baseDate != nil { print("baseDate=\(returnSet.baseDate)") }
	if returnSet.offsetDate != nil { print("offsetDate=\(returnSet.offsetDate)") }
	if returnSet.status != 0 { print("status=\(returnSet.status)") }
}
var testCondition:[(condition:String, dateString:String?, baseDate:Date?, offsetDate:Date?, status:Int32)] = [(condition:"[Set today into baseDate]", dateString:nil, baseDate:today, offsetDate:nil, status:0),
	(condition:"[Set error string into baseDate]", dateString:"error_string", baseDate:nil, offsetDate:nil, status:6),
	(condition:"[Set 20170201 into baseDate]", dateString:"20170201", baseDate:date20170201, offsetDate:nil, status:0)]
calendarDate = CalendarDate()
for n in testCondition {
	calendarDate.generate(dateString:n.dateString)
	returnSet = calendarDate.get()
	print(n.condition,terminator:"")
	if returnSet.baseDate == n.baseDate && returnSet.offsetDate == n.offsetDate && returnSet.status == n.status {
		print(" => OK")
	} else {
		print(" => NG")
		if returnSet.baseDate != n.baseDate { print("baseDate=\(returnSet.baseDate)") }
		if returnSet.offsetDate != n.offsetDate { print("offsetDate=\(returnSet.offsetDate)") }
		if returnSet.status != n.status { print("status=\(returnSet.status)") }
	}
}
testCondition = [(condition:"[Set today into offsetDate]", dateString:nil, baseDate:nil, offsetDate:today, status:0),
	(condition:"[Set error string into offsetDate]", dateString:"error_string", baseDate:nil, offsetDate:nil, status:6),
	(condition:"[Set 20170201 into offsetDate]", dateString:"20170201", baseDate:nil, offsetDate:date20170201, status:0)]
calendarDate = CalendarDate()
for n in testCondition {
	calendarDate.offset(dateString:n.dateString)
	returnSet = calendarDate.get()
	print(n.condition,terminator:"")
	if returnSet.baseDate == n.baseDate && returnSet.offsetDate == n.offsetDate && returnSet.status == n.status {
		print(" => OK")
	} else {
		print(" => NG")
		if returnSet.baseDate != n.baseDate { print("baseDate=\(returnSet.baseDate)") }
		if returnSet.offsetDate != n.offsetDate { print("offsetDate=\(returnSet.offsetDate)") }
		if returnSet.status != n.status { print("status=\(returnSet.status)") }
	}
}
/*
caldate.generate(dateString:nil)
print(caldate.get())
caldate.offset(dateString:"20150317")
print(caldate.get())
let caldate2 = CalendarDate()
caldate2.generate(dateString:"19680201")
print(caldate2.get())
caldate2.adjust(commandString:"5y3m2w4d", direction:1)
print(caldate2.get())
caldate2.generate(dateString:"1980201")
print(caldate2.get())
*/
#endif
