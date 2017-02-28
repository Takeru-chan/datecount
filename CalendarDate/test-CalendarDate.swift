import Foundation
let calendar: Calendar = Calendar(identifier: .gregorian)
let OkDate: Date = calendar.date(from: DateComponents(year:2017, month:2, day:1))!
let NgDate: Date = calendar.date(from: DateComponents(year:1580, month:2, day:1))!
var returnSet:(date:Date?, status:Bool)
let testDataSet: [(targetDate:Date, offsetYear:Int, offsetMonth:Int, offsetDay:Int)] = [
  (targetDate:OkDate, offsetYear:1, offsetMonth:0, offsetDay:0),
  (targetDate:OkDate, offsetYear:0, offsetMonth:1, offsetDay:0),
  (targetDate:OkDate, offsetYear:0, offsetMonth:0, offsetDay:1),
  (targetDate:OkDate, offsetYear:-500, offsetMonth:0, offsetDay:0),
  (targetDate:NgDate, offsetYear:1, offsetMonth:0, offsetDay:0)]
for n in testDataSet {
  returnSet = CalendarDate().get(targetDate: n.targetDate, offsetYear: n.offsetYear, offsetMonth: n.offsetMonth, offsetDay: n.offsetDay)
  if returnSet.status {
    print("\(calendar.component(.year, from:returnSet.date!))/\(calendar.component(.month, from:returnSet.date!))/\(calendar.component(.day, from:returnSet.date!))")
  } else {
  print(returnSet)
  }
}
