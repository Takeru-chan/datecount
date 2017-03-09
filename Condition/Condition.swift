import Foundation
// Condition for datecount version 1.01, 2017.3.10, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
class Condition {
  private var status:Int
  private var targetDate:Date?
  private var offsetYear:Int
  private var offsetMonth:Int
  private var offsetDay:Int
  init (status:Int = 0, targetDate:Date? = nil,
    offsetYear:Int = 0, offsetMonth:Int = 0, offsetDay:Int = 0) {
    self.status = status
    self.targetDate = targetDate
    self.offsetYear = offsetYear
    self.offsetMonth = offsetMonth
    self.offsetDay = offsetDay
  }
  // This method sets status from arguments data set.
  // Status code is as below.
  // 1:Show version number, 2:Show help message, 3:No option,
  // 4:Option switch error, 5:Offset command error, 6:Date setting error
  func analyzeSwitch(arguments:[String]){
		if !(2...4 ~= arguments.count) {
      status = 3
    } else if arguments.count == 2 {
      switch arguments[1] {
        case "-v":
          status = 1
        case "-h":
          status = 2
        default:
          status = 4
      }
    } else {
      if arguments.count == 4 { self.checkDate(dateString:arguments[3]) }
      self.checkCommand(commandString:arguments[2])
      if arguments[1] == "-b" {
        offsetYear *= -1
        offsetMonth *= -1
        offsetDay *= -1
      } else if arguments[1] != "-a" {
        status = 4
      }
    }
  }
  // This method targetDate from arguments data set.
  func checkDate(dateString:String) {
    if dateString.characters.count != 8 { status = 6 }
    for char in dateString.characters {
      switch char {
        case "0"..."9":
          break
        default:
          status = 6
      }
    }
    if status != 6 {
      let yearIndex = dateString.index(dateString.startIndex, offsetBy:4)
      let dayIndex = dateString.index(dateString.endIndex, offsetBy:-2)
      let monthIndex = dateString.index(after:yearIndex)
      let range = monthIndex..<dayIndex
      let yearString:String = dateString.substring(to:yearIndex)
      let monthString:String = dateString.substring(with:range)
      let dayString:String = dateString.substring(from:dayIndex)
      let calendar:Calendar = Calendar(identifier:.gregorian)
      targetDate = calendar.date(from:DateComponents(year:Int(yearString), month:Int(monthString), day:Int(dayString)))
    }
  }
  // This method gets offsetYear, offsetMonth, offsetDay from arguments data set.
  func checkCommand(commandString:String) {
    var buffer = ""
    chk_char: for char in commandString.characters {
        switch char {
        case "d":
            if buffer == "" { buffer = "1" }
            offsetDay += Int(buffer)!
            buffer = ""
        case "w":
            if buffer == "" { buffer = "1" }
            offsetDay += Int(buffer)! * 7
            buffer = ""
        case "m":
            if buffer == "" { buffer = "1" }
            offsetMonth += Int(buffer)!
            buffer = ""
        case "y":
            if buffer == "" { buffer = "1" }
            offsetYear += Int(buffer)!
            buffer = ""
        case "0"..."9":
            buffer += String(char)
        default:
            status = 5
            break chk_char
        }
    }
    if buffer != "" {
        offsetDay += Int(buffer)!
        buffer = ""
    }
    return
  }

  func getStatus() -> Int {
    return status
  }
  func getDate() -> Date? {
    return targetDate
  }
  func getOffsetYear() -> Int {
    return offsetYear
  }
  func getOffsetMonth() -> Int {
    return offsetMonth
  }
  func getOffsetDay() -> Int {
    return offsetDay
  }
}
