import Foundation
// CalendarDate version 1.35, 2017.3.24, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
// Usage:
// let calendarDate:CalendarDate = CalendarDate()
// calendarDate.generate(dateString:"20170317") // To set baseDate. If argument is nil, today is set automatically.
// calendarDate.offset(dateString:"20200724") // To set offsetDate. If argument is nil, today is set automatically.
// calendarDate.adjust(commandString:"3y2m1w", direction:-1) // To set offsetDate with difference from baseDate.
//   // commandString for year is numeric with "y", for month is numeric with "m",
//   //               for week is numeric with "w" and for day is numeric with "d".
//   // direction for future is 1 and for past is -1.
// let returnSet:(baseDateString:String, offsetDateString:String,
//       differenceString:String, dates:Int, status:Int32) = calendarDate.get(silence:true)
//   If silence is true, DateString format is "yyyyMMdd".
//   If silence is false, DateString format is "EEE MMM d yyyy".
//   Returned values are below.
//   If status is 0, terminated normally.
//   If status is 5, commandString format is illegal.
//   If status is 6, dateString format is illegal.
//   If status is 7, Specified term is out of range from A.D.1582 to A.D.9999.
//   If status is 8, direction value is illegal.
//
class CalendarDate {
  private let calendar: Calendar
  private let format:DateFormatter
  private var baseDate:Date?
  private var offsetDate:Date?
  private var differenceYear:Int
  private var differenceMonth:Int
  private var differenceDay:Int
  private var status:Int32
  init (baseDate:Date? = nil, offsetDate:Date? = nil, status:Int32 = -1, format:DateFormatter = DateFormatter(),
        differenceYear:Int = 0, differenceMonth:Int = 0, differenceDay:Int = 0,
        calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) {
    self.calendar = calendar
    self.format = format
    self.baseDate = baseDate
    self.offsetDate = offsetDate
    self.differenceYear = differenceYear
    self.differenceMonth = differenceMonth
    self.differenceDay = differenceDay
    self.status = status
  }
  // This method sets baseDate by string with "yyyyMMdd".
  func generate(dateString:String?) {
    status = 0
    baseDate = self.stringToDate(dateString:dateString)
  }
  // This method sets offsetDate by string with "yyyyMMdd".
  func offset(dateString:String?) {
    if status == 0 {
      offsetDate = self.stringToDate(dateString:dateString)
    }
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
    if status != 0 { return }
    differenceYear = 0
    differenceMonth = 0
    differenceDay = 0
    offsetDate = nil
    if !(direction == -1 || direction == 1) {
      status = 8
      return
    }
    var buffer:String = ""
    for char in commandString!.characters {
      switch char {
      case "d","w","m","y":
        if buffer == "" { buffer = "1" }
        if char == "d" { differenceDay += Int(buffer)! }
        if char == "w" { differenceDay += Int(buffer)! * 7 }
        if char == "m" { differenceMonth += Int(buffer)! }
        if char == "y" { differenceYear += Int(buffer)! }
        buffer = ""
      case "0"..."9":
        buffer += String(char)
      default:
        differenceYear = 0
        differenceMonth = 0
        differenceDay = 0
        status = 5
        return
      }
    }
    if buffer != "" {
      differenceDay += Int(buffer)!
      buffer = ""
    }
    offsetDate = baseDate
    offsetDate = calendar.date(byAdding: .year, value: (differenceYear * direction), to: offsetDate!)
    offsetDate = calendar.date(byAdding: .month, value: (differenceMonth * direction), to: offsetDate!)
    offsetDate = calendar.date(byAdding: .day, value: (differenceDay * direction), to: offsetDate!)
    let year:Int = calendar.component(.year, from:offsetDate!)
    if !(1582...9999 ~= year) {
      differenceYear = 0
      differenceMonth = 0
      differenceDay = 0
      offsetDate = nil
      status = 7
    }
  }
  // This method gets results data set.
  func get(silence:Bool) -> (baseDateString:String, offsetDateString:String,
        differenceString:String, dates:Int, status:Int32) {
    var baseDateString:String = ""
    var offsetDateString:String = ""
    var differenceString:String = ""
    var dates:Int = 0
    if silence {
      format.dateFormat = "yyyyMMdd"
    } else {
      format.dateFormat = "EEE MMM d yyyy"
    }
    if baseDate != nil { baseDateString = format.string(from:baseDate!) }
    if offsetDate != nil { offsetDateString = format.string(from:offsetDate!) }
    switch differenceYear {
      case 0:
        break
      case 1:
        differenceString += "1year"
      default:
        differenceString += "\(differenceYear)years"
    }
    switch differenceMonth {
      case 0:
        break
      case 1:
        if differenceString != "" { differenceString += " and " }
        differenceString += "1month"
      default:
        if differenceString != "" { differenceString += " and " }
        differenceString += "\(differenceMonth)months"
    }
    switch differenceDay {
      case 0:
        break
      case 1:
        if differenceString != "" { differenceString += " and " }
        differenceString += "1day"
      default:
        if differenceString != "" { differenceString += " and " }
        differenceString += "\(differenceDay)days"
    }
    if baseDate != nil && offsetDate != nil {
      dates = calendar.dateComponents([.day], from:baseDate!, to:offsetDate!).day!
    }
    return (baseDateString, offsetDateString, differenceString, dates, status)
  }
}
