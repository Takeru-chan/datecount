import Foundation
// test-CalendarDate version 1.33, 2017.3.20, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
let now:Date = Date()
let year:Int = calendar.component(.year, from:now)
let month:Int = calendar.component(.month, from:now)
let day:Int = calendar.component(.day, from:now)
let format:DateFormatter = DateFormatter()
format.dateFormat = "EEE MMM d yyyy"
let today:Date = calendar.date(from: DateComponents(year:year, month:month, day:day))!
var calendarDate:CalendarDate = CalendarDate()
var returnSet:(baseDateString:String, offsetDateString:String,
    differenceString:String, status:Int32) = calendarDate.get(silence:false)
func checkResult(condition:String, baseDateString:String, offsetDateString:String,
    differenceString:String, status:Int32) {
  print(condition,terminator:"")
  if returnSet.baseDateString == baseDateString && returnSet.offsetDateString == offsetDateString &&
        returnSet.differenceString == differenceString && returnSet.status == status {
    print("\u{001B}[0;32m => OK\u{001B}[0;30m \(returnSet)")
  } else {
    print("\u{001B}[0;31m => NG\u{001B}[0;30m")
    if returnSet.baseDateString != baseDateString { print("baseDateString=\(returnSet.baseDateString)") }
    if returnSet.offsetDateString != offsetDateString { print("offsetDateString=\(returnSet.offsetDateString)") }
    if returnSet.differenceString != differenceString { print("differenceString=\(returnSet.differenceString)") }
    if returnSet.status != status { print("status=\(returnSet.status)") }
  }
}
checkResult(condition:"[Blank CalendarDate instance]", baseDateString:"", offsetDateString:"",
      differenceString:"", status:0)
var testCondition:[(condition:String, dateString:String?, commandString:String?, direction:Int,
    baseDateString:String, offsetDateString:String, differenceString:String, status:Int32)] = [
  (condition:"[Set today into baseDate]", dateString:nil, commandString:nil, direction:0,
    baseDateString:format.string(from:today), offsetDateString:"", differenceString:"", status:0),
  (condition:"[Set error string into baseDate]", dateString:"error_string", commandString:nil, direction:0,
    baseDateString:"", offsetDateString:"", differenceString:"", status:6),
  (condition:"[Set 20170201 into baseDate]", dateString:"20170201", commandString:nil, direction:0,
    baseDateString:"Wed Feb 1 2017", offsetDateString:"", differenceString:"", status:0)]
calendarDate = CalendarDate()
for n in testCondition {
  calendarDate.generate(dateString:n.dateString)
  returnSet = calendarDate.get(silence:false)
  checkResult(condition:n.condition, baseDateString:n.baseDateString,
    offsetDateString:n.offsetDateString, differenceString:n.differenceString, status:n.status)
}
testCondition = [
  (condition:"[Set ymwd into commandString and direction is 1]", dateString:nil, commandString:"ymwd",
    direction:1, baseDateString:"Wed Feb 1 2017", offsetDateString:"Fri Mar 9 2018",
    differenceString:"1Year and 1Month and 8Days", status:0),
  (condition:"[Set error string into commandString and direction is 1]", dateString:nil,
    commandString:"error_string", direction:1, baseDateString:"Wed Feb 1 2017", offsetDateString:"",
    differenceString:"", status:5),
  (condition:"[Set ymwd into commandString and direction is -1]", dateString:nil, commandString:"ymwd",
    direction:-1, baseDateString:"Wed Feb 1 2017", offsetDateString:"Thu Dec 24 2015",
    differenceString:"1Year and 1Month and 8Days", status:0),
  (condition:"[Set ymwd into commandString and direction is 0]", dateString:nil, commandString:"ymwd",
    direction:0, baseDateString:"Wed Feb 1 2017", offsetDateString:"", differenceString:"", status:8)]
for n in testCondition {
  calendarDate.adjust(commandString:n.commandString, direction:n.direction)
  returnSet = calendarDate.get(silence:false)
  checkResult(condition:n.condition, baseDateString:n.baseDateString,
    offsetDateString:n.offsetDateString, differenceString:n.differenceString, status:n.status)
}
testCondition = [
  (condition:"[Set today into offsetDate]", dateString:nil, commandString:nil, direction:0,
    baseDateString:"", offsetDateString:format.string(from:today), differenceString:"", status:0),
  (condition:"[Set error string into offsetDate]", dateString:"error_string", commandString:nil, direction:0,
    baseDateString:"", offsetDateString:"", differenceString:"", status:6),
  (condition:"[Set 20170201 into offsetDate]", dateString:"20170201", commandString:nil, direction:0,
    baseDateString:"", offsetDateString:"Wed Feb 1 2017", differenceString:"", status:0)]
calendarDate = CalendarDate()
for n in testCondition {
  calendarDate.offset(dateString:n.dateString)
  returnSet = calendarDate.get(silence:false)
  checkResult(condition:n.condition, baseDateString:n.baseDateString,
    offsetDateString:n.offsetDateString, differenceString:n.differenceString, status:n.status)
}
testCondition = [
  (condition:"[Set ymwd into commandString and direction is 1]", dateString:nil, commandString:"ymwd",
    direction:1, baseDateString:"", offsetDateString:"", differenceString:"", status:9),
  (condition:"[Set error string into commandString and direction is 1]", dateString:nil,
    commandString:"error_string", direction:1, baseDateString:"", offsetDateString:"",
    differenceString:"", status:9),
  (condition:"[Set ymwd into commandString and direction is -1]", dateString:nil, commandString:"ymwd",
    direction:-1, baseDateString:"", offsetDateString:"", differenceString:"", status:9),
  (condition:"[Set ymwd into commandString and direction is 0]", dateString:nil, commandString:"ymwd",
    direction:0, baseDateString:"", offsetDateString:"", differenceString:"", status:9)]
for n in testCondition {
  calendarDate.adjust(commandString:n.commandString, direction:n.direction)
  returnSet = calendarDate.get(silence:false)
  checkResult(condition:n.condition, baseDateString:n.baseDateString,
    offsetDateString:n.offsetDateString, differenceString:n.differenceString, status:n.status)
}
format.dateFormat = "yyyyMMdd"
testCondition = [
  (condition:"[Set 15800101 into baseDate]", dateString:"15800101", commandString:nil, direction:0,
    baseDateString:"", offsetDateString:"", differenceString:"", status:7),
  (condition:"[Set 100000101 into baseDate]", dateString:"100000101", commandString:nil, direction:0,
    baseDateString:"", offsetDateString:"", differenceString:"", status:6),
  (condition:"[Set 99991231 into baseDate]", dateString:"99991231", commandString:nil, direction:0,
    baseDateString:"99991231", offsetDateString:"", differenceString:"", status:0),
  (condition:"[Set 15820101 into baseDate]", dateString:"15820101", commandString:nil, direction:0,
    baseDateString:"15820101", offsetDateString:"", differenceString:"", status:0)]
for n in testCondition {
  calendarDate.generate(dateString:n.dateString)
  returnSet = calendarDate.get(silence:true)
  checkResult(condition:n.condition, baseDateString:n.baseDateString,
    offsetDateString:n.offsetDateString, differenceString:n.differenceString, status:n.status)
}
testCondition = [
  (condition:"[Set mwd into commandString and direction is 1]", dateString:nil, commandString:"mwd",
    direction:1, baseDateString:"15820101", offsetDateString:"15820209",
    differenceString:"1Month and 8Days", status:0),
  (condition:"[Set mwd into commandString and direction is -1]", dateString:nil, commandString:"mwd",
    direction:-1, baseDateString:"15820101", offsetDateString:"", differenceString:"", status:7)]
for n in testCondition {
  calendarDate.adjust(commandString:n.commandString, direction:n.direction)
  returnSet = calendarDate.get(silence:true)
  checkResult(condition:n.condition, baseDateString:n.baseDateString,
    offsetDateString:n.offsetDateString, differenceString:n.differenceString, status:n.status)
}
testCondition = [
  (condition:"[Set 100000101 into offsetDate]", dateString:"100000101", commandString:nil, direction:0,
    baseDateString:"15820101", offsetDateString:"", differenceString:"", status:6),
  (condition:"[Set 15800101 into offsetDate]", dateString:"15800101", commandString:nil, direction:0,
    baseDateString:"15820101", offsetDateString:"", differenceString:"", status:7),
  (condition:"[Set 99991231 into offsetDate]", dateString:"99991231", commandString:nil, direction:0,
    baseDateString:"15820101", offsetDateString:"99991231", differenceString:"", status:0)]
for n in testCondition {
  calendarDate.offset(dateString:n.dateString)
  returnSet = calendarDate.get(silence:true)
  checkResult(condition:n.condition, baseDateString:n.baseDateString,
    offsetDateString:n.offsetDateString, differenceString:n.differenceString, status:n.status)
}
calendarDate.generate(dateString:"99991231")
testCondition = [
  (condition:"[Set d into commandString and direction is 1]", dateString:nil, commandString:"d",
    direction:1, baseDateString:"99991231", offsetDateString:"", differenceString:"", status:7),
  (condition:"[Set d into commandString and direction is -1]", dateString:nil, commandString:"d",
    direction:-1, baseDateString:"99991231", offsetDateString:"99991230", differenceString:"1Day", status:0)]
for n in testCondition {
  calendarDate.adjust(commandString:n.commandString, direction:n.direction)
  returnSet = calendarDate.get(silence:true)
  checkResult(condition:n.condition, baseDateString:n.baseDateString,
    offsetDateString:n.offsetDateString, differenceString:n.differenceString, status:n.status)
}
