// test-Devices version 1.00, 2017.3.1, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
import Foundation
let screen = Screen()
let pasteboard = Pasteboard()
let message = "Test message"
print("If string below is '\(message)', it is OK.")
screen.write(message:message)
print("Original pasteboard contains '\(pasteboard.read())'.")
pasteboard.write(message:message)
print("And now, pasteboard contains '\(pasteboard.read())'.")
