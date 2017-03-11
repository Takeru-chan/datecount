import Foundation
// test-CalendarDate version 1.10, 2017.3.11, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
let testCondition:[(condition:[String], status:Int, targetYear:Int, targetMonth:Int, targetDay:Int, offsetYear:Int, offsetMonth:Int, offsetDay:Int)] = [
    (condition:["No_option"], status:3, targetYear:0, targetMonth:0, targetDay:0, offsetYear:0, offsetMonth:0, offsetDay:0),
    (condition:["Show_version","-v"], status:1, targetYear:0, targetMonth:0, targetDay:0, offsetYear:0, offsetMonth:0, offsetDay:0),
    (condition:["Show_help","-h"], status:2, targetYear:0, targetMonth:0, targetDay:0, offsetYear:0, offsetMonth:0, offsetDay:0),
    (condition:["Today_affer_5days","-a","5d"], status:0, targetYear:0, targetMonth:0, targetDay:0, offsetYear:0, offsetMonth:0, offsetDay:5),
    (condition:["Today_before_3years","-b","3y"], status:0, targetYear:0, targetMonth:0, targetDay:0, offsetYear:-3, offsetMonth:0, offsetDay:0),
    (condition:["Indicated_day_after_3days","-a","3","20170201"], status:0, targetYear:2017, targetMonth:2, targetDay:1, offsetYear:0, offsetMonth:0, offsetDay:3),
    (condition:["Switch_error","-X"], status:4, targetYear:0, targetMonth:0, targetDay:0, offsetYear:0, offsetMonth:0, offsetDay:0),
    (condition:["Command_error","-b","3x"], status:5, targetYear:0, targetMonth:0, targetDay:0, offsetYear:0, offsetMonth:0, offsetDay:-3),
    (condition:["Date_error","-a","3","2017/2/1"], status:6, targetYear:0, targetMonth:0, targetDay:0, offsetYear:0, offsetMonth:0, offsetDay:3)]
for n in testCondition {
  let condition:Condition = Condition()
  print("[Test condition:\(n.condition)]")
  condition.analyzeSwitch(arguments:n.condition)
  if condition.getStatus() == n.status && condition.getTargetYear() == n.targetYear && condition.getTargetMonth() == n.targetMonth && condition.getTargetDay() == n.targetDay && condition.getOffsetYear() == n.offsetYear && condition.getOffsetMonth() == n.offsetMonth && condition.getOffsetDay() == n.offsetDay {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m")
  } else if condition.getStatus() != n.status {
    print("\u{001B}[0;31m => Status is NG:\(condition.getStatus())\u{001B}[0;30m")
  } else if condition.getTargetYear() != n.targetYear {
    print("\u{001B}[0;31m => TargetYear is NG:\(condition.getTargetYear())\u{001B}[0;30m")
  } else if condition.getTargetMonth() != n.targetMonth {
    print("\u{001B}[0;31m => TargetMonth is NG:\(condition.getTargetMonth())\u{001B}[0;30m")
  } else if condition.getTargetDay() != n.targetDay {
    print("\u{001B}[0;31m => TargetDay is NG:\(condition.getTargetDay())\u{001B}[0;30m")
  } else if condition.getOffsetYear() != n.offsetYear {
    print("\u{001B}[0;31m => OffsetYear is NG:\(condition.getOffsetYear())\u{001B}[0;30m")
  } else if condition.getOffsetMonth() != n.offsetMonth {
    print("\u{001B}[0;31m => OffsetMonth is NG:\(condition.getOffsetMonth())\u{001B}[0;30m")
  } else if condition.getOffsetDay() != n.offsetDay {
    print("\u{001B}[0;31m => OffsetDay is NG:\(condition.getOffsetDay())\u{001B}[0;30m")
  }
}
