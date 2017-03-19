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
