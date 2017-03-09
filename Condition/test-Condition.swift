import Foundation
// test-CalendarDate version 1.00, 2017.3.9, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
let calendar: Calendar = Calendar(identifier: .gregorian)
let Date20170201: Date = calendar.date(from: DateComponents(year:2017, month:2, day:1))!
let testCondition:[(condition:[String], status:Int, date:Date?, year:Int, month:Int, day:Int)] = [
    (condition:["No_option"], status:3, date:nil, year:0, month:0, day:0),
    (condition:["Show_version","-v"], status:1, date:nil, year:0, month:0, day:0),
    (condition:["Show_help","-h"], status:2, date:nil, year:0, month:0, day:0),
    (condition:["Today_affer_5days","-a","5d"], status:0, date:nil, year:0, month:0, day:5),
    (condition:["Today_before_3years","-b","3y"], status:0, date:nil, year:-3, month:0, day:0),
    (condition:["Indicated_day_after_3days","-a","3","20170201"], status:0, date:Date20170201, year:0, month:0, day:3),
    (condition:["Switch_error","-X"], status:4, date:nil, year:0, month:0, day:0),
    (condition:["Command_error","-b","3x"], status:5, date:nil, year:0, month:0, day:-3),
    (condition:["Date_error","-a","3","2017/2/1"], status:6, date:nil, year:0, month:0, day:3)]
for n in testCondition {
  let condition:Condition = Condition()
  print("[Test condition:\(n.condition)]")
  condition.analyzeSwitch(arguments:n.condition)
  if condition.getStatus() == n.status && condition.getDate() == n.date && condition.getOffsetYear() == n.year && condition.getOffsetMonth() == n.month && condition.getOffsetDay() == n.day {
    print("OK")
  } else if condition.getStatus() != n.status {
    print("Status is NG:\(condition.getStatus())")
  } else if condition.getDate() != n.date {
    print("Date is NG:\(condition.getDate())")
  } else if condition.getOffsetYear() != n.year {
    print("OffsetYear is NG:\(condition.getOffsetYear())")
  } else if condition.getOffsetMonth() != n.month {
    print("OffsetMonth is NG:\(condition.getOffsetMonth())")
  } else if condition.getOffsetDay() != n.day {
    print("OffsetDay is NG:\(condition.getOffsetDay())")
  }
}
