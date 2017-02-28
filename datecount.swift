#! /usr/bin/swift
import Foundation
var msg: [String] = ["", "date counter ver.1.3 (c)2015 Takeru-chan\nusage: datecount -[a|b] [n(d)][(n)d][(n)w][(n)m][(n)y]", "datecount: Specified term is not in range A.D.1100..9999."]
var msg_status: Int32 = 0
let month_odr: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
let week_odr: [String] = ["Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"]
var diff = (year:0, month:0, day:0, buffer:"")
// NSDate型の引数を受け取り、NSDateComponents型を返す関数
func getCalComp(date: Date) -> DateComponents {
    let cal: NSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
    let components: DateComponents = cal.components([.year, .month, .day, .weekday], from:date)
    return components
}
// fmt文字列解析
func analyzeStr(fmt_str: String) -> (Int, Int, Int, String) {
    diff.buffer = ""
    chk_char: for char in fmt_str.characters {
        switch char {
        case "d":
            if diff.buffer == "" {
                diff.buffer = "1"
            }
            diff.day = diff.day + Int(diff.buffer)!
            diff.buffer = ""
        case "w":
            if diff.buffer == "" {
                diff.buffer = "1"
            }
            diff.day = diff.day + Int(diff.buffer)! * 7
            diff.buffer = ""
        case "m":
            if diff.buffer == "" {
                diff.buffer = "1"
            }
            diff.month = diff.month + Int(diff.buffer)!
            diff.buffer = ""
        case "y":
            if diff.buffer == "" {
                diff.buffer = "1"
            }
            diff.year = diff.year + Int(diff.buffer)!
            diff.buffer = ""
        case "0","1","2","3","4","5","6","7","8","9":
            diff.buffer = diff.buffer + String(char)
        default:
            msg_status = 1
            break chk_char
        }
    }
    if diff.buffer != "" {
        diff.day = diff.day + Int(diff.buffer)!
        diff.buffer = ""
    }
    if msg_status != 1 {
        if diff.year == 1 {
            msg[0] = "\(diff.year)year "
        } else if diff.year != 0 {
            msg[0] = "\(diff.year)years "
        }
        if diff.month == 1 {
            msg[0] = msg[0] + "\(diff.month)month "
        } else if diff.month != 0 {
            msg[0] = msg[0] + "\(diff.month)months "
        }
        if diff.day == 1 {
            msg[0] = msg[0] + "\(diff.day)day "
        } else if diff.day != 0 {
            msg[0] = msg[0] + "\(diff.day)days "
        }
    }
    return diff
}
// 実質プログラムの始まり
let arguments: [String] = CommandLine.arguments
if arguments.count == 3 {
    switch arguments[1] {
    case "-a":
        analyzeStr(fmt_str:arguments[2])
        msg[0] = msg[0] + "after is "
    case "-b":
        analyzeStr(fmt_str:arguments[2])
        diff.year = -1 * diff.year
        diff.month = -1 * diff.month
        diff.day = -1 * diff.day
        msg[0] = msg[0] + "before is "
    default:
        msg_status = 1
    }
    if msg_status != 1 {
        let now: Date = Date()
        var cal_comp: DateComponents = getCalComp(date:now)
        cal_comp.day = cal_comp.day! + diff.day
        cal_comp.month = cal_comp.month! + diff.month
        cal_comp.year = cal_comp.year! + diff.year
        var result_date: Date = Calendar.current.date(from:cal_comp)!
        cal_comp = getCalComp(date:result_date)
        msg[0] = msg[0] + week_odr[cal_comp.weekday! - 1] + " " + month_odr[cal_comp.month! - 1]
        if cal_comp.year! >= 1100 && cal_comp.year! <= 9999 {
            msg[0] = msg[0] + " \(cal_comp.day!) \(cal_comp.year!)"
        } else {
            msg_status = 2
        }
    }
} else {
    msg_status = 1
}
print("\(msg[Int(msg_status)])\n")
exit(msg_status)
