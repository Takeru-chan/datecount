import Foundation
// Condition for datecount version 1.22, 2017.3.17, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
// Usage:
// let arguments:[String] = CommandLine.arguments
// let condition:Condition = Condition(arguments:arguments)
// let resultSet:(status:Int32,silence:Bool,direction:Int) = condition.getResult()
//     status=0:-a/-A/-b/-B/-c/-C, status=1:-v, status=2:-h,
//     status=3:No option, status=4:Unknown option,
//     silence=false:Verbose mode, silence=true:Silence mode
//     direction=1:-a/-A, direction=-1:-b/-B, direction=0:-c/-C
// let dateSet:(target:String?,destination:String?) = condition.getDate()
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
