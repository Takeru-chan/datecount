import Foundation
let screen:Screen = Screen()
let leadHelpMessage:String = "For more information, type 'datecount -h'.\n"
var message:[String] = []
message.append("")
message.append("datecount ver.1.62  2017.3.26 (c)Takeru.\n")
message.append("\(message[1])")
message[2] += "Usage:\n"
message[2] += "    datecount -[a|A|b|B] command [fromDate]\n"
message[2] += "    datecount -[c|C] toDate [fromDate]\n"
message[2] += "    datecount -h\n"
message[2] += "    datecount -v\n\n"
message[2] += "Description:\n"
message[2] += "    The datecount utility counts dates.\n"
message[2] += "    To return the date or number of days from the indicated date.\n\n"
message[2] += "    -a    Return after date from today or fromDate.\n"
message[2] += "    -A    Return after date from today or fromDate.(Silence mode)\n"
message[2] += "    -b    Return before date from today or fromDate.\n"
message[2] += "    -B    Return before date from today or fromDate.(Silence mode)\n"
message[2] += "    -c    Return number of days from today or fromDate to toDate.\n"
message[2] += "    -C    Return number of days from today or fromDate to toDate.(Silence mode)\n"
message[2] += "    -h    Display this credit.\n"
message[2] += "    -v    Display version.\n\n"
message[2] += "    Command to forward/backward the date should be combined\n"
message[2] += "    numerics and unit symbols. If numerics are omitted,\n"
message[2] += "    1 is applied for its unit.\n\n"
message[2] += "     d    Unit for day.(Symbol may be omitted.)\n"
message[2] += "     w    Unit for week.\n"
message[2] += "     m    Unit for month.\n"
message[2] += "     y    Unit for year.\n\n"
message[2] += "    Date format should be four digits for year, two digits\n"
message[2] += "    for month and two ditits for day. And effective range\n"
message[2] += "    is from A.D.1582 to A.D.9999.\n\n"
message[2] += "    Copyright (c) 2015 Takeru.\n"
message[2] += "    Released under MIT license\n"
message[2] += "    http://opensource.org/licenses/MIT\n"
message.append("datecount: Some options are needed.\n\(leadHelpMessage)")
message.append("datecount: Unknown option.\n\(leadHelpMessage)")
message.append("datecount: Unknown command format.\n\(leadHelpMessage)")
message.append("datecount: Unknown date format.\n\(leadHelpMessage)")
message.append("datecount: Specified term is out of range from A.D.1582 to A.D.9999.\n\(leadHelpMessage)")
let direction:[String] = ["before", "after"]
let arguments:[String] = CommandLine.arguments
let condition:Condition = Condition(arguments:arguments)
let resultSet:(status:Int32,silence:Bool,direction:Int) = condition.getResult()
var returnCode:Int32 = resultSet.status
if returnCode == 0 {
  let dateSet:(targetDate:String?,destinationDate:String?) = condition.getDate()
  let adjustCommand:String? = condition.getAdjustCommand()
  let calendarDate:CalendarDate = CalendarDate()
  calendarDate.generate(dateString:dateSet.targetDate)
  if resultSet.direction != 0 {
    calendarDate.adjust(commandString:adjustCommand, direction:resultSet.direction)
  } else {
    calendarDate.offset(dateString:dateSet.destinationDate)
  }
  let returnDate:(baseDateString:String, offsetDateString:String,
      differenceString:String, dates:Int, status:Int32) = calendarDate.get(silence:resultSet.silence)
  returnCode = returnDate.status
  if returnCode == 0 {
    switch resultSet.direction {
      case 0:
        if resultSet.silence {
          message[0] = String(returnDate.dates)
        } else {
          message[0] = "\(returnDate.offsetDateString) is "
          if returnDate.dates == 0 {
            message[0] = "\(message[0])today\n"
          } else if abs(returnDate.dates) == 1 {
            message[0] = "\(message[0])1day \(direction[(resultSet.direction + 1)/2]) \(returnDate.baseDateString)\n"
          } else {
            message[0] = "\(message[0])\(abs(returnDate.dates))days \(direction[(resultSet.direction + 1)/2]) \(returnDate.baseDateString)\n"
          }
        }
      default:
        message[0] = returnDate.offsetDateString
        if returnDate.differenceString != "" && !(resultSet.silence) {
          if abs(resultSet.direction) == 1 {
            message[0] = "\(returnDate.differenceString) \(direction[(resultSet.direction + 1)/2]) \(returnDate.baseDateString) is \(message[0])\n"
          }
        } else if !(resultSet.silence) {
          message[0] = "Today is \(message[0])\n"
        }
    }
  }
}
screen.write(message:message[Int(returnCode)])
exit(Int32(returnCode))
