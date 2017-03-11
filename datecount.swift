#! /usr/bin/swift
import Foundation
let screen:Screen = Screen()
let version:String = "datecount ver.1.40  2017.3.11 (c)Takeru.\n"
let help:String = "Usage:\n    datecount -[a|b] [n(d)][(n)d][(n)w][(n)m][(n)y] [yyyymmdd]\n    datecount -h\n    datecount -v\n\nDescription:\n    The datecount utility counts dates.\n    To return the date from the indicated date.\n\n    -a    Return after date from the indicated date.\n    -b    Return before date from the indicated date.\n    -h    Display this credit.\n    -v    Display version.\n\n    Command to forward/backward the date should be combined\n    numerics and unit symbols. If numerics are omitted,\n    1 is applied for its unit.\n\n     d    Unit for day.(Symbol may be omitted.)\n     w    Unit for week.\n     m    Unit for month.\n     y    Unit for year.\n\n    Date format should be four digits for year, two digits\n    for month and two ditits for day. And effective range\n    is from A.D.1582 to A.D.9999.\n\n"
let license:String = "    Copyright (c) 2015 Takeru.\n    Released under MIT license\n    http://opensource.org/licenses/MIT\n"
let dateRangeError:String = "datecount: Specified term is out of range from A.D.1582 to A.D.9999.\n"
let needOptionError:String = "datecount: Some options are needed.\n"
let unknownError:String = "datecount: Unknown option.\n"
let dateFormatError:String = "datecount: Unknown date format.\n"
let dateCommandError:String = "datecount: Unknown command format.\n"
let leadHelpMessage:String = "For more information, type 'datecount -h'.\n"
let monthOrder:[String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
let weekOrder:[String] = ["Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"]
var leadText:String = ""
let arguments:[String] = CommandLine.arguments
let condition:Condition = Condition()
condition.analyzeSwitch(arguments:arguments)
let status:Int = condition.getStatus()
switch status {
  case 0:
    let targetYear:Int = condition.getTargetYear()
    let targetMonth:Int = condition.getTargetMonth()
    let targetDay:Int = condition.getTargetDay()
    var offsetYear:Int = condition.getOffsetYear()
    var offsetMonth:Int = condition.getOffsetMonth()
    var offsetDay:Int = condition.getOffsetDay()
    let calendarDate:CalendarDate = CalendarDate(targetYear:targetYear, targetMonth:targetMonth, targetDay:targetDay)
    let returnSet:(date:Date?, status:Int) = calendarDate.get(offsetYear:offsetYear, offsetMonth:offsetMonth, offsetDay:offsetDay)
    if returnSet.status == 0 {
      screen.write(message:dateRangeError+leadHelpMessage)
      break
    }
    let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let components = calendar.dateComponents([.year, .month, .day, .weekday], from:returnSet.date!)
    offsetYear = abs(offsetYear)
    if offsetYear == 1 {
      leadText = "\(offsetYear)year "
    } else if offsetYear != 0 {
      leadText = "\(offsetYear)years "
    }
    offsetMonth = abs(offsetMonth)
    if offsetMonth == 1 {
      leadText += "\(offsetMonth)month "
    } else if offsetMonth != 0 {
      leadText += "\(offsetMonth)months "
    }
    offsetDay = abs(offsetDay)
    if offsetDay == 1 {
      leadText += "\(offsetDay)day "
    } else if offsetDay != 0 {
      leadText += "\(offsetDay)days "
    }
    if returnSet.status == 1 {
      leadText += "after "
    } else {
      leadText += "before "
    }
    if targetYear == 0 && targetMonth == 0 && targetDay == 0 {
      if offsetYear == 0 && offsetMonth == 0 && offsetDay == 0 {
        leadText = "Today is "
      } else {
        leadText += "today is "
      }
    } else {
      leadText += "\(monthOrder[targetMonth - 1]) \(targetDay) \(targetYear) is "
    }
    let result:String = "\(weekOrder[components.weekday! - 1]) \(monthOrder[components.month! - 1]) \(components.day!) \(components.year!)\n"
    screen.write(message:leadText+result)
  case 1:
    screen.write(message:version)
  case 2:
    screen.write(message:version+help+license)
  case 3:
    screen.write(message:needOptionError+leadHelpMessage)
  case 4:
    screen.write(message:unknownError+leadHelpMessage)
  case 5:
    screen.write(message:dateCommandError+leadHelpMessage)
  case 6:
    screen.write(message:dateFormatError+leadHelpMessage)
  default:
    break
}
exit(Int32(status))
