import Foundation
// CalendarDate version 1.00, 2017.2.28, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
class CalendarDate {
  private var returnDate: Date?
  init (returnDate: Date? = nil) {
    self.returnDate = returnDate
  }
  // This method changes targetDate into returnDate by offsetYear, offsetMonth and offsetDay.
  // Gregorian calendar is available from 1582.
  // If output date is out of range from 1582 to 9999, status is returned as false.
  func get(targetDate:Date, offsetYear:Int, offsetMonth:Int, offsetDay:Int) -> (Date?, Bool) {
    let calendar: Calendar = Calendar(identifier: .gregorian)
    let targetYear: Int = calendar.component(.year, from:targetDate)
    returnDate = targetDate
    if targetYear < 1582 || targetYear > 9999 {
      return (nil, false)
    } else {
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
    }
  }
}
