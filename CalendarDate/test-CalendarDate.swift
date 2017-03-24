import Foundation
// test-CalendarDate version 1.35, 2017.3.24, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
let now:Date = Date()
let year:Int = calendar.component(.year, from:now)
let month:Int = calendar.component(.month, from:now)
let day:Int = calendar.component(.day, from:now)
let format:DateFormatter = DateFormatter()
format.dateFormat = "EEE MMM d yyyy"
let today:Date = calendar.date(from: DateComponents(year:year, month:month, day:day))!
let today_after_ymwd:Date = calendar.date(from: DateComponents(year:(year + 1), month:(month + 1), day:(day + 8)))!
let today_before_ymwd:Date = calendar.date(from: DateComponents(year:(year - 1), month:(month - 1), day:(day - 8)))!

// Check blank instance
var calendarDate:CalendarDate = CalendarDate()
var returnSet:(baseDateString:String, offsetDateString:String,
    differenceString:String, dates:Int, status:Int32) = calendarDate.get(silence:false)
func checkResult(condition:String, baseDateString:String, offsetDateString:String,
    differenceString:String, status:Int32) {
  print(condition,terminator:"")
  if returnSet.baseDateString == baseDateString && returnSet.offsetDateString == offsetDateString &&
        returnSet.differenceString == differenceString && returnSet.status == status {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDateString != baseDateString { print("baseDateString=\(returnSet.baseDateString)") }
    if returnSet.offsetDateString != offsetDateString { print("offsetDateString=\(returnSet.offsetDateString)") }
    if returnSet.differenceString != differenceString { print("differenceString=\(returnSet.differenceString)") }
    if returnSet.status != status { print("status=\(returnSet.status)") }
  }
}
checkResult(condition:"[Blank CalendarDate instance]", baseDateString:"", offsetDateString:"",
      differenceString:"", status:-1)

// Confirm that any methods will fail unless running the generate method.
calendarDate.offset(dateString:"20170201")
returnSet = calendarDate.get(silence:false)
checkResult(condition:"[Set 20170201 into offsetDate]", baseDateString:"", offsetDateString:"",
      differenceString:"", status:-1)
calendarDate.adjust(commandString:"ymwd", direction:1)
returnSet = calendarDate.get(silence:false)
checkResult(condition:"[Set ymwd into commandString and direction is 1]", baseDateString:"", offsetDateString:"",
      differenceString:"", status:-1)
calendarDate.adjust(commandString:"ymwd", direction:-1)
returnSet = calendarDate.get(silence:false)
checkResult(condition:"[Set ymwd into commandString and direction is -1]", baseDateString:"", offsetDateString:"",
      differenceString:"", status:-1)
calendarDate.adjust(commandString:"ymwd", direction:0)
returnSet = calendarDate.get(silence:false)
checkResult(condition:"[Set ymwd into commandString and direction is 0]", baseDateString:"", offsetDateString:"",
      differenceString:"", status:-1)

// Confirm that today's date will be set by running the generate method.
calendarDate.generate(dateString:nil)
returnSet = calendarDate.get(silence:false)
checkResult(condition:"[Set nil into baseDate]", baseDateString:format.string(from:today), offsetDateString:"",
      differenceString:"", status:0)

// Confirm that some methods will success after running the generate method.
calendarDate.offset(dateString:"20170201")
returnSet = calendarDate.get(silence:false)
checkResult(condition:"[Set 20170201 into offsetDate]", baseDateString:format.string(from:today),
      offsetDateString:"Wed Feb 1 2017", differenceString:"", status:0)
calendarDate.adjust(commandString:"ymwd", direction:1)
returnSet = calendarDate.get(silence:false)
checkResult(condition:"[Set ymwd into commandString and direction is 1]", baseDateString:format.string(from:today),
      offsetDateString:format.string(from:today_after_ymwd), differenceString:"1year and 1month and 8days", status:0)
calendarDate.adjust(commandString:"ymwd", direction:-1)
returnSet = calendarDate.get(silence:false)
checkResult(condition:"[Set ymwd into commandString and direction is -1]", baseDateString:format.string(from:today),
      offsetDateString:format.string(from:today_before_ymwd), differenceString:"1year and 1month and 8days", status:0)

// Confirm that adjust method with direction 0 will fail.
calendarDate.adjust(commandString:"ymwd", direction:0)
returnSet = calendarDate.get(silence:false)
checkResult(condition:"[Set ymwd into commandString and direction is 0]", baseDateString:format.string(from:today),
      offsetDateString:"", differenceString:"", status:8)

// Confirmation of execution result on the available range.
calendarDate.generate(dateString:"15811231")
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 15811231 into baseDate]", baseDateString:"", offsetDateString:"",
      differenceString:"", status:7)
calendarDate.generate(dateString:"15820101")
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 15820101 into baseDate]", baseDateString:"15820101", offsetDateString:"",
      differenceString:"", status:0)
calendarDate.adjust(commandString:"ymwd", direction:1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set ymwd into commandString and direction is 1]", baseDateString:"15820101",
      offsetDateString:"15830209", differenceString:"1year and 1month and 8days", status:0)
calendarDate.adjust(commandString:"ymwd", direction:-1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set ymwd into commandString and direction is -1]", baseDateString:"15820101",
      offsetDateString:"", differenceString:"", status:7)
calendarDate.generate(dateString:"100000101")
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 100000101 into baseDate]", baseDateString:"", offsetDateString:"",
      differenceString:"", status:6)
calendarDate.generate(dateString:"99991231")
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 99991231 into baseDate]", baseDateString:"99991231", offsetDateString:"",
      differenceString:"", status:0)
calendarDate.adjust(commandString:"ymwd", direction:-1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set ymwd into commandString and direction is -1]", baseDateString:"99991231",
      offsetDateString:"99981122", differenceString:"1year and 1month and 8days", status:0)
calendarDate.adjust(commandString:"ymwd", direction:1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set ymwd into commandString and direction is 1]", baseDateString:"99991231",
      offsetDateString:"", differenceString:"", status:7)
calendarDate.generate(dateString:"20170201")
calendarDate.offset(dateString:"15820101")
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 15820101 into offsetDate]", baseDateString:"20170201", offsetDateString:"15820101",
      differenceString:"", status:0)
calendarDate.offset(dateString:"99991231")
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 99991231 into offsetDate]", baseDateString:"20170201", offsetDateString:"99991231",
      differenceString:"", status:0)
calendarDate.offset(dateString:"15811231")
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 15811231 into offsetDate]", baseDateString:"20170201", offsetDateString:"",
      differenceString:"", status:7)
calendarDate.generate(dateString:"20170201")
calendarDate.offset(dateString:"100000101")
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 100000101 into offsetDate]", baseDateString:"20170201", offsetDateString:"",
      differenceString:"", status:6)

// Confirmation of execution result of the adjust method.
calendarDate.generate(dateString:"20170201")
calendarDate.adjust(commandString:"3y", direction:1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 3y into commandString and direction is 1]", baseDateString:"20170201",
      offsetDateString:"20200201", differenceString:"3years", status:0)
calendarDate.adjust(commandString:"3y", direction:-1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 3y into commandString and direction is -1]", baseDateString:"20170201",
      offsetDateString:"20140201", differenceString:"3years", status:0)
calendarDate.adjust(commandString:"2m", direction:1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 2m into commandString and direction is 1]", baseDateString:"20170201",
      offsetDateString:"20170401", differenceString:"2months", status:0)
calendarDate.adjust(commandString:"2m", direction:-1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 2m into commandString and direction is -1]", baseDateString:"20170201",
      offsetDateString:"20161201", differenceString:"2months", status:0)
calendarDate.adjust(commandString:"5w", direction:1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 5w into commandString and direction is 1]", baseDateString:"20170201",
      offsetDateString:"20170308", differenceString:"35days", status:0)
calendarDate.adjust(commandString:"5w", direction:-1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 5w into commandString and direction is -1]", baseDateString:"20170201",
      offsetDateString:"20161228", differenceString:"35days", status:0)
calendarDate.adjust(commandString:"8", direction:1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 8 into commandString and direction is 1]", baseDateString:"20170201",
      offsetDateString:"20170209", differenceString:"8days", status:0)
calendarDate.adjust(commandString:"8", direction:-1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 8 into commandString and direction is -1]", baseDateString:"20170201",
      offsetDateString:"20170124", differenceString:"8days", status:0)
calendarDate.adjust(commandString:"2y3m", direction:1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 2y3m into commandString and direction is 1]", baseDateString:"20170201",
      offsetDateString:"20190501", differenceString:"2years and 3months", status:0)
calendarDate.adjust(commandString:"2y3m", direction:-1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 2y3m into commandString and direction is -1]", baseDateString:"20170201",
      offsetDateString:"20141101", differenceString:"2years and 3months", status:0)
calendarDate.adjust(commandString:"m6d", direction:1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set m6d into commandString and direction is 1]", baseDateString:"20170201",
      offsetDateString:"20170307", differenceString:"1month and 6days", status:0)
calendarDate.adjust(commandString:"m6d", direction:-1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set m6d into commandString and direction is -1]", baseDateString:"20170201",
      offsetDateString:"20161226", differenceString:"1month and 6days", status:0)
calendarDate.adjust(commandString:"7y9", direction:1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 7y9 into commandString and direction is 1]", baseDateString:"20170201",
      offsetDateString:"20240210", differenceString:"7years and 9days", status:0)
calendarDate.adjust(commandString:"7y9", direction:-1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set 7y9 into commandString and direction is -1]", baseDateString:"20170201",
      offsetDateString:"20100123", differenceString:"7years and 9days", status:0)

// Confirmation of some errors.
calendarDate = CalendarDate()
calendarDate.generate(dateString:"error_string")
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set error_string into dateString]", baseDateString:"",
      offsetDateString:"", differenceString:"", status:6)
calendarDate = CalendarDate()
calendarDate.generate(dateString:"20170201")
calendarDate.offset(dateString:"error_string")
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set error_string into offsetString]", baseDateString:"20170201",
      offsetDateString:"", differenceString:"", status:6)
calendarDate = CalendarDate()
calendarDate.generate(dateString:"20170201")
calendarDate.adjust(commandString:"error_string", direction:1)
returnSet = calendarDate.get(silence:true)
checkResult(condition:"[Set error_string into offsetString]", baseDateString:"20170201",
      offsetDateString:"", differenceString:"", status:5)

// Confirmation of counting dates.
calendarDate.generate(dateString:"20170201")
calendarDate.offset(dateString:"20160201")
returnSet = calendarDate.get(silence:true)
  print("[Set 20170201 to baseDateString and set 20160201 to offsetDateString]",terminator:"")
  if returnSet.baseDateString == "20170201" && returnSet.offsetDateString == "20160201" &&
        returnSet.differenceString == "" && returnSet.dates == -366 && returnSet.status == 0 {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDateString != "20170201" { print("baseDateString=\(returnSet.baseDateString)") }
    if returnSet.offsetDateString != "20160201" { print("offsetDateString=\(returnSet.offsetDateString)") }
    if returnSet.differenceString != "" { print("differenceString=\(returnSet.differenceString)") }
    if returnSet.dates != -366 { print("status=\(returnSet.status)") }
    if returnSet.status != 0 { print("status=\(returnSet.status)") }
  }
calendarDate.offset(dateString:"20180201")
returnSet = calendarDate.get(silence:true)
  print("[Set 20170201 to baseDateString and set 20180201 to offsetDateString]",terminator:"")
  if returnSet.baseDateString == "20170201" && returnSet.offsetDateString == "20180201" &&
        returnSet.differenceString == "" && returnSet.dates == 365 && returnSet.status == 0 {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDateString != "20170201" { print("baseDateString=\(returnSet.baseDateString)") }
    if returnSet.offsetDateString != "20180201" { print("offsetDateString=\(returnSet.offsetDateString)") }
    if returnSet.differenceString != "" { print("differenceString=\(returnSet.differenceString)") }
    if returnSet.dates != 365 { print("status=\(returnSet.status)") }
    if returnSet.status != 0 { print("status=\(returnSet.status)") }
  }
