import Foundation
// CalendarDate version 1.10, 2017.3.10, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
// Usage:
// let calendarDate:CalendarDate(targetDate: Date?) // If Date is nil, today is set automatically.
// let returnDate:(date:Date?, status:Bool) = calendarDate.get(offsetYear: Int, offsetMonth: Int, offsetDay: Int)
//
class CalendarDate {
  private var targetDate: Date?
  private var returnDate: Date?
  init (targetDate: Date? , returnDate: Date? = nil) {
    self.targetDate = targetDate
    self.returnDate = returnDate
  }
  // This method changes targetDate into returnDate by offsetYear, offsetMonth and offsetDay.
  // Gregorian calendar is available from 1582.
  // If output date is out of range from 1582 to 9999, status is returned as false.
  func get(offsetYear:Int, offsetMonth:Int, offsetDay:Int) -> (Date?, Bool) {
    let calendar: Calendar = Calendar(identifier: .gregorian)
    if targetDate == nil { targetDate = Date() }
    let targetYear: Int = calendar.component(.year, from:targetDate!)
    returnDate = targetDate
    if 1582...9999 ~= targetYear {
      if offsetYear != 0 {
        if returnDate == nil { return (nil, false) }
        returnDate = calendar.date(byAdding: .year, value: offsetYear, to: returnDate!)
      }
      if offsetMonth != 0 {
        if returnDate == nil { return (nil, false) }
        returnDate = calendar.date(byAdding: .month, value: offsetMonth, to: returnDate!)
      }
      if offsetDay != 0 {
        if returnDate == nil { return (nil, false) }
        returnDate = calendar.date(byAdding: .day, value: offsetDay, to: returnDate!)
      }
      let returnYear: Int = calendar.component(.year, from:returnDate!)
      if returnYear < 1582 || returnYear > 9999 {
        return (nil, false)
      } else {
        return (returnDate, true)
      }
    } else {
      return (nil, false)
    }
  }
}
