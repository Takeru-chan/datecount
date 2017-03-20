import Foundation
let screen:Screen = Screen()
let version:String = "datecount ver.1.50  2017.3.21 (c)Takeru.\n"
let help:String = "Usage:\n    datecount -[a|A|b|B] [n(d)][(n)d][(n)w][(n)m][(n)y] [yyyymmdd]\n    datecount -h\n    datecount -v\n\nDescription:\n    The datecount utility counts dates.\n    To return the date from the indicated date.\n\n    -a    Return after date from the indicated date.\n    -A    Return after date from the indicated date.(Silence mode)\n    -b    Return before date from the indicated date.\n    -B    Return before date from the indicated date.(Silence mode)\n    -h    Display this credit.\n    -v    Display version.\n\n    Command to forward/backward the date should be combined\n    numerics and unit symbols. If numerics are omitted,\n    1 is applied for its unit.\n\n     d    Unit for day.(Symbol may be omitted.)\n     w    Unit for week.\n     m    Unit for month.\n     y    Unit for year.\n\n    Date format should be four digits for year, two digits\n    for month and two ditits for day. And effective range\n    is from A.D.1582 to A.D.9999.\n\n"
let license:String = "    Copyright (c) 2015 Takeru.\n    Released under MIT license\n    http://opensource.org/licenses/MIT\n"
let needOptionError:String = "datecount: Some options are needed.\n"
let unknownError:String = "datecount: Unknown option.\n"
let dateCommandError:String = "datecount: Unknown command format.\n"
let dateFormatError:String = "datecount: Unknown date format.\n"
let dateRangeError:String = "datecount: Specified term is out of range from A.D.1582 to A.D.9999.\n"
let leadHelpMessage:String = "For more information, type 'datecount -h'.\n"
let direction:[String] = ["before", "after"]
var leadText:String = ""
let arguments:[String] = CommandLine.arguments
let condition:Condition = Condition(arguments:arguments)
let resultSet:(status:Int32,silence:Bool,direction:Int) = condition.getResult()
switch resultSet.status {
  case 0:
    let dateSet:(targetDate:String?,destinationDate:String?) = condition.getDate()
    let adjustCommand:String? = condition.getAdjustCommand()
    let calendarDate:CalendarDate = CalendarDate()
    calendarDate.generate(dateString:dateSet.targetDate)
    calendarDate.adjust(commandString:adjustCommand, direction:resultSet.direction)
    let returnDate:(baseDateString:String, offsetDateString:String,
        differenceString:String, status:Int32) = calendarDate.get(silence:resultSet.silence)
    if returnDate.status == 0 {
      if returnDate.differenceString != "" {
        if resultSet.direction == -1 {
          leadText = "\(returnDate.differenceString) \(direction[0]) \(returnDate.baseDateString)"
        } else {
          leadText = "\(returnDate.differenceString) \(direction[1]) \(returnDate.baseDateString)"
        }
      } else {
        leadText = "Today"
      }
      if resultSet.silence {
        screen.write(message:returnDate.offsetDateString)
      } else {
        screen.write(message:"\(leadText) is \(returnDate.offsetDateString)\n")
      }
    } else if returnDate.status == 5 {
      screen.write(message:dateCommandError+leadHelpMessage)
    } else if returnDate.status == 6 {
      screen.write(message:dateFormatError+leadHelpMessage)
    } else if returnDate.status == 7 {
      screen.write(message:dateRangeError+leadHelpMessage)
    }
		exit(Int32(returnDate.status))
  case 1:
    screen.write(message:version)
  case 2:
    screen.write(message:version+help+license)
  case 3:
    screen.write(message:needOptionError+leadHelpMessage)
  case 4:
    screen.write(message:unknownError+leadHelpMessage)
  default:
    break
}
exit(Int32(resultSet.status))

