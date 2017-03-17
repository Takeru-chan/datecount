import Foundation
// Condition for datecount version 1.22, 2017.3.17, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
// Usage:
// let arguments:[String] = CommandLine.arguments
// let condition:Condition = Condition(arguments:arguments)
// let resultSet:(status:Int32,silence:Bool,direction:Int) = condition.getResultSet()
//     status=0:-a/-A/-b/-B/-c/-C, status=1:-v, status=2:-h,
//     status=3:No option, status=4:Unknown option,
//     silence=false:Verbose mode, silence=true:Silence mode
//     direction=1:-a/-A, direction=-1:-b/-B, direction=0:-c/-C
// let dateSet:(target:String?,destination:String?) = condition.getDateSet()
// let adjustCommand:String? = condition.getAdjustCommand()
//
class Condition {
  private var arguments:[String]
  private var status:Int32
  private var silence:Bool
  private var direction:Int
  private var targetDate:String?
  private var destinationDate:String?
  private var adjustCommand:String?
  init (arguments:[String], status:Int32 = 0, silence:Bool = false, direction:Int = 0,
    targetDate:String? = nil, destinationDate:String? = nil, adjustCommand:String? = nil) {
    self.arguments = arguments
    self.status = status
    self.silence = silence
    self.direction = direction
    self.targetDate = targetDate
    self.destinationDate = destinationDate
    self.adjustCommand = adjustCommand
    self.analyze()
  }
  // This method sets status from arguments data set.
  func analyze(){
    if !(2...5 ~= arguments.count) {
      status = 3
    } else {
      switch arguments[1] {
        case "-v":
          status = 1
        case "-h":
          status = 2
        case "-a","-A":
          if 3...4 ~= arguments.count {
            adjustCommand = arguments[2]
            direction = 1
            if arguments[1] == "-A" { silence = true }
            if arguments.count == 4 { targetDate = arguments[3] }
          } else { status = 4 }
        case "-b","-B":
          if 3...4 ~= arguments.count {
            adjustCommand = arguments[2]
            direction = -1
            if arguments[1] == "-B" { silence = true }
            if arguments.count == 4 { targetDate = arguments[3] }
          } else { status = 4 }
        case "-c","-C":
          if 3...4 ~= arguments.count {
            destinationDate = arguments[2]
            if arguments[1] == "-C" { silence = true }
            if arguments.count == 4 { targetDate = arguments[3] }
          } else { status = 4 }
        default:
          status = 4
      }
    }
 }

  func getResult() -> (status:Int32, silence:Bool, direction:Int) {
    return (status, silence, direction)
  }
  func getDate() -> (targetDate:String?, destinationDate:String?) {
    return (targetDate, destinationDate)
  }
  func getAdjustCommand() -> String? {
    return adjustCommand
  }
}


#if TEST
// test-CalendarDate version 1.22, 2017.3.17, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
let testCondition:[(condition:[String], status:Int32, silence:Bool, direction:Int, target:String?, destination:String?, adjustCommand:String?)] = [(condition:["show_version","-v"], status:1, silence:false, direction:0, target:nil, destination:nil, adjustCommand:nil),
        (condition:["show_help","-h"], status:2, silence:false, direction:0, target:nil, destination:nil, adjustCommand:nil),
        (condition:["no_option"], status:3, silence:false, direction:0, target:nil, destination:nil, adjustCommand:nil),
        (condition:["option_error_unknown_switch","--"], status:4, silence:false, direction:0, target:nil, destination:nil, adjustCommand:nil),
        (condition:["option_error_surplus","-a","3","20170201","surplus"], status:4, silence:false, direction:0, target:nil, destination:nil, adjustCommand:nil),
        (condition:["command_error","-a","cmdErr"], status:0, silence:false, direction:1, target:nil, destination:nil, adjustCommand:"cmdErr"),
        (condition:["date_error","-a","3","123456789"], status:0, silence:false, direction:1, target:"123456789", destination:nil, adjustCommand:"3"),
        (condition:["date_error","-a","3","abcdefgh"], status:0, silence:false, direction:1, target:"abcdefgh", destination:nil, adjustCommand:"3"),
        (condition:["today_after_ymd_verbose","-a","ymd"], status:0, silence:false, direction:1, target:nil, destination:nil, adjustCommand:"ymd"),
        (condition:["today_after_ymd_silent","-A","ymd"], status:0, silence:true, direction:1, target:nil, destination:nil, adjustCommand:"ymd"),
        (condition:["indicated_date_after_ymd_verbose","-a","ymd","20170201"], status:0, silence:false, direction:1, target:"20170201", destination:nil, adjustCommand:"ymd"),
        (condition:["indicated_date_after_ymd_silent","-A","ymd","20170201"], status:0, silence:true, direction:1, target:"20170201", destination:nil, adjustCommand:"ymd"),
        (condition:["today_before_ymd_verbose","-b","ymd"], status:0, silence:false, direction:-1, target:nil, destination:nil, adjustCommand:"ymd"),
        (condition:["today_before_ymd_silent","-B","ymd"], status:0, silence:true, direction:-1, target:nil, destination:nil, adjustCommand:"ymd"),
        (condition:["20170201_befor_ymd_verbose","-b","ymd","20170201"], status:0, silence:false, direction:-1, target:"20170201", destination:nil, adjustCommand:"ymd"),
        (condition:["20170201_before_ymd_silent","-B","ymd","20170201"], status:0, silence:true, direction:-1, target:"20170201", destination:nil, adjustCommand:"ymd"),
        (condition:["between_from_today_to_20180201_verbose","-c","20180201"], status:0, silence:false, direction:0, target:nil, destination:"20180201", adjustCommand:nil),
        (condition:["between_from_today_to_20180201_silent","-C","20180201"], status:0, silence:true, direction:0, target:nil, destination:"20180201", adjustCommand:nil),
        (condition:["between_from_20170201_to_20180201_verbose","-c","20180201","20170201"], status:0, silence:false, direction:0, target:"20170201", destination:"20180201", adjustCommand:nil),
        (condition:["between_from_20170201_to_20180201_silent","-C","20180201","20170201"], status:0, silence:true, direction:0, target:"20170201", destination:"20180201", adjustCommand:nil)]
for n in testCondition {
  let condition:Condition = Condition(arguments:n.condition)
  print("[Test Condition:\(n.condition)]", terminator:"")
  let resultSet:(status:Int32, silence:Bool, direction:Int) = condition.getResult()
  let dateSet:(targetDate:String?, destinationDate:String?) = condition.getDate()
  let adjustCommand:String? = condition.getAdjustCommand()
  if resultSet.status != n.status {
    print("\n\u{001B}[0;31m status is \(resultSet.status). => NG\u{001B}[0;30m")
  } else if resultSet.silence != n.silence {
    print("\n\u{001B}[0;31m silence mode is \(resultSet.silence). => NG\u{001B}[0;30m")
  } else if dateSet.targetDate != n.target {
    print("\n\u{001B}[0;31m target date is \(dateSet.targetDate). => NG\u{001B}[0;30m")
  } else if dateSet.destinationDate != n.destination {
    print("\n\u{001B}[0;31m destination date is \(dateSet.destinationDate). => NG\u{001B}[0;30m")
  } else if adjustCommand != n.adjustCommand {
    print("\n\u{001B}[0;31m adjust command is \(adjustCommand). => NG\u{001B}[0;30m")
  } else {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m")
  }
}
#endif
