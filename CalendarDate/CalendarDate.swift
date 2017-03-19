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
