import Foundation
// Condition for datecount version 1.10, 2017.3.11, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
// Usage:
// let arguments:[String] = CommandLine.arguments
// let condition:Condition = Condition()
// condition.analyzeSwitch(arguments:arguments)
// let status:Int = condition.getStatus()
// if status == 0 {
//   let targetYear:Int = condition.getTargetYear()   // Year of target date. If target date is not indicated, it returns 0.
//   let targetMonth:Int = condition.getTargetMonth() // Month of target date. If target date is not indicated, it returns 0.
//   let targetDay:Int = condition.getTargetDay()     // Day of target date. If target date is not indicated, it returns 0.
//   let offsetYear:Int = condition.getOffsetYear()   // Difference of year from target date.
//   let offsetMonth:Int = condition.getOffsetMonth() // Difference of month from target date.
//   let offsetDay:Int = condition.getOffsetDay()     // Difference of day from target date.
// }
//
class Condition {
  private var status:Int
  private var targetYear:Int
  private var targetMonth:Int
  private var targetDay:Int
  private var offsetYear:Int
  private var offsetMonth:Int
  private var offsetDay:Int
  init (status:Int = 0, targetYear:Int = 0, targetMonth:Int = 0, targetDay:Int = 0,
    offsetYear:Int = 0, offsetMonth:Int = 0, offsetDay:Int = 0) {
    self.status = status
    self.targetYear = targetYear
    self.targetMonth = targetMonth
    self.targetDay = targetDay
    self.offsetYear = offsetYear
    self.offsetMonth = offsetMonth
    self.offsetDay = offsetDay
  }
  // This method sets status from arguments data set.
  // Status code is as below.
  // 0:Terminate normally, 1:Show version number, 2:Show help message, 3:No option,
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
  // This method targetYear, targetMonth and targetDay from arguments data set.
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
      targetYear = Int(dateString.substring(to:yearIndex))!
      targetMonth = Int(dateString.substring(with:range))!
      targetDay = Int(dateString.substring(from:dayIndex))!
    }
  }
  // This method gets offsetYear, offsetMonth and offsetDay from arguments data set.
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
  func getTargetYear() -> Int {
    return targetYear
  }
  func getTargetMonth() -> Int {
    return targetMonth
  }
  func getTargetDay() -> Int {
    return targetDay
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
