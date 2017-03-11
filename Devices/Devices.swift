// Screen version 1.00, 2017.2.11, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
class Screen {
  // This method displays message into console.
  func write(message:String) {
    print(message)
  }
}
// Pasteboard version 1.00, 2017.3.1, (c)2017 Takeru-chan
// Released under the MIT license. http://opensource.org/licenses/MIT
import Cocoa    // Pasteboard device is required.
class Pasteboard {
  private let board: NSPasteboard
  private let item: NSPasteboardItem
  init(board: NSPasteboard = NSPasteboard.general(), item: NSPasteboardItem = NSPasteboardItem()) {
    self.board = board
    self.item = item
  }
  // This method stores message into pasteboard.
  func write(message:String) {
    board.clearContents()
    item.setString(message, forType: NSPasteboardTypeString)
    board.writeObjects([item])
  }
  // This method reads message from pasteboard.
  func read() -> String {
    guard let content: String = board.string(forType: NSPasteboardTypeString) else { return "" }
    return content
  }
}
