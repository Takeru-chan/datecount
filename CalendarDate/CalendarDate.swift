import Foundation
// CalendarDate version 1.20, 2017.3.11, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
// Usage:
// let calendarDate:CalendarDate(targetYear:Int, targetMonth:Int, targetDay:Int) // If arguments are 0, today is set automatically.
// let returnDate:(date:Date?, status:Bool) = calendarDate.get(offsetYear: Int, offsetMonth: Int, offsetDay: Int)
//   Returned values are below.
//   If status is 0, date is nil by something error.
//   If status is 1, date is future.
//   If status is -1, date is past.
//
class CalendarDate {
  private var targetYear:Int
  private var targetMonth:Int
  private var targetDay:Int
  private var returnDate:Date?
  init (targetYear:Int, targetMonth:Int, targetDay:Int, returnDate:Date? = nil) {
    self.targetYear = targetYear
    self.targetMonth = targetMonth
    self.targetDay = targetDay
    self.returnDate = returnDate
  }
  // This method changes targetDate into returnDate by offsetYear, offsetMonth and offsetDay.
  // Gregorian calendar is available from 1582.
  // If output date is out of range from 1582 to 9999, status is returned as false.
  func get(offsetYear:Int, offsetMonth:Int, offsetDay:Int) -> (Date?, Int) {
    let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    guard var targetDate:Date = calendar.date(from: DateComponents(year:targetYear, month:targetMonth, day:targetDay)) else { return (nil, 0) }
    if targetYear == 0 && targetMonth == 0 && targetDay == 0 {
      targetDate = Date()
      targetYear = calendar.component(.year, from: targetDate)
    }
    returnDate = targetDate
    if 1582...9999 ~= targetYear {
      if offsetYear != 0 {
        if returnDate == nil { return (nil, 0) }
        returnDate = calendar.date(byAdding: .year, value: offsetYear, to: returnDate!)
      }
      if offsetMonth != 0 {
        if returnDate == nil { return (nil, 0) }
        returnDate = calendar.date(byAdding: .month, value: offsetMonth, to: returnDate!)
      }
      if offsetDay != 0 {
        if returnDate == nil { return (nil, 0) }
        returnDate = calendar.date(byAdding: .day, value: offsetDay, to: returnDate!)
      }
      let returnYear: Int = calendar.component(.year, from:returnDate!)
      if 1582...9999 ~= returnYear {
        if targetDate < returnDate! {
          return (returnDate, 1)
        } else {
          return (returnDate, -1)
        }
      } else {
        return (nil, 0)
      }
    } else {
      return (nil, 0)
    }
  }
}
